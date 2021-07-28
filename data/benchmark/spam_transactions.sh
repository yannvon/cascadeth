
# Get funds to all accounts from main account


# Option 1: Unlock all accounts
for i in {0..9}
do
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/benchmark/datadir/node0/geth0.ipc --exec "personal.unlockAccount(eth.accounts[$i], '', 10000000)"
done

# Get funds to all accounts from main account (account 0)
for i in {0..9}
do
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/benchmark/datadir/node0/geth0.ipc --exec "eth.sendTransaction({from:eth.accounts[0], to: eth.accounts[$i], value: 10000000000000000000, gas: 21000, gasPrice: 100000000000})"
done

sleep 10

# Spam transaction
for i in {0..9}
do
  /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/data/benchmark/datadir/node0/geth0.ipc --exec "eth.sendTransaction({from:eth.accounts[$i], to: 'a6e1809e41b94caceeb44f475e892e394a943691', value: 1000000000000000000, gas: 21000, gasPrice: 100000000000})"
done


# Option 2: Unlocks when necessary
#"personal.sendTransaction({from: eth.accounts[$i], to: 'a6e1809e41b94caceeb44f475e892e394a943691', value: web3.toWei(1.0, "ether")}, '')""
