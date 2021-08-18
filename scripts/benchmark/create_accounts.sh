cd ~/Documents/cascadeth

# Create Accounts
echo "Enter number of accounts per node, and thus transactions per block"
read n

for i in $(seq 1 $n)
do
  #echo "hello"
  /home/yann/go/bin/geth account new --password data/benchmark/password.txt --datadir data/benchmark/datadir/node0 --lightkdf #light kdf doesn't matter for testing
  /home/yann/go/bin/geth account new --password data/benchmark/password.txt --datadir data/benchmark/datadir/node1 --lightkdf
  /home/yann/go/bin/geth account new --password data/benchmark/password.txt --datadir data/benchmark/datadir/node2 --lightkdf
  /home/yann/go/bin/geth account new --password data/benchmark/password.txt --datadir data/benchmark/datadir/node3 --lightkdf
  /home/yann/go/bin/geth account new --password data/benchmark/password.txt --datadir data/benchmark/datadir/node4 --lightkdf
  /home/yann/go/bin/geth account new --password data/benchmark/password.txt --datadir data/benchmark/datadir/node5 --lightkdf
  /home/yann/go/bin/geth account new --password data/benchmark/password.txt --datadir data/benchmark/datadir/node6 --lightkdf
  /home/yann/go/bin/geth account new --password data/benchmark/password.txt --datadir data/benchmark/datadir/node7 --lightkdf
  /home/yann/go/bin/geth account new --password data/benchmark/password.txt --datadir data/benchmark/datadir/node8 --lightkdf
  /home/yann/go/bin/geth account new --password data/benchmark/password.txt --datadir data/benchmark/datadir/node9 --lightkdf
done

echo "Bye"
