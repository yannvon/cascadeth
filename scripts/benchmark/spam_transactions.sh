#ipc_str_1="/home/yann/Documents/cascadeth/scripts/benchmark/datadir/node"
ipc_str_1="/local/home/yvonlanthen/Documents/cascadeth/scripts/benchmark/datadir/node"
ipc_str_2="/geth"
ipc_str_3=".ipc"

geth_path=/local/home/yvonlanthen/go/bin/geth
#path=/home/yann/go/bin/geth


# Option 1: Unlock all accounts
# personal.unlockAccount(eth.accounts[0], '', 10000000)
# eth.sendTransaction({from:eth.accounts[0], to: 'a6e1809e41b94caceeb44f475e892e394a943691', value: 1000000000000000000, gas: 21000, gasPrice: 100000000000})


for j in {0..2}
do
  for i in {0..9}
  do
    $geth_path attach $ipc_str_1$j$ipc_str_2$j$ipc_str_3 --exec "personal.unlockAccount(eth.accounts[$i], '', 10000000)"
  done
done

# Spam transaction
START=$(date +%s.%N)

for k in {0..15}
do
  for j in {0..2}
  do
    for i in {0..9}
    do
      $geth_path attach $ipc_str_1$j$ipc_str_2$j$ipc_str_3 --exec "eth.sendTransaction({from:eth.accounts[$i], to: 'a6e1809e41b94caceeb44f475e892e394a943691', value: 1000000000000000000, gas: 21000, gasPrice: 100000000000})"
    done
  done
  END=$(date +%s.%N)
  DIFF=$(echo "$END - $START" | bc)
  echo $DIFF

sleep 10
done
echo $mytime

# Option 2: Unlocks when necessary
#"personal.sendTransaction({from: eth.accounts[$i], to: 'a6e1809e41b94caceeb44f475e892e394a943691', value: web3.toWei(1.0, "ether")}, '')""
