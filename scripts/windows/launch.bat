:: Execute from cascadeth directory
go install -v ./cmd/geth

:: Accounts must already be present
cd D:\Documents\cascadeth

:: Delete database before init
rd /s /q "data/data-cascade-1/geth"
rd /s /q "data/data-cascade-2/geth"
rd /s /q "data/data-cascade-3/geth"

:: Init blockchain from genesis
geth init --datadir data/data-cascade-1 data/genesis-cascade.json
geth init --datadir data/data-cascade-2 data/genesis-cascade.json
geth init --datadir data/data-cascade-3 data/genesis-cascade.json

:: Start all three nodes
START "node1" /D "D:\Documents\cascadeth" geth --datadir data/data-cascade-1 --networkid 15 --port 30303 --syncmode full --ipcpath geth1.ipc --netrestrict 127.0.0.0/24 --mine --unlock 0x78161ecF55Dc59Bd9E9c5C6620c0eb2Ad3b4d555 --password data/pwd1.txt
START "node2" /D "D:\Documents\cascadeth" geth --datadir data/data-cascade-2 --networkid 15 --port 30304 --syncmode full --ipcpath geth2.ipc --netrestrict 127.0.0.0/24 --mine --unlock 0xBbd5695c790F13b470c44b5950311C8dd24f78E6 --password data/pwd2.txt --bootnodes "enode://01bee8f3e8db6de17801bc7273e4171a5a20a136c23d39623337268118132acfe0adcdcc5e5df5f95b8f5d3c0933d632621a3a065cf9b5015a7e7806ee9b5903@127.0.0.1:30303"
START "node3" /D "D:\Documents\cascadeth" geth --datadir data/data-cascade-3 --networkid 15 --port 30305 --syncmode full --ipcpath geth3.ipc --netrestrict 127.0.0.0/24 --bootnodes "enode://01bee8f3e8db6de17801bc7273e4171a5a20a136c23d39623337268118132acfe0adcdcc5e5df5f95b8f5d3c0933d632621a3a065cf9b5015a7e7806ee9b5903@127.0.0.1:30303","enode://e6f68f6aeadcd2fea97aeecf67256f52dba6430ee9b5c1d60f69df03a5020a5e9e6915ae5bc5e3a4b60bc5ac7f582adc7fd2e1f1220327295e093bcc01ec8cb8@127.0.0.1:30304"