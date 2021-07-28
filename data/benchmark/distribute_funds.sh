
ipc_str_1="/home/yann/Documents/cascadeth/data/benchmark/datadir/node"
ipc_str_2="/geth"
ipc_str_3=".ipc"



# Option 1: Unlock all accounts
for i in {0..2}
do
  /home/yann/go/bin/geth attach $ipc_str_1$i$ipc_str_2$i$ipc_str_3 --exec "personal.unlockAccount(eth.accounts[0], '', 10000000)"
done

# Get funds to all accounts from main account (account 0)
for i in {1..9}
do
  for j in {0..2}
  do
    /home/yann/go/bin/geth attach $ipc_str_1$j$ipc_str_2$j$ipc_str_3 --exec "eth.sendTransaction({from:eth.accounts[0], to: eth.accounts[$i], value: 10000000000000000000, gas: 21000, gasPrice: 100000000000})"
  done
  sleep 12
done

sleep 10
