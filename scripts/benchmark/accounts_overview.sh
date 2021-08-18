tx_str_1="web3.fromWei(eth.getBalance(eth.accounts["
tx_str_2="]),'ether')"

ipc_str_1="/home/yann/Documents/cascadeth/data/benchmark/datadir/node"
ipc_str_2="/geth"
ipc_str_3=".ipc"


for i in $(seq 0 $2)
do
  /home/yann/go/bin/geth attach $ipc_str_1$1$ipc_str_2$1$ipc_str_3 --exec $tx_str_1$i$tx_str_2
done
