#!/bin/bash

# variables
verbosity=5

# Note: Accounts must already be present
init_time=2

bootnodes="enode://eabfe0c1deadd40b63b4405789ef44c4a5109d7de93bcec80c4d7332d50940ef8bb732db2b37944ef239436113652db94b8f04a54857e145d6257a97ac002647@127.0.0.1:0?discport=30301"

node0_acc1="8d0448e9109d5d93a77061918ded588ddb8ebe97"
node0_acc2="301a741979ea27efce478535705917c07a7657f4"
node1_acc1="5541404e8d8905a1d85852a4e31650497b043583"
node2_acc1="3f6ce49ac4eeb0393346dd8e0ad40d4a55c94b08"
node3_acc1="68db7984c3fc91d2b6897864b4b6a86590a70f40"

node0_ipc="scripts/thesis-example/datadir/node0/geth0.ipc"
node1_ipc="scripts/thesis-example/datadir/node1/geth1.ipc"
node2_ipc="scripts/thesis-example/datadir/node2/geth2.ipc"
node3_ipc="scripts/thesis-example/datadir/node3/geth3.ipc"


tx_str_1="web3.fromWei(eth.getBalance('"
tx_str_2="'),'ether')"

ipc_str_1="scripts/thesis-example/datadir/node"
ipc_str_2="/geth"
ipc_str_3=".ipc"



check_balances_peerview () {
  echo $2
  /home/yann/go/bin/geth attach $1 --exec $tx_str_1$node0_acc1$tx_str_2
  /home/yann/go/bin/geth attach $1 --exec $tx_str_1$node0_acc2$tx_str_2
  /home/yann/go/bin/geth attach $1 --exec $tx_str_1$node1_acc1$tx_str_2
  /home/yann/go/bin/geth attach $1 --exec $tx_str_1$node2_acc1$tx_str_2
  /home/yann/go/bin/geth attach $1 --exec $tx_str_1$node3_acc1$tx_str_2
}


# Execute from cascadeth directory
cd ~/Documents/cascadeth

# Compile and install geth
# allow multiple definitions, since both cascadeth and geth access same C source files
# https://stackoverflow.com/questions/56318343/golang-multiple-definition-of-cgo-ported-package
go install --ldflags '-extldflags "-Wl,--allow-multiple-definition"' -v ./cmd/geth

# Delete database before init

rm -r "scripts/thesis-example/datadir/node0/geth"
rm -r "scripts/thesis-example/datadir/node1/geth"
rm -r "scripts/thesis-example/datadir/node2/geth"
rm -r "scripts/thesis-example/datadir/node3/geth"


# Init blockchain from genesis
/home/yann/go/bin/geth init --datadir scripts/thesis-example/datadir/node0 scripts/thesis-example/genesis.json
/home/yann/go/bin/geth init --datadir scripts/thesis-example/datadir/node1 scripts/thesis-example/genesis.json
/home/yann/go/bin/geth init --datadir scripts/thesis-example/datadir/node2 scripts/thesis-example/genesis.json
/home/yann/go/bin/geth init --datadir scripts/thesis-example/datadir/node3 scripts/thesis-example/genesis.json


echo "Start bootnode"
/home/yann/go/bin/bootnode --nodekey scripts/thesis-example/bootnode.key &
bootnode=$!


echo "Starting geth nodes."
/home/yann/go/bin/geth --datadir scripts/thesis-example/datadir/node0  --gcmode archive --bootnodes $bootnodes --metrics --metrics.addr 127.0.0.1 --metrics.port 6061 --networkid 15 --port 30303 --http.port 8101 --syncmode full --verbosity $verbosity --cache.snapshot 0 --ipcpath geth0.ipc --netrestrict 127.0.0.0/24 --unlock 0x8d0448e9109d5d93a77061918ded588ddb8ebe97 --password scripts/thesis-example/password.txt &> scripts/thesis-example/log/geth0.log &
node0=$!
/home/yann/go/bin/geth --datadir scripts/thesis-example/datadir/node1  --gcmode archive --bootnodes $bootnodes --metrics --metrics.addr 127.0.0.1 --metrics.port 6062 --networkid 15 --port 30304 --http.port 8102 --syncmode full --verbosity $verbosity --cache.snapshot 0 --ipcpath geth1.ipc --netrestrict 127.0.0.0/24 --unlock 0x5541404e8d8905a1d85852a4e31650497b043583 --password scripts/thesis-example/password.txt &> scripts/thesis-example/log/geth1.log &
node1=$!
/home/yann/go/bin/geth --datadir scripts/thesis-example/datadir/node2  --gcmode archive --bootnodes $bootnodes --metrics --metrics.addr 127.0.0.1 --metrics.port 6063 --networkid 15 --port 30305 --http.port 8103 --syncmode full --verbosity $verbosity --cache.snapshot 0 --ipcpath geth2.ipc --netrestrict 127.0.0.0/24 --unlock 0x3f6ce49ac4eeb0393346dd8e0ad40d4a55c94b08 --password scripts/thesis-example/password.txt &> scripts/thesis-example/log/geth2.log  &
node2=$!
/home/yann/go/bin/geth --datadir scripts/thesis-example/datadir/node3  --gcmode archive --bootnodes $bootnodes --metrics --metrics.addr 127.0.0.1 --metrics.port 6064 --networkid 15 --port 30306 --http.port 8104 --syncmode full --verbosity $verbosity --cache.snapshot 0 --ipcpath geth3.ipc --netrestrict 127.0.0.0/24 --unlock 0x68db7984c3fc91d2b6897864b4b6a86590a70f40 --password scripts/thesis-example/password.txt &> scripts/thesis-example/log/geth3.log  &
node3=$!

# sleep $init_time
# Note that the init time needed can depend on the connection to the geth network and the multishot smart contract !
sleep 10


# Check balances
check_balances_peerview $node0_ipc "peer0 view"
check_balances_peerview $node1_ipc "peer1 view"
check_balances_peerview $node2_ipc "peer2 view"
check_balances_peerview $node3_ipc "peer3 view"

# Start mining
echo "Start mining."
for i in $(seq 0 2)
do
  /home/yann/go/bin/geth attach $ipc_str_1$i$ipc_str_2$i$ipc_str_3 --exec "miner.start(0)"
done


sleep 10

# Send transactions
echo "Initiate transactions."

/home/yann/go/bin/geth attach scripts/thesis-example/datadir/node0/geth0.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '301a741979ea27efce478535705917c07a7657f4', value: 2000000000000000000, gas: 21000, gasPrice: 100000000000})"
/home/yann/go/bin/geth attach scripts/thesis-example/datadir/node1/geth1.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '301a741979ea27efce478535705917c07a7657f4', value: 2000000000000000000, gas: 21000, gasPrice: 100000000000})"
/home/yann/go/bin/geth attach scripts/thesis-example/datadir/node2/geth2.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '301a741979ea27efce478535705917c07a7657f4', value: 2000000000000000000, gas: 21000, gasPrice: 100000000000})"
/home/yann/go/bin/geth attach scripts/thesis-example/datadir/node3/geth3.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '301a741979ea27efce478535705917c07a7657f4', value: 2000000000000000000, gas: 21000, gasPrice: 100000000000})"

sleep 10

check_balances_peerview $node0_ipc "peer0 view"
check_balances_peerview $node1_ipc "peer1 view"
check_balances_peerview $node2_ipc "peer2 view"
check_balances_peerview $node3_ipc "peer3 view"


/home/yann/go/bin/geth attach scripts/thesis-example/datadir/node0/geth0.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '301a741979ea27efce478535705917c07a7657f4', value: 2000000000000000000, gas: 21000, gasPrice: 100000000000})"
/home/yann/go/bin/geth attach scripts/thesis-example/datadir/node1/geth1.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '301a741979ea27efce478535705917c07a7657f4', value: 2000000000000000000, gas: 21000, gasPrice: 100000000000})"
/home/yann/go/bin/geth attach scripts/thesis-example/datadir/node2/geth2.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '301a741979ea27efce478535705917c07a7657f4', value: 2000000000000000000, gas: 21000, gasPrice: 100000000000})"
/home/yann/go/bin/geth attach scripts/thesis-example/datadir/node3/geth3.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: '301a741979ea27efce478535705917c07a7657f4', value: 2000000000000000000, gas: 21000, gasPrice: 100000000000})"


# Cleanup
#wait
sleep 10

# Check balances
check_balances_peerview $node0_ipc "peer0 view"
check_balances_peerview $node1_ipc "peer1 view"
check_balances_peerview $node2_ipc "peer2 view"
check_balances_peerview $node3_ipc "peer3 view"

echo "Shutdown."

kill -9 $node0
kill -9 $node1
kill -9 $node2
kill -9 $node3
kill -9 $bootnode
