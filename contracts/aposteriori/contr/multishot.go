// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package contr

import (
	"math/big"
	"strings"

	ethereum "github.com/yannvon/cascadeth"
	"github.com/yannvon/cascadeth/accounts/abi"
	"github.com/yannvon/cascadeth/accounts/abi/bind"
	"github.com/yannvon/cascadeth/common"
	"github.com/yannvon/cascadeth/core/types"
	"github.com/yannvon/cascadeth/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// MultishotABI is the input ABI used to generate the binding from.
const MultishotABI = "[{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"validators\",\"type\":\"address[]\"},{\"internalType\":\"uint256[]\",\"name\":\"stake\",\"type\":\"uint256[]\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"txOrigin\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"txNonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"decision\",\"type\":\"uint256\"}],\"name\":\"Decided\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"decisions\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"decision\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"weight_received\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"currentMax\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"majorityStake\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"txOrigin\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"txHash\",\"type\":\"uint256\"}],\"name\":\"propose\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"txOrigin\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"}],\"name\":\"read\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"txHash\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"validatorStake\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"}]"

// MultishotFuncSigs maps the 4-byte function signature to its string representation.
var MultishotFuncSigs = map[string]string{
	"d6a315a3": "decisions(address,uint256)",
	"f96e8001": "majorityStake()",
	"0d34b2ad": "propose(address,uint256,uint256)",
	"014c2add": "read(address,uint256)",
	"39b7fcc6": "validatorStake(address)",
}

// MultishotBin is the compiled bytecode used for deploying new contracts.
var MultishotBin = "0x60806040523480156200001157600080fd5b506040516200082338038062000823833981016040819052620000349162000187565b6000805b8351811015620000e45782818151811062000057576200005762000358565b602002602001015160008086848151811062000077576200007762000358565b60200260200101516001600160a01b03166001600160a01b0316815260200190815260200160002081905550828181518110620000b857620000b862000358565b602002602001015182620000cd9190620002c4565b915080620000db8162000324565b91505062000038565b506005620000f482600462000302565b620001009190620002df565b6001555062000384915050565b600082601f8301126200011f57600080fd5b815160206200013862000132836200029e565b6200026b565b80838252828201915082860187848660051b89010111156200015957600080fd5b60005b858110156200017a578151845292840192908401906001016200015c565b5090979650505050505050565b600080604083850312156200019b57600080fd5b82516001600160401b0380821115620001b357600080fd5b818501915085601f830112620001c857600080fd5b81516020620001db62000132836200029e565b8083825282820191508286018a848660051b8901011115620001fc57600080fd5b600096505b84871015620002375780516001600160a01b03811681146200022257600080fd5b83526001969096019591830191830162000201565b50918801519196509093505050808211156200025257600080fd5b5062000261858286016200010d565b9150509250929050565b604051601f8201601f191681016001600160401b03811182821017156200029657620002966200036e565b604052919050565b60006001600160401b03821115620002ba57620002ba6200036e565b5060051b60200190565b60008219821115620002da57620002da62000342565b500190565b600082620002fd57634e487b7160e01b600052601260045260246000fd5b500490565b60008160001904831182151516156200031f576200031f62000342565b500290565b60006000198214156200033b576200033b62000342565b5060010190565b634e487b7160e01b600052601160045260246000fd5b634e487b7160e01b600052603260045260246000fd5b634e487b7160e01b600052604160045260246000fd5b61048f80620003946000396000f3fe608060405234801561001057600080fd5b50600436106100575760003560e01c8063014c2add1461005c5780630d34b2ad1461008257806339b7fcc614610097578063d6a315a3146100b7578063f96e800114610108575b600080fd5b61006f61006a3660046103d6565b610111565b6040519081526020015b60405180910390f35b610095610090366004610400565b61014f565b005b61006f6100a53660046103b4565b60006020819052908152604090205481565b6100ed6100c53660046103d6565b6002602081815260009384526040808520909152918352912080546001820154919092015483565b60408051938452602084019290925290820152606001610079565b61006f60015481565b6001600160a01b0382166000908152600260209081526040808320848452909152812080541561014357549050610149565b60009150505b92915050565b6001600160a01b03831660009081526002602090815260408083208584528252808320338452600381019092529091205460ff16156101cd5760405162461bcd60e51b81526020600482015260156024820152742cb7ba9030b63932b0b23c90383937b837b9b2b21760591b60448201526064015b60405180910390fd5b80541561021c5760405162461bcd60e51b815260206004820152601c60248201527f436f6e73656e73757320616c72656164792064656c6976657265642e0000000060448201526064016101c4565b3360009081526020819052604090205461028e5760405162461bcd60e51b815260206004820152602d60248201527f596f75206e656564207374616b6520746f2062652061626c6520746f2070726f60448201526c3837b9b29030903b30b63ab29760991b60648201526084016101c4565b33600090815260208181526040808320548584526004850190925282208054919290916102bc908490610433565b909155505033600090815260208190526040812054600183018054919290916102e6908490610433565b909155505060008281526004820160205260408082205460028401548352912054101561031557600281018290555b600154816001015411156103765760028101548082556040516001600160a01b038616917f49313ea52c4c4f42773231ed26a31b3826cdaf9d6fe5c067767e151110fd50239161036d91878252602082015260400190565b60405180910390a25b336000908152600390910160205260409020805460ff19166001179055505050565b80356001600160a01b03811681146103af57600080fd5b919050565b6000602082840312156103c657600080fd5b6103cf82610398565b9392505050565b600080604083850312156103e957600080fd5b6103f283610398565b946020939093013593505050565b60008060006060848603121561041557600080fd5b61041e84610398565b95602085013595506040909401359392505050565b6000821982111561045457634e487b7160e01b600052601160045260246000fd5b50019056fea2646970667358221220c45d7cd82e33239e92d41fa8afbb5fe4ff6fd12557b91a6b917b30d64a39998464736f6c63430008060033"

// DeployMultishot deploys a new Ethereum contract, binding an instance of Multishot to it.
func DeployMultishot(auth *bind.TransactOpts, backend bind.ContractBackend, validators []common.Address, stake []*big.Int) (common.Address, *types.Transaction, *Multishot, error) {
	parsed, err := abi.JSON(strings.NewReader(MultishotABI))
	if err != nil {
		return common.Address{}, nil, nil, err
	}

	address, tx, contract, err := bind.DeployContract(auth, parsed, common.FromHex(MultishotBin), backend, validators, stake)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &Multishot{MultishotCaller: MultishotCaller{contract: contract}, MultishotTransactor: MultishotTransactor{contract: contract}, MultishotFilterer: MultishotFilterer{contract: contract}}, nil
}

// Multishot is an auto generated Go binding around an Ethereum contract.
type Multishot struct {
	MultishotCaller     // Read-only binding to the contract
	MultishotTransactor // Write-only binding to the contract
	MultishotFilterer   // Log filterer for contract events
}

// MultishotCaller is an auto generated read-only Go binding around an Ethereum contract.
type MultishotCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MultishotTransactor is an auto generated write-only Go binding around an Ethereum contract.
type MultishotTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MultishotFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type MultishotFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MultishotSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type MultishotSession struct {
	Contract     *Multishot        // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// MultishotCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type MultishotCallerSession struct {
	Contract *MultishotCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts    // Call options to use throughout this session
}

// MultishotTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type MultishotTransactorSession struct {
	Contract     *MultishotTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts    // Transaction auth options to use throughout this session
}

// MultishotRaw is an auto generated low-level Go binding around an Ethereum contract.
type MultishotRaw struct {
	Contract *Multishot // Generic contract binding to access the raw methods on
}

// MultishotCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type MultishotCallerRaw struct {
	Contract *MultishotCaller // Generic read-only contract binding to access the raw methods on
}

// MultishotTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type MultishotTransactorRaw struct {
	Contract *MultishotTransactor // Generic write-only contract binding to access the raw methods on
}

// NewMultishot creates a new instance of Multishot, bound to a specific deployed contract.
func NewMultishot(address common.Address, backend bind.ContractBackend) (*Multishot, error) {
	contract, err := bindMultishot(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Multishot{MultishotCaller: MultishotCaller{contract: contract}, MultishotTransactor: MultishotTransactor{contract: contract}, MultishotFilterer: MultishotFilterer{contract: contract}}, nil
}

// NewMultishotCaller creates a new read-only instance of Multishot, bound to a specific deployed contract.
func NewMultishotCaller(address common.Address, caller bind.ContractCaller) (*MultishotCaller, error) {
	contract, err := bindMultishot(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &MultishotCaller{contract: contract}, nil
}

// NewMultishotTransactor creates a new write-only instance of Multishot, bound to a specific deployed contract.
func NewMultishotTransactor(address common.Address, transactor bind.ContractTransactor) (*MultishotTransactor, error) {
	contract, err := bindMultishot(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &MultishotTransactor{contract: contract}, nil
}

// NewMultishotFilterer creates a new log filterer instance of Multishot, bound to a specific deployed contract.
func NewMultishotFilterer(address common.Address, filterer bind.ContractFilterer) (*MultishotFilterer, error) {
	contract, err := bindMultishot(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &MultishotFilterer{contract: contract}, nil
}

// bindMultishot binds a generic wrapper to an already deployed contract.
func bindMultishot(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(MultishotABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Multishot *MultishotRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Multishot.Contract.MultishotCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Multishot *MultishotRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Multishot.Contract.MultishotTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Multishot *MultishotRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Multishot.Contract.MultishotTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Multishot *MultishotCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Multishot.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Multishot *MultishotTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Multishot.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Multishot *MultishotTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Multishot.Contract.contract.Transact(opts, method, params...)
}

// Decisions is a free data retrieval call binding the contract method 0xd6a315a3.
//
// Solidity: function decisions(address , uint256 ) view returns(uint256 decision, uint256 weight_received, uint256 currentMax)
func (_Multishot *MultishotCaller) Decisions(opts *bind.CallOpts, arg0 common.Address, arg1 *big.Int) (struct {
	Decision       *big.Int
	WeightReceived *big.Int
	CurrentMax     *big.Int
}, error) {
	var out []interface{}
	err := _Multishot.contract.Call(opts, &out, "decisions", arg0, arg1)

	outstruct := new(struct {
		Decision       *big.Int
		WeightReceived *big.Int
		CurrentMax     *big.Int
	})
	if err != nil {
		return *outstruct, err
	}

	outstruct.Decision = *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)
	outstruct.WeightReceived = *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)
	outstruct.CurrentMax = *abi.ConvertType(out[2], new(*big.Int)).(**big.Int)

	return *outstruct, err

}

// Decisions is a free data retrieval call binding the contract method 0xd6a315a3.
//
// Solidity: function decisions(address , uint256 ) view returns(uint256 decision, uint256 weight_received, uint256 currentMax)
func (_Multishot *MultishotSession) Decisions(arg0 common.Address, arg1 *big.Int) (struct {
	Decision       *big.Int
	WeightReceived *big.Int
	CurrentMax     *big.Int
}, error) {
	return _Multishot.Contract.Decisions(&_Multishot.CallOpts, arg0, arg1)
}

// Decisions is a free data retrieval call binding the contract method 0xd6a315a3.
//
// Solidity: function decisions(address , uint256 ) view returns(uint256 decision, uint256 weight_received, uint256 currentMax)
func (_Multishot *MultishotCallerSession) Decisions(arg0 common.Address, arg1 *big.Int) (struct {
	Decision       *big.Int
	WeightReceived *big.Int
	CurrentMax     *big.Int
}, error) {
	return _Multishot.Contract.Decisions(&_Multishot.CallOpts, arg0, arg1)
}

// MajorityStake is a free data retrieval call binding the contract method 0xf96e8001.
//
// Solidity: function majorityStake() view returns(uint256)
func (_Multishot *MultishotCaller) MajorityStake(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Multishot.contract.Call(opts, &out, "majorityStake")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MajorityStake is a free data retrieval call binding the contract method 0xf96e8001.
//
// Solidity: function majorityStake() view returns(uint256)
func (_Multishot *MultishotSession) MajorityStake() (*big.Int, error) {
	return _Multishot.Contract.MajorityStake(&_Multishot.CallOpts)
}

// MajorityStake is a free data retrieval call binding the contract method 0xf96e8001.
//
// Solidity: function majorityStake() view returns(uint256)
func (_Multishot *MultishotCallerSession) MajorityStake() (*big.Int, error) {
	return _Multishot.Contract.MajorityStake(&_Multishot.CallOpts)
}

// Read is a free data retrieval call binding the contract method 0x014c2add.
//
// Solidity: function read(address txOrigin, uint256 nonce) view returns(uint256 txHash)
func (_Multishot *MultishotCaller) Read(opts *bind.CallOpts, txOrigin common.Address, nonce *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Multishot.contract.Call(opts, &out, "read", txOrigin, nonce)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Read is a free data retrieval call binding the contract method 0x014c2add.
//
// Solidity: function read(address txOrigin, uint256 nonce) view returns(uint256 txHash)
func (_Multishot *MultishotSession) Read(txOrigin common.Address, nonce *big.Int) (*big.Int, error) {
	return _Multishot.Contract.Read(&_Multishot.CallOpts, txOrigin, nonce)
}

// Read is a free data retrieval call binding the contract method 0x014c2add.
//
// Solidity: function read(address txOrigin, uint256 nonce) view returns(uint256 txHash)
func (_Multishot *MultishotCallerSession) Read(txOrigin common.Address, nonce *big.Int) (*big.Int, error) {
	return _Multishot.Contract.Read(&_Multishot.CallOpts, txOrigin, nonce)
}

// ValidatorStake is a free data retrieval call binding the contract method 0x39b7fcc6.
//
// Solidity: function validatorStake(address ) view returns(uint256)
func (_Multishot *MultishotCaller) ValidatorStake(opts *bind.CallOpts, arg0 common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Multishot.contract.Call(opts, &out, "validatorStake", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ValidatorStake is a free data retrieval call binding the contract method 0x39b7fcc6.
//
// Solidity: function validatorStake(address ) view returns(uint256)
func (_Multishot *MultishotSession) ValidatorStake(arg0 common.Address) (*big.Int, error) {
	return _Multishot.Contract.ValidatorStake(&_Multishot.CallOpts, arg0)
}

// ValidatorStake is a free data retrieval call binding the contract method 0x39b7fcc6.
//
// Solidity: function validatorStake(address ) view returns(uint256)
func (_Multishot *MultishotCallerSession) ValidatorStake(arg0 common.Address) (*big.Int, error) {
	return _Multishot.Contract.ValidatorStake(&_Multishot.CallOpts, arg0)
}

// Propose is a paid mutator transaction binding the contract method 0x0d34b2ad.
//
// Solidity: function propose(address txOrigin, uint256 nonce, uint256 txHash) returns()
func (_Multishot *MultishotTransactor) Propose(opts *bind.TransactOpts, txOrigin common.Address, nonce *big.Int, txHash *big.Int) (*types.Transaction, error) {
	return _Multishot.contract.Transact(opts, "propose", txOrigin, nonce, txHash)
}

// Propose is a paid mutator transaction binding the contract method 0x0d34b2ad.
//
// Solidity: function propose(address txOrigin, uint256 nonce, uint256 txHash) returns()
func (_Multishot *MultishotSession) Propose(txOrigin common.Address, nonce *big.Int, txHash *big.Int) (*types.Transaction, error) {
	return _Multishot.Contract.Propose(&_Multishot.TransactOpts, txOrigin, nonce, txHash)
}

// Propose is a paid mutator transaction binding the contract method 0x0d34b2ad.
//
// Solidity: function propose(address txOrigin, uint256 nonce, uint256 txHash) returns()
func (_Multishot *MultishotTransactorSession) Propose(txOrigin common.Address, nonce *big.Int, txHash *big.Int) (*types.Transaction, error) {
	return _Multishot.Contract.Propose(&_Multishot.TransactOpts, txOrigin, nonce, txHash)
}

// MultishotDecidedIterator is returned from FilterDecided and is used to iterate over the raw logs and unpacked data for Decided events raised by the Multishot contract.
type MultishotDecidedIterator struct {
	Event *MultishotDecided // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *MultishotDecidedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MultishotDecided)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(MultishotDecided)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *MultishotDecidedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MultishotDecidedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MultishotDecided represents a Decided event raised by the Multishot contract.
type MultishotDecided struct {
	TxOrigin common.Address
	TxNonce  *big.Int
	Decision *big.Int
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterDecided is a free log retrieval operation binding the contract event 0x49313ea52c4c4f42773231ed26a31b3826cdaf9d6fe5c067767e151110fd5023.
//
// Solidity: event Decided(address indexed txOrigin, uint256 txNonce, uint256 decision)
func (_Multishot *MultishotFilterer) FilterDecided(opts *bind.FilterOpts, txOrigin []common.Address) (*MultishotDecidedIterator, error) {

	var txOriginRule []interface{}
	for _, txOriginItem := range txOrigin {
		txOriginRule = append(txOriginRule, txOriginItem)
	}

	logs, sub, err := _Multishot.contract.FilterLogs(opts, "Decided", txOriginRule)
	if err != nil {
		return nil, err
	}
	return &MultishotDecidedIterator{contract: _Multishot.contract, event: "Decided", logs: logs, sub: sub}, nil
}

// WatchDecided is a free log subscription operation binding the contract event 0x49313ea52c4c4f42773231ed26a31b3826cdaf9d6fe5c067767e151110fd5023.
//
// Solidity: event Decided(address indexed txOrigin, uint256 txNonce, uint256 decision)
func (_Multishot *MultishotFilterer) WatchDecided(opts *bind.WatchOpts, sink chan<- *MultishotDecided, txOrigin []common.Address) (event.Subscription, error) {

	var txOriginRule []interface{}
	for _, txOriginItem := range txOrigin {
		txOriginRule = append(txOriginRule, txOriginItem)
	}

	logs, sub, err := _Multishot.contract.WatchLogs(opts, "Decided", txOriginRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MultishotDecided)
				if err := _Multishot.contract.UnpackLog(event, "Decided", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseDecided is a log parse operation binding the contract event 0x49313ea52c4c4f42773231ed26a31b3826cdaf9d6fe5c067767e151110fd5023.
//
// Solidity: event Decided(address indexed txOrigin, uint256 txNonce, uint256 decision)
func (_Multishot *MultishotFilterer) ParseDecided(log types.Log) (*MultishotDecided, error) {
	event := new(MultishotDecided)
	if err := _Multishot.contract.UnpackLog(event, "Decided", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
