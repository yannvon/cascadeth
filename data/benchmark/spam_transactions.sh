
ipc_str_1="/home/yann/Documents/cascadeth/data/benchmark/datadir/node"
ipc_str_2="/geth"
ipc_str_3=".ipc"



# Option 1: Unlock all accounts
for j in {0..2}
do
  for i in {0..99}
  do
    /home/yann/go/bin/geth attach $ipc_str_1$j$ipc_str_2$j$ipc_str_3 --exec "personal.unlockAccount(eth.accounts[$i], '', 10000000)"
  done
done

# Spam transaction

for k in {0..5}
do
  for j in {0..2}
  do
    for i in {0..99}
    do
      /home/yann/go/bin/geth attach $ipc_str_1$j$ipc_str_2$j$ipc_str_3 --exec "eth.sendTransaction({from:eth.accounts[$i], to: 'a6e1809e41b94caceeb44f475e892e394a943691', value: 1000000000000000000, gas: 21000, gasPrice: 100000000000})"
    done
  done
sleep 20
done


# Option 2: Unlocks when necessary
#"personal.sendTransaction({from: eth.accounts[$i], to: 'a6e1809e41b94caceeb44f475e892e394a943691', value: web3.toWei(1.0, "ether")}, '')""
