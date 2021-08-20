cd ~/Documents/cascadeth

# Create Accounts
echo "Enter number of accounts per node"
read n

for i in $(seq 1 $n)
do
  #echo "hello"
  /home/yann/go/bin/geth account new --password scripts/thesis-example/password.txt --datadir scripts/thesis-example/datadir/node0 --lightkdf #light kdf doesn't matter for testing
  /home/yann/go/bin/geth account new --password scripts/thesis-example/password.txt --datadir scripts/thesis-example/datadir/node1 --lightkdf
  /home/yann/go/bin/geth account new --password scripts/thesis-example/password.txt --datadir scripts/thesis-example/datadir/node2 --lightkdf
  /home/yann/go/bin/geth account new --password scripts/thesis-example/password.txt --datadir scripts/thesis-example/datadir/node3 --lightkdf

done

echo "Bye"
