
ipc_str_1="/home/yann/Documents/cascadeth/scripts/benchmark/datadir/node"
ipc_str_2="/geth"
ipc_str_3=".ipc"




# /home/yann/go/bin/geth attach /home/yann/Documents/cascadeth/scripts/benchmark/datadir/node1/geth1.ipc

# sudo tc qdisc del dev lo root netem delay 200ms 300ms

# tail -f ./Documents/cascadeth/scripts/benchmark/datadir/geth2.log

# DoubleSpend 1
# eth.signTransaction({from:"0xa6e1809e41b94caceeb44f475e892e394a943691", gas:21000, to:"0x0880213c848114c92bbb36e14916cedb43e70669", value:100000000, gasPrice:100000000000, nonce:0})
doubleSpend1="eth.sendRawTransaction('0xf8688085174876e800825208940880213c848114c92bbb36e14916cedb43e706698405f5e1008041a0e78522672768265f6d1f4cb60dc5a844c3f3ce78e2c8dda8478fdb39f9207df5a03c94c60cd5ad3d63a81f108ffb0eceb479eb2c8ca4098d560b1d7b24ab3f9ebd')"

# DoubleSpend 2
# eth.signTransaction({from:"0xa6e1809e41b94caceeb44f475e892e394a943691", gas:21000, to:"0x911eef17ec3b4041b91491b57b5d55bf969904ea", value:100000000, gasPrice:200000000000, nonce:0})

doubleSpend2="eth.sendRawTransaction('0xf86880852e90edd00082520894911eef17ec3b4041b91491b57b5d55bf969904ea8405f5e1008041a0956378f83cf00e27835020fa8043f2442484a31d7259076d36b2f253296bea90a0457b11e75ec0bacdc791377728d8bb0a3e0fbee158ae2c4715b0797032de3c55')"



for j in $(seq 0 $1)
do
  /home/yann/go/bin/geth attach $ipc_str_1$j$ipc_str_2$j$ipc_str_3 --exec $doubleSpend1
done

for j in $(seq $2 5)
do
  /home/yann/go/bin/geth attach $ipc_str_1$j$ipc_str_2$j$ipc_str_3 --exec $doubleSpend2
done
