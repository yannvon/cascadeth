#!/bin/bash

# Note: Accounts must already be present
init_time=2

nodekey1="enode://734978d67c9662f4bf63ca680de429025dae500577e24812da6f1bb0ae7234b40a3424b27988089e30d006f7d8609bacd3e1e000fe1938e0832a1e4719c70aeb@127.0.0.1:30303?discport=0"
nodekey2="enode://c7fadd8d96d775125e133cf834f06000b62abb70f0b9f4776f8c697ded5a71497148669c96166aa031789ed7e34789ae1ce472c63d192611724fab804cf3388f@127.0.0.1:30304?discport=0"
nodekey3="enode://9986c9600bb25957012ee7904d1a3f79aaa4168ab6b52e775d151a79fed6ce9f06a6da4b0e5e54a3d8610d59f029750761370ae09fd28d7465314c3be5c4dc6b@127.0.0.1:30305?discport=0"

# gnome-terminal to open new window ! https://askubuntu.com/questions/1228251/how-do-i-create-a-script-to-open-a-new-terminal-and-execute-a-command

# Execute from cascadeth directory
cd ~/Documents/cascadeth

# Compile and install geth
go install -v ./cmd/geth

# Delete database before init
rm -r "data/data-cascade-1/geth/chaindata"
rm -r "data/data-cascade-2/geth/chaindata"
rm -r "data/data-cascade-3/geth/chaindata"

# Init blockchain from genesis
/home/yann/go/bin/geth init --datadir data/data-cascade-1 data/genesis-cascade.json
/home/yann/go/bin/geth init --datadir data/data-cascade-2 data/genesis-cascade.json
/home/yann/go/bin/geth init --datadir data/data-cascade-3 data/genesis-cascade.json


# Start all three nodes
# trap "kill 0" EXIT # Sometimes kill -9 is needed, why ?

echo "Starting geth nodes."
# nodiscover breaks a lot of stuff, but with manual adding it should work
/home/yann/go/bin/geth --datadir data/data-cascade-1 --nodiscover --networkid 15 --port 30303 --syncmode full --verbosity 4 --cache.snapshot 0 --ipcpath geth1.ipc --netrestrict 127.0.0.0/24 --unlock 0x78161ecF55Dc59Bd9E9c5C6620c0eb2Ad3b4d555 --password data/pwd1.txt &> data/geth1.log &
node1=$!
/home/yann/go/bin/geth --datadir data/data-cascade-2 --nodiscover --networkid 15 --port 30304 --syncmode full --verbosity 4 --cache.snapshot 0 --ipcpath geth2.ipc --netrestrict 127.0.0.0/24 --unlock 0xBbd5695c790F13b470c44b5950311C8dd24f78E6 --password data/pwd2.txt --bootnodes "enode://734978d67c9662f4bf63ca680de429025dae500577e24812da6f1bb0ae7234b40a3424b27988089e30d006f7d8609bacd3e1e000fe1938e0832a1e4719c70aeb@127.0.0.1:30303" &> data/geth2.log &
node2=$!
/home/yann/go/bin/geth --datadir data/data-cascade-3 --nodiscover --networkid 15 --port 30305 --syncmode full --verbosity 4 --cache.snapshot 0 --ipcpath geth3.ipc --netrestrict 127.0.0.0/24 --bootnodes "enode://734978d67c9662f4bf63ca680de429025dae500577e24812da6f1bb0ae7234b40a3424b27988089e30d006f7d8609bacd3e1e000fe1938e0832a1e4719c70aeb@127.0.0.1:30303","enode://c7fadd8d96d775125e133cf834f06000b62abb70f0b9f4776f8c697ded5a71497148669c96166aa031789ed7e34789ae1ce472c63d192611724fab804cf3388f@127.0.0.1:30304" &> data/geth3.log  &
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
#echo $enode1,$enode2,$enode3

# add peers
echo "Adding peers manually."
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-2/geth2.ipc --exec "admin.addPeer($enode1)"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-3/geth3.ipc --exec "admin.addPeer($enode1)"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-3/geth3.ipc --exec "admin.addPeer($enode2)"

sleep 5

# Start mining
echo "Start mining."
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc --exec "miner.start(0)"
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-2/geth2.ipc --exec "miner.start(0)"

sleep 4

# Send a transaction
/home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/data-cascade-1/geth1.ipc --exec "miner.start(0)"


# TODO open geth pipes in seperate windows

# Cleanup
#wait
sleep 350
echo "Shutdown."

kill -9 $node1
kill -9 $node2
kill -9 $node3
