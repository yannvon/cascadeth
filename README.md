# Cascadeth
Fork of the Official Golang implementation of the Ethereum protocol.
This protocol implements a simple broadcast-based digital currency (Inspired by Cascade and Astro protocols), while offering the same interface as geth.

The functionality of the currency is improved by performing consensus on demand.

## Quick start

The simplest way to test Cascadeth is to run one of the test scripts provided in the `scripts/` directory. 
The most important commands are explained using an example bash script that can be found in `scripts/thesis-example/launch.sh`.

In this example, we will boot a local network containing four nodes, three of them being validators. The first step consists in cloning the repository, and installing Cascadeth and its tools by running:

`go install --ldflags '-extldflags "-Wl,--allow-multiple-definition"' -v ./cmd/geth` 

### Genesis & Multishot contract

Next, the genesis file shall be adapted. We will use the genesis that can be found in `scripts/thesis-example/genesis.json`. There are 5 accounts, as in this example one node has two (in general, nodes are free to access as many wallets as they like). Three of the nodes are servers/validators, and are thus listed in extraData. Their cumulative stake is stored in totalStake. The following command creates the required data directory, and needs to be performed for each node.

`geth init --datadir node0 genesis.json`

Then, the Multishot contract needs to be deployed, with the same three validator addresses and stake amount as parameter. Each validator must be sent a sufficient amount of ether on the Rinkeby network.

### Starting nodes

Nodes are equipped to perform automated network discovery, essentially probing the network until they find nodes that support the same protocol, use the same chainID and have the same genesis file. Although accurate, scan times are variable. The discovery process can be sped up by limiting the network to a sub-mask, or by manually adding each peer via the RPC interface.

Here we will use a different method, by starting a separate _bootnode_. This process has the sole purpose of allowing quick network discovery, by informing each node of the other nodes present. 

`bootnode --nodekey bootnode.key \&`

Finally, a cascadeth node is run as follows:

`geth --datadir node0 --gcmode archive --bootnodes BOOTNODE --metrics --metrics.addr 127.0.0.1 --metrics.port 6061 --networkid 15 --port 30303 --http.port 8101 --syncmode full --verbosity 5 --cache.snapshot 0 --ipcpath geth0.ipc --netrestrict 127.0.0.0/24 --unlock 0x8d0448e9109d5d93a77061918ded588ddb8ebe97 --password password.txt \&> logs/geth0.log \&`

### Performing transactions

The three validator nodes need to be individually instructed to start mining, i.e. creating blocks containing acknowledgements:

`geth attach node0/geth0.ipc --exec "miner.start(0)"`

Assuming the account is already unlocked (as was done above when launching the node), we can now perform a transaction as follows: 

`geth attach node0/geth0.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: eth.accounts[1], value: 1000000000000000000, gas: 21000, gasPrice: 100000000000})"`

After a short amount of time, the new account balance in Ether can be read as follows:

`geth attach node0/geth0.ipc --exec "web3.fromWei (eth.getBalance(eth.accounts[0]), 'ether')"`



## Building the source

For prerequisites and detailed build instructions please read the [Installation Instructions](https://geth.ethereum.org/docs/install-and-build/installing-geth).

Building `geth` requires both a Go (version 1.13 or later) and a C compiler. You can install
them using your favourite package manager. Once the dependencies are installed, run

```shell
make geth
```

or, to build the full suite of utilities:

```shell
make all
```

## Executables

The go-ethereum project comes with several wrappers/executables found in the `cmd`
directory.

|    Command    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| :-----------: | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|  **`geth`**   | Our main Ethereum CLI client. It is the entry point into the Ethereum network (main-, test- or private net), capable of running as a full node (default), archive node (retaining all historical state) or a light node (retrieving data live). It can be used by other processes as a gateway into the Ethereum network via JSON RPC endpoints exposed on top of HTTP, WebSocket and/or IPC transports. `geth --help` and the [CLI page](https://geth.ethereum.org/docs/interface/command-line-options) for command line options.          |
|   `abigen`    | Source code generator to convert Ethereum contract definitions into easy to use, compile-time type-safe Go packages. It operates on plain [Ethereum contract ABIs](https://docs.soliditylang.org/en/develop/abi-spec.html) with expanded functionality if the contract bytecode is also available. However, it also accepts Solidity source files, making development much more streamlined. Please see our [Native DApps](https://geth.ethereum.org/docs/dapp/native-bindings) page for details. |
|  `bootnode`   | Stripped down version of our Ethereum client implementation that only takes part in the network node discovery protocol, but does not run any of the higher level application protocols. It can be used as a lightweight bootstrap node to aid in finding peers in private networks.                                                                                                                                                                                                                                                                 |
|     `evm`     | Developer utility version of the EVM (Ethereum Virtual Machine) that is capable of running bytecode snippets within a configurable environment and execution mode. Its purpose is to allow isolated, fine-grained debugging of EVM opcodes (e.g. `evm --code 60ff60ff --debug run`).                                                                                                                                                                                                                                                                     |
| `gethrpctest` | Developer utility tool to support our [ethereum/rpc-test](https://github.com/ethereum/rpc-tests) test suite which validates baseline conformity to the [Ethereum JSON RPC](https://eth.wiki/json-rpc/API) specs. Please see the [test suite's readme](https://github.com/ethereum/rpc-tests/blob/master/README.md) for details.                                                                                                                                                                                                     |
|   `rlpdump`   | Developer utility tool to convert binary RLP ([Recursive Length Prefix](https://eth.wiki/en/fundamentals/rlp)) dumps (data encoding used by the Ethereum protocol both network as well as consensus wise) to user-friendlier hierarchical representation (e.g. `rlpdump --hex CE0183FFFFFFC4C304050583616263`).                                                                                                                                                                                                                                 |
|   `puppeth`   | a CLI wizard that aids in creating a new Ethereum network.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |

## Running `geth`

Going through all the possible command line flags is out of scope here (please consult our
[CLI Wiki page](https://geth.ethereum.org/docs/interface/command-line-options)),
but we've enumerated a few common parameter combos to get you up to speed quickly
on how you can run your own `geth` instance.


### Configuration

As an alternative to passing the numerous flags to the `geth` binary, you can also pass a
configuration file via:

```shell
$ geth --config /path/to/your_config.toml
```

To get an idea how the file should look like you can use the `dumpconfig` subcommand to
export your existing configuration:

```shell
$ geth --your-favourite-flags dumpconfig
```


### Programmatically interfacing `geth` nodes

As a developer, sooner rather than later you'll want to start interacting with `geth` and the
Ethereum network via your own programs and not manually through the console. To aid
this, `geth` has built-in support for a JSON-RPC based APIs ([standard APIs](https://eth.wiki/json-rpc/API)
and [`geth` specific APIs](https://geth.ethereum.org/docs/rpc/server)).
These can be exposed via HTTP, WebSockets and IPC (UNIX sockets on UNIX based
platforms, and named pipes on Windows).

The IPC interface is enabled by default and exposes all the APIs supported by `geth`,
whereas the HTTP and WS interfaces need to manually be enabled and only expose a
subset of APIs due to security reasons. These can be turned on/off and configured as
you'd expect.

HTTP based JSON-RPC API options:

  * `--http` Enable the HTTP-RPC server
  * `--http.addr` HTTP-RPC server listening interface (default: `localhost`)
  * `--http.port` HTTP-RPC server listening port (default: `8545`)
  * `--http.api` API's offered over the HTTP-RPC interface (default: `eth,net,web3`)
  * `--http.corsdomain` Comma separated list of domains from which to accept cross origin requests (browser enforced)
  * `--ws` Enable the WS-RPC server
  * `--ws.addr` WS-RPC server listening interface (default: `localhost`)
  * `--ws.port` WS-RPC server listening port (default: `8546`)
  * `--ws.api` API's offered over the WS-RPC interface (default: `eth,net,web3`)
  * `--ws.origins` Origins from which to accept websockets requests
  * `--ipcdisable` Disable the IPC-RPC server
  * `--ipcapi` API's offered over the IPC-RPC interface (default: `admin,debug,eth,miner,net,personal,shh,txpool,web3`)
  * `--ipcpath` Filename for IPC socket/pipe within the datadir (explicit paths escape it)

You'll need to use your own programming environments' capabilities (libraries, tools, etc) to
connect via HTTP, WS or IPC to a `geth` node configured with the above flags and you'll
need to speak [JSON-RPC](https://www.jsonrpc.org/specification) on all transports. You
can reuse the same connection for multiple requests!

**Note: Please understand the security implications of opening up an HTTP/WS based
transport before doing so! Hackers on the internet are actively trying to subvert
Ethereum nodes with exposed APIs! Further, all browser tabs can access locally
running web servers, so malicious web pages could try to subvert locally available
APIs!**

## Contribution

Thank you for considering to help out with the source code! We welcome contributions
from anyone on the internet, and are grateful for even the smallest of fixes!

If you'd like to contribute to go-ethereum, please fork, fix, commit and send a pull request
for the maintainers to review and merge into the main code base. If you wish to submit
more complex changes though, please check up with the core devs first on [our gitter channel](https://gitter.im/ethereum/go-ethereum)
to ensure those changes are in line with the general philosophy of the project and/or get
some early feedback which can make both your efforts much lighter as well as our review
and merge procedures quick and simple.

Please make sure your contributions adhere to our coding guidelines:

 * Code must adhere to the official Go [formatting](https://golang.org/doc/effective_go.html#formatting)
   guidelines (i.e. uses [gofmt](https://golang.org/cmd/gofmt/)).
 * Code must be documented adhering to the official Go [commentary](https://golang.org/doc/effective_go.html#commentary)
   guidelines.
 * Pull requests need to be based on and opened against the `master` branch.
 * Commit messages should be prefixed with the package(s) they modify.
   * E.g. "eth, rpc: make trace configs optional"

Please see the [Developers' Guide](https://geth.ethereum.org/docs/developers/devguide)
for more details on configuring your environment, managing project dependencies, and
testing procedures.

## License

The go-ethereum library (i.e. all code outside of the `cmd` directory) is licensed under the
[GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0.en.html),
also included in our repository in the `COPYING.LESSER` file.

The go-ethereum binaries (i.e. all code inside of the `cmd` directory) is licensed under the
[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html), also
included in our repository in the `COPYING` file.
