#!/bin/bash

# Note: Accounts must already be present

# Execute from cascadeth directory
cd ~/Documents/cascadeth

# Compile and install geth
go install -v ./cmd/geth

# Delete database before init
rm -r "data/data-cascade-1/geth"
rm -r "data/data-cascade-2/geth"
rm -r "data/data-cascade-3/geth"

# Init blockchain from genesis
/home/yann/go/bin/geth init --datadir data/data-cascade-1 data/genesis-cascade.json
/home/yann/go/bin/geth init --datadir data/data-cascade-2 data/genesis-cascade.json
/home/yann/go/bin/geth init --datadir data/data-cascade-3 data/genesis-cascade.json

# Start all three nodes
trap "kill 0" EXIT

echo ""
echo "-------------------------------------------------------------------------"
echo "---- Starting geth nodes ------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo ""

/home/yann/go/bin/geth --datadir data/data-cascade-1 --networkid 15 --port 30303 --syncmode full --verbosity 4 --ipcpath geth1.ipc --netrestrict 127.0.0.0/24 --mine --unlock 0x78161ecF55Dc59Bd9E9c5C6620c0eb2Ad3b4d555 --password data/pwd1.txt &> data/geth1.log &
/home/yann/go/bin/geth --datadir data/data-cascade-2 --networkid 15 --port 30304 --syncmode full --verbosity 4 --ipcpath geth2.ipc --netrestrict 127.0.0.0/24 --mine --unlock 0xBbd5695c790F13b470c44b5950311C8dd24f78E6 --password data/pwd2.txt --bootnodes "enode://f32672dffac07c4f6b26dd1122b4f820d4a7f153987171e17d2ccb4e91e5da9552e9277e680bc76db4788a21540c0af5153924c1e39452d78936bb398e03fb0c@127.0.0.1:30303" &> data/geth2.log &
/home/yann/go/bin/geth --datadir data/data-cascade-3 --networkid 15 --port 30305 --syncmode full --verbosity 4 --ipcpath geth3.ipc --netrestrict 127.0.0.0/24 --bootnodes "enode://f32672dffac07c4f6b26dd1122b4f820d4a7f153987171e17d2ccb4e91e5da9552e9277e680bc76db4788a21540c0af5153924c1e39452d78936bb398e03fb0c@127.0.0.1:30303","enode://1ca0da9912725949f52238c865fb80400f65e7d1e22849128baf6434e107584054d84fbcb1d619e45499117920e726ad434a0fb9537cc02d309b168b9f4f3ada@127.0.0.1:30304" &> data/geth3.log  &

# TODO start mining after 10 seconds of waiting, such that peers can be chosen.

# TODO open geth pipes in seperate windows

wait
