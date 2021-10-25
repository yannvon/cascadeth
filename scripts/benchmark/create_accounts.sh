cd ~/Documents/cascadeth

# Create Accounts
echo "Enter number of accounts per node, and thus transactions per block"
read n

#path=/home/yann/go/bin/geth
path=/usr/local/go/bin/geth


for i in $(seq 1 $n)
do
  #echo "hello"
  $path account new --password scripts/benchmark/password.txt --datadir scripts/benchmark/datadir/node0 --lightkdf #light kdf doesn't matter for testing
  $path account new --password scripts/benchmark/password.txt --datadir scripts/benchmark/datadir/node1 --lightkdf
  $path account new --password scripts/benchmark/password.txt --datadir scripts/benchmark/datadir/node2 --lightkdf
  $path account new --password scripts/benchmark/password.txt --datadir scripts/benchmark/datadir/node3 --lightkdf
  $path account new --password scripts/benchmark/password.txt --datadir scripts/benchmark/datadir/node4 --lightkdf
  $path account new --password scripts/benchmark/password.txt --datadir scripts/benchmark/datadir/node5 --lightkdf
  $path account new --password scripts/benchmark/password.txt --datadir scripts/benchmark/datadir/node6 --lightkdf
  $path account new --password scripts/benchmark/password.txt --datadir scripts/benchmark/datadir/node7 --lightkdf
  $path account new --password scripts/benchmark/password.txt --datadir scripts/benchmark/datadir/node8 --lightkdf
  $path account new --password scripts/benchmark/password.txt --datadir scripts/benchmark/datadir/node9 --lightkdf
done

echo "Bye"
