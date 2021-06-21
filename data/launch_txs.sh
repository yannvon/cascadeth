#!/bin/bash

# variables
verbosity=5
debug=0

# Note: Accounts must already be present
init_time=2

nodekey1="enode://734978d67c9662f4bf63ca680de429025dae500577e24812da6f1bb0ae7234b40a3424b27988089e30d006f7d8609bacd3e1e000fe1938e0832a1e4719c70aeb@127.0.0.1:30303?discport=0"
nodekey2="enode://c7fadd8d96d775125e133cf834f06000b62abb70f0b9f4776f8c697ded5a71497148669c96166aa031789ed7e34789ae1ce472c63d192611724fab804cf3388f@127.0.0.1:30304?discport=0"
nodekey3="enode://9986c9600bb25957012ee7904d1a3f79aaa4168ab6b52e775d151a79fed6ce9f06a6da4b0e5e54a3d8610d59f029750761370ae09fd28d7465314c3be5c4dc6b@127.0.0.1:30305?discport=0"

node1_acc1="78161ecf55dc59bd9e9c5c6620c0eb2ad3b4d555"
node1_acc2="5da65eeb457543804c48b94aa17a7432cd3285d3"
node2_acc1="bbd5695c790f13b470c44b5950311c8dd24f78e6"
node3_acc1="d33ec91007a63c216b0aa87a6451c72dfe8d3cb2"

node1_ipc="/home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc"
node2_ipc="/home/yann/Documents/cascadeth/data/data-cascade-2/geth2.ipc"
node3_ipc="/home/yann/Documents/cascadeth/data/data-cascade-3/geth3.ipc"

tx_str_1="web3.fromWei(eth.getBalance('"
tx_str_2="'),'ether')"



# Helper functions
check_balances () {
  echo "peer1, account 1"
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc --exec "web3.fromWei(eth.getBalance(eth.accounts[0]),'ether')"

  echo "peer1, account 2"
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc --exec "web3.fromWei(eth.getBalance(eth.accounts[1]),'ether')"

  echo "peer2, account 1"
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-2/geth2.ipc --exec "web3.fromWei(eth.getBalance(eth.accounts[0]),'ether')"

  echo "peer3, account 1"
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-3/geth3.ipc --exec "web3.fromWei(eth.getBalance(eth.accounts[0]),'ether')"

}

check_balances_peerview () {
  echo $2
  /home/yann/go/bin/geth attach $1 --exec $tx_str_1$node1_acc1$tx_str_2
  /home/yann/go/bin/geth attach $1 --exec $tx_str_1$node1_acc2$tx_str_2
  /home/yann/go/bin/geth attach $1 --exec $tx_str_1$node2_acc1$tx_str_2
  /home/yann/go/bin/geth attach $1 --exec $tx_str_1$node3_acc1$tx_str_2
}

# gnome-terminal to open new window ! https://askubuntu.com/questions/1228251/how-do-i-create-a-script-to-open-a-new-terminal-and-execute-a-command

# Execute from cascadeth directory
cd ~/Documents/cascadeth

# Compile and install geth
go install -v ./cmd/geth

# Delete database before init
rm -r "data/data-cascade-1/geth"
rm -r "data/data-cascade-2/geth"
rm -r "data/data-cascade-3/geth"
rm -r "data/data-cascade-4/geth"

# Init blockchain from genesis
/home/yann/go/bin/geth init --datadir data/data-cascade-1 data/genesis-cascade.json
/home/yann/go/bin/geth init --datadir data/data-cascade-2 data/genesis-cascade.json
/home/yann/go/bin/geth init --datadir data/data-cascade-3 data/genesis-cascade.json
/home/yann/go/bin/geth init --datadir data/data-cascade-4 data/genesis-cascade.json


# Note: bootnodes are not what I believed them to be, see https://geth.ethereum.org/docs/getting-started/private-net
# Also consider doing: https://github.com/ethersphere/eth-utils
# And: https://eth.wiki/en/concepts/network-status

# Metric can be used by opening http://127.0.0.1:6062/debug/metrics in a browser window

# Start all three nodes
# trap "kill 0" EXIT # Sometimes kill -9 is needed, why ?

echo "Starting geth nodes."
# nodiscover breaks a lot of stuff, but with manual adding it should work
/home/yann/go/bin/geth --datadir data/data-cascade-1 --metrics --metrics.addr 127.0.0.1 --metrics.port 6061 --nodiscover --networkid 15 --port 30303 --http.port 8101 --syncmode full --verbosity $verbosity --cache.snapshot 0 --ipcpath geth1.ipc --netrestrict 127.0.0.0/24 --unlock 0x78161ecF55Dc59Bd9E9c5C6620c0eb2Ad3b4d555 --password data/pwd1.txt &> data/geth1.log &
node1=$!
/home/yann/go/bin/geth --datadir data/data-cascade-2 --metrics --metrics.addr 127.0.0.1 --metrics.port 6062 --nodiscover --networkid 15 --port 30304 --http.port 8102 --syncmode full --verbosity $verbosity --cache.snapshot 0 --ipcpath geth2.ipc --netrestrict 127.0.0.0/24 --unlock 0xBbd5695c790F13b470c44b5950311C8dd24f78E6 --password data/pwd2.txt &> data/geth2.log &
node2=$!
/home/yann/go/bin/geth --datadir data/data-cascade-3 --metrics --metrics.addr 127.0.0.1 --metrics.port 6063 --nodiscover --networkid 15 --port 30305 --http.port 8103 --syncmode full --verbosity $verbosity --cache.snapshot 0 --ipcpath geth3.ipc --netrestrict 127.0.0.0/24 --unlock 0xd33ec91007a63c216b0aa87a6451c72dfe8d3cb2 --password data/pwd3.txt &> data/geth3.log  &
node3=$!

# sleep $init_time
sleep 1

# Note: nodiscover adds stuff to enode, important for it to work

# Attach IPC pipes and send commands
#gnome-terminal -- sh -c "/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc"

# Finding node enode INFO
enode1=$(/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc --exec "admin.nodeInfo.enode")
enode2=$(/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-2/geth2.ipc --exec "admin.nodeInfo.enode")
enode3=$(/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-3/geth3.ipc --exec "admin.nodeInfo.enode")
if [ $debug -eq 1 ]
then
  enode4=$(/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-4/geth4.ipc --exec "admin.nodeInfo.enode")
fi

#echo $enode1,$enode2,$enode3

# add peers
echo "Adding peers manually."
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-2/geth2.ipc --exec "admin.addPeer($enode1)"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-3/geth3.ipc --exec "admin.addPeer($enode1)"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-3/geth3.ipc --exec "admin.addPeer($enode2)"

# Special node4
if [ $debug -eq 1 ]
then
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-4/geth4.ipc --exec "admin.addPeer($enode1)"
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-4/geth4.ipc --exec "admin.addPeer($enode2)"
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-4/geth4.ipc --exec "admin.addPeer($enode3)"
fi

sleep 2

# Check balances
check_balances_peerview $node1_ipc "peer1 view"
check_balances_peerview $node2_ipc "peer2 view"
check_balances_peerview $node3_ipc "peer3 view"

# Start mining
echo "Start mining."
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc --exec "miner.start(0)"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-2/geth2.ipc --exec "miner.start(0)"

if [ $debug -eq 1 ]
then
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-4/geth4.ipc --exec "miner.start(0)"
fi


sleep 45

# Send transactions
echo "Initiate transactions."
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: eth.accounts[1], value: 2000000000000000000, gas: 21000, gasPrice: 100000000000})"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-2/geth2.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '5da65eeb457543804c48b94aa17a7432cd3285d3', value: 1000000000000000000, gas: 21000, gasPrice: 100000000000})"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-3/geth3.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '5da65eeb457543804c48b94aa17a7432cd3285d3', value: 3000000000000000000, gas: 21000, gasPrice: 100000000000})"

sleep 45

check_balances_peerview $node1_ipc "peer1 view"
check_balances_peerview $node2_ipc "peer2 view"
check_balances_peerview $node3_ipc "peer3 view"

/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: eth.accounts[1], value: 500000000000000000, gas: 21000, gasPrice: 100000000000})"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-2/geth2.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '5da65eeb457543804c48b94aa17a7432cd3285d3', value: 1000000000000000000, gas: 21000, gasPrice: 100000000000})"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-3/geth3.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '5da65eeb457543804c48b94aa17a7432cd3285d3', value: 2000000000000000000, gas: 21000, gasPrice: 100000000000})"


# Cleanup
#wait
sleep 10

# Check balances
check_balances_peerview $node1_ipc "peer1 view"
check_balances_peerview $node2_ipc "peer2 view"
check_balances_peerview $node3_ipc "peer3 view"

echo "Shutdown."

kill -9 $node1
kill -9 $node2
kill -9 $node3
