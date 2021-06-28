// Copyright 2015 The go-ethereum Authors
// This file is part of the go-ethereum library.
//
// The go-ethereum library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-ethereum library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-ethereum library. If not, see <http://www.gnu.org/licenses/>.

package core

import (
	"fmt"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus"
	"github.com/ethereum/go-ethereum/consensus/misc"
	"github.com/ethereum/go-ethereum/core/state"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/core/vm"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/log"
	"github.com/ethereum/go-ethereum/params"
)

// StateProcessor is a basic Processor, which takes care of transitioning
// state from one point to another.
//
// StateProcessor implements Processor.
type StateProcessor struct {
	config *params.ChainConfig // Chain configuration options
	bc     *BlockChain         // Canonical block chain
	engine consensus.Engine    // Consensus engine used for block rewards
	txpool *TxPool             // Transaction Pool to keep track of confirmed transactions
}

// NewStateProcessor initialises a new StateProcessor.
func NewStateProcessor(config *params.ChainConfig, bc *BlockChain, engine consensus.Engine, txpool *TxPool) *StateProcessor {
	return &StateProcessor{
		config: config,
		bc:     bc,
		engine: engine,
		txpool: txpool, // FIXME cascadeth: txpool is nil for all legacy use cases !
	}
}

// Process processes the state changes according to the Ethereum rules by running
// the transaction messages using the statedb and applying any rewards to both
// the processor (coinbase) and any included uncles.
//
// Process returns the receipts and logs accumulated during the process and
// returns the amount of gas that was used in the process. If any of the
// transactions failed to execute due to insufficient gas it will return an error.
func (p *StateProcessor) Process(block *types.Block, statedb *state.StateDB, cfg vm.Config) (types.Receipts, []*types.Log, uint64, error) {
	var (
		receipts types.Receipts
		usedGas  = new(uint64)
		header   = block.Header()
		allLogs  []*types.Log
		gp       = new(GasPool).AddGas(block.GasLimit())
	)
	log.Debug("START - Processing block", "block number", block.Number(), "blockHash", block.Hash())

	// Mutate the block and state according to any hard-fork specs
	if p.config.DAOForkSupport && p.config.DAOForkBlock != nil && p.config.DAOForkBlock.Cmp(block.Number()) == 0 {
		misc.ApplyDAOHardFork(statedb)
	}
	// Cascadeth: Author is needed
	author, err := p.engine.Author(block.Header())
	if err != nil {
		log.Debug("Cascadeth: block author could not be determined.")
		return nil, nil, 0, err
	}

	blockContext := NewEVMBlockContext(header, p.bc, nil)
	vmenv := vm.NewEVM(blockContext, vm.TxContext{}, statedb, p.config, cfg)
	// Iterate over and process the individual transactions
	for i, tx := range block.Transactions() {
		msg, err := tx.AsMessage(types.MakeSigner(p.config, header.Number))
		if err != nil {
			return nil, nil, 0, err
		}

		// Cascadeth: Add ack to txPool and only apply transaction if enough acks received.
		log.Debug("Cascadeth: applyTransaction (state processing)", "tx hash", tx.Hash(), "tx nonce", tx.Nonce())
		confirmed, _ := p.txpool.addAck(tx, author, false)
		if !confirmed {
			log.Debug("Cascadeth: transaction not yet confirmed")
			continue // FIXME not enough acks found.
		} else {
			log.Debug("Cascadeth: transaction confirmed")
		}
		// TX was confirmed and can now be processed

		statedb.Prepare(tx.Hash(), block.Hash(), i)
		receipt, err := applyTransaction(msg, p.config, p.bc, nil, gp, statedb, header, tx, usedGas, vmenv)
		if err != nil {
			return nil, nil, 0, fmt.Errorf("could not apply tx %d [%v]: %w", i, tx.Hash().Hex(), err)
		}
		receipts = append(receipts, receipt)
		allLogs = append(allLogs, receipt.Logs...)
	}
	// Finalize the block, applying any consensus engine specific extras (e.g. block rewards)
	p.engine.Finalize(p.bc, header, statedb, block.Transactions(), block.Uncles())

	log.Debug("END - Processing block", "block number", block.Number(), "blockHash", block.Hash())
	return receipts, allLogs, *usedGas, nil
}

func applyTransaction(msg types.Message, config *params.ChainConfig, bc ChainContext, author *common.Address, gp *GasPool, statedb *state.StateDB, header *types.Header, tx *types.Transaction, usedGas *uint64, evm *vm.EVM) (*types.Receipt, error) {
	// Create a new context to be used in the EVM environment.
	txContext := NewEVMTxContext(msg)
	evm.Reset(txContext, statedb)

	// Apply the transaction to the current state (included in the env).
	result, err := ApplyMessage(evm, msg, gp)
	if err != nil {
		return nil, err
	}

	// Update the state with pending changes.
	var root []byte
	if config.IsByzantium(header.Number) {
		statedb.Finalise(true)
	} else {
		root = statedb.IntermediateRoot(config.IsEIP158(header.Number)).Bytes()
	}
	*usedGas += result.UsedGas

	// Create a new receipt for the transaction, storing the intermediate root and gas used
	// by the tx.
	receipt := &types.Receipt{Type: tx.Type(), PostState: root, CumulativeGasUsed: *usedGas}
	if result.Failed() {
		receipt.Status = types.ReceiptStatusFailed
	} else {
		receipt.Status = types.ReceiptStatusSuccessful
	}
	receipt.TxHash = tx.Hash()
	receipt.GasUsed = result.UsedGas

	// If the transaction created a contract, store the creation address in the receipt.
	if msg.To() == nil {
		receipt.ContractAddress = crypto.CreateAddress(evm.TxContext.Origin, tx.Nonce())
	}

	// Set the receipt logs and create the bloom filter.
	receipt.Logs = statedb.GetLogs(tx.Hash())
	receipt.Bloom = types.CreateBloom(types.Receipts{receipt})
	receipt.BlockHash = statedb.BlockHash()
	receipt.BlockNumber = header.Number
	receipt.TransactionIndex = uint(statedb.TxIndex())
	return receipt, err
}

// ApplyTransaction attempts to apply a transaction to the given state database
// and uses the input parameters for its environment. It returns the receipt
// for the transaction, gas used and an error if the transaction failed,
// indicating the block was invalid.
func ApplyTransaction(config *params.ChainConfig, bc ChainContext, author *common.Address, gp *GasPool, statedb *state.StateDB, header *types.Header, tx *types.Transaction, usedGas *uint64, cfg vm.Config, txpools ...*TxPool) (*types.Receipt, error) {
	msg, err := tx.AsMessage(types.MakeSigner(config, header.Number))
	if err != nil {
		return nil, err
	}
	// Cascadeth: Add ack to txPool and only apply transaction if enough acks received.
	if len(txpools) == 0 {
		log.Warn("Cascadeth: ApplyTransaction Legacy mode")
	} else {
		log.Debug("Cascadeth: ApplyTransaction Cascadeth mode (mining)", "tx hash", tx.Hash(), "tx nonce", tx.Nonce())

		txpool := txpools[0]
		confirmed, _ := txpool.addAck(tx, *author, true)

		// FIXME Cascadeth: Flag transaction as acked, so that it can be demoted/deleted immediately, as otherwise we would
		// Keep adding it to our blocks until it appears in state.
		/*
			if txpool.acked[tx.Hash()] {
				receipt := &types.Receipt{Type: tx.Type(), PostState: statedb.IntermediateRoot(false).Bytes(), CumulativeGasUsed: *usedGas}
				return receipt, ErrAlreadyKnown // FIXME Acked before
			}

			txpool.acked[tx.Hash()] = true
		*/

		if !confirmed {
			log.Debug("Cascadeth: transaction not yet confirmed, but applying changes to ackState /currentState of txPool.")
			// FIXME invented receipt to avoid mining multiple times ?
			//receipt := &types.Receipt{Type: tx.Type(), PostState: statedb.IntermediateRoot(false).Bytes(), CumulativeGasUsed: *usedGas}
			// return receipt, ErrInsufficientFunds // FIXME InsufficientAck
		} else {
			log.Debug("Cascadeth: transaction confirmed, but still only applied to ackState.. FIXME")
		}
	}

	// Create a new context to be used in the EVM environment
	blockContext := NewEVMBlockContext(header, bc, author)
	vmenv := vm.NewEVM(blockContext, vm.TxContext{}, statedb, config, cfg)
	return applyTransaction(msg, config, bc, author, gp, statedb, header, tx, usedGas, vmenv)
}
