#!/bin/bash

# variables
verbosity=4
debug=0

# Note: Accounts must already be present
init_time=2

node1_acc1="a6e1809e41b94caceeb44f475e892e394a943691"

bootnodes="enode://eabfe0c1deadd40b63b4405789ef44c4a5109d7de93bcec80c4d7332d50940ef8bb732db2b37944ef239436113652db94b8f04a54857e145d6257a97ac002647@127.0.0.1:0?discport=30301"

tx_str_1="web3.fromWei(eth.getBalance('"
tx_str_2="'),'ether')"



# Helper functions


check_balances_peerview () {
  echo $2
  /home/yann/go/bin/geth attach $1 --exec $tx_str_1$node1_acc1$tx_str_2
}

# gnome-terminal to open new window ! https://askubuntu.com/questions/1228251/how-do-i-create-a-script-to-open-a-new-terminal-and-execute-a-command

# Execute from cascadeth directory
cd ~/Documents/cascadeth

# Compile and install geth
# allow multiple definitions, since both cascadeth and geth access same C source files
# https://stackoverflow.com/questions/56318343/golang-multiple-definition-of-cgo-ported-package
go install --ldflags '-extldflags "-Wl,--allow-multiple-definition"' -v ./cmd/geth



# Note: bootnodes are not what I believed them to be, see https://geth.ethereum.org/docs/getting-started/private-net
echo "Start bootnode"
/home/yann/go/bin/bootnode --nodekey data/benchmark/bootnode.key &
bootnode=$!

# Also consider doing: https://github.com/ethersphere/eth-utils
# And: https://eth.wiki/en/concepts/network-status

# Metric can be used by opening http://127.0.0.1:6062/debug/metrics in a browser window

# Start all ten nodes
# trap "kill 0" EXIT # Sometimes kill -9 is needed, why ?

echo "Starting geth nodes."
# nodiscover breaks a lot of stuff, but with manual adding it should work
/home/yann/go/bin/geth --datadir data/benchmark/datadir/node0 --bootnodes $bootnodes --metrics --metrics.addr 127.0.0.1 --metrics.port 6061 --networkid 15 --port 30303 --http.port 8101 --syncmode full --verbosity $verbosity --cache.snapshot 0 --ipcpath geth0.ipc --netrestrict 127.0.0.0/24 --unlock 0xa6e1809e41b94caceeb44f475e892e394a943691 --password data/benchmark/password.txt &> data/benchmark/datadir/geth0.log &
node1=$!
/home/yann/go/bin/geth --datadir data/benchmark/datadir/node1 --bootnodes $bootnodes --metrics --metrics.addr 127.0.0.1 --metrics.port 6062 --networkid 15 --port 30304 --http.port 8102 --syncmode full --verbosity $verbosity --cache.snapshot 0 --ipcpath geth1.ipc --netrestrict 127.0.0.0/24 --unlock 0x0880213c848114c92bbb36e14916cedb43e70669 --password data/benchmark/password.txt &> data/benchmark/datadir/geth1.log &
node2=$!
/home/yann/go/bin/geth --datadir data/benchmark/datadir/node2 --bootnodes $bootnodes --metrics --metrics.addr 127.0.0.1 --metrics.port 6063 --networkid 15 --port 30305 --http.port 8103 --syncmode full --verbosity $verbosity --cache.snapshot 0 --ipcpath geth2.ipc --netrestrict 127.0.0.0/24 --unlock 0x40dd7959718df0ff47c1ba478a3de90c2637a605 --password data/benchmark/password.txt &> data/benchmark/datadir/geth2.log &
node3=$!

# sleep $init_time
sleep 100

# Note: nodiscover adds stuff to enode, important for it to work

# Attach IPC pipes and send commands
#gnome-terminal -- sh -c "/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc"

# Finding node enode INFO
#enode0=$(/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/benchmark/node0/geth0.ipc --exec "admin.nodeInfo.enode")
#enode1=$(/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/benchmark/node1/geth1.ipc --exec "admin.nodeInfo.enode")
#enode2=$(/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/benchmark/node2/geth2.ipc --exec "admin.nodeInfo.enode")

/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/benchmark/datadir/node0/geth0.ipc --exec "admin.peers"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/benchmark/datadir/node1/geth1.ipc --exec "admin.peers"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/benchmark/datadir/node2/geth2.ipc --exec "admin.peers"









echo "Shutdown."

kill -9 $node1
kill -9 $node2
kill -9 $node3

kill -9 $bootnode
