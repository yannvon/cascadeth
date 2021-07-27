cd ~/Documents/cascadeth

rm -r "data/benchmark/datadir/node0/geth"
rm -r "data/benchmark/datadir/node1/geth"
rm -r "data/benchmark/datadir/node2/geth"
rm -r "data/benchmark/datadir/node3/geth"
rm -r "data/benchmark/datadir/node4/geth"
rm -r "data/benchmark/datadir/node5/geth"
rm -r "data/benchmark/datadir/node6/geth"
rm -r "data/benchmark/datadir/node7/geth"
rm -r "data/benchmark/datadir/node8/geth"
rm -r "data/benchmark/datadir/node9/geth"


# Init blockchain from genesis
/home/yann/go/bin/geth init --datadir data/benchmark/datadir/node0 data/benchmark/genesis.json
/home/yann/go/bin/geth init --datadir data/benchmark/datadir/node1 data/benchmark/genesis.json
/home/yann/go/bin/geth init --datadir data/benchmark/datadir/node2 data/benchmark/genesis.json
/home/yann/go/bin/geth init --datadir data/benchmark/datadir/node3 data/benchmark/genesis.json
/home/yann/go/bin/geth init --datadir data/benchmark/datadir/node4 data/benchmark/genesis.json
/home/yann/go/bin/geth init --datadir data/benchmark/datadir/node5 data/benchmark/genesis.json
/home/yann/go/bin/geth init --datadir data/benchmark/datadir/node6 data/benchmark/genesis.json
/home/yann/go/bin/geth init --datadir data/benchmark/datadir/node7 data/benchmark/genesis.json
/home/yann/go/bin/geth init --datadir data/benchmark/datadir/node8 data/benchmark/genesis.json
/home/yann/go/bin/geth init --datadir data/benchmark/datadir/node9 data/benchmark/genesis.json


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
