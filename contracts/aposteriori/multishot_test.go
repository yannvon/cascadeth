package aposteriori

import (
	"log"
	"math/big"
	"testing"

	"github.com/yannvon/cascadeth/accounts/abi/bind"
	"github.com/yannvon/cascadeth/accounts/abi/bind/backends"
	"github.com/yannvon/cascadeth/common"
	"github.com/yannvon/cascadeth/core"
	"github.com/yannvon/cascadeth/crypto"

	contract "github.com/yannvon/cascadeth/contracts/aposteriori/contr"
)

// Test inbox contract gets deployed correctly
func TestMultishot(t *testing.T) {

	chainID := big.NewInt(1337)

	privateKey, err := crypto.GenerateKey()
	if err != nil {
		log.Fatal(err)
	}
	auth, _ := bind.NewKeyedTransactorWithChainID(privateKey, chainID)

	privateKey2, err := crypto.GenerateKey()
	if err != nil {
		log.Fatal(err)
	}
	auth2, _ := bind.NewKeyedTransactorWithChainID(privateKey2, chainID)

	privateKey3, err := crypto.GenerateKey()
	if err != nil {
		log.Fatal(err)
	}
	auth3, _ := bind.NewKeyedTransactorWithChainID(privateKey3, chainID)

	balance := new(big.Int)
	balance.SetString("10000000000000000000", 10) // 10 eth in wei

	address := auth.From
	genesisAlloc := map[common.Address]core.GenesisAccount{
		address: {
			Balance: balance,
		},
		auth2.From: {
			Balance: balance,
		},
		auth3.From: {
			Balance: balance,
		},
	}
	blockGasLimit := uint64(4712388)
	client := backends.NewSimulatedBackend(genesisAlloc, blockGasLimit)

	//Deploy contract
	validators := []common.Address{auth.From, auth2.From, auth3.From}
	stake := []*big.Int{balance, balance, balance}

	_, _, contract, _ := contract.DeployMultishot(auth, client, validators, stake)

	// commit all pending transactions
	client.Commit()

	// Prepare test
	txSender := auth.From
	txNonce := big.NewInt(1)
	txHash := big.NewInt(123415)

	// Read if decision take already
	if got, _ := contract.Read(nil, txSender, txNonce); got.Cmp(big.NewInt(0)) != 0 {
		t.Errorf("Expected no decision. Got: %d", got)
	}

	// Propose for a specific instance
	var e error

	_, e = contract.Propose(auth2, txSender, txNonce, txHash)
	if e != nil {
		panic(e)
	}
	_, e = contract.Propose(auth2, txSender, txNonce, txHash)
	if e == nil {
		panic("Expected error to be thrown for duplicate propose.")
	}
	_, e = contract.Propose(auth3, txSender, txNonce, txHash)
	if e != nil {
		panic(e)
	}
	client.Commit()

	if got, _ := contract.Read(nil, txSender, txNonce); got.Cmp(big.NewInt(0)) != 0 {
		t.Errorf("Expected no decision yet. Got: %d", got)
	}

	// Last propose should make 4/5 of stake
	contract.Propose(auth, txSender, txNonce, txHash)

	client.Commit()

	if got, _ := contract.Read(nil, txSender, txNonce); got.Cmp(txHash) != 0 {
		t.Errorf("Expected decision to be sole proposed txHash. Got: %d", got)
	}

}
