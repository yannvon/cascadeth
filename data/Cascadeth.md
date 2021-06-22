# Cascadeth

This document shall outline the inner workings of *cascadeth*, a client supporting the proof-of-stake protocol called Cascade. This proof-of-concept client was built using the go-ethereum client, and adapts the Cascade protocol to work well with the underlying go-ethereum implementation.

##  Longterm plan

- [ ] Find most convenient mapping between eth and cascade. (change both protocols accordingly)
- [x] Core (blockchain / header chain)
- [x] Consensus (creating, signing & verifying blocks)
- [x] Try starting all processes at same time & rely solely on regular propagation -> only need some logging mechanism
- [ ] Adapting blockchain -> add better sidechain management. (persistance, and more)
- [ ] Transmission protocol (propagation, fetching & syncing)
- [ ] Transactions -> can be performed at any time, need to be verified & acknowledged in a block
- [ ] Mining/worker -> include transaction that we see & validate in blocks as ack
- [ ] Processing -> Applying state change after transaction was sufficiently verified (stake)
- [ ] Checkpoints
- [ ] Permission-less
- [ ] State-flux
- [ ] Other optimizations (tune rewards, etc.)

## Introduction

## Ethereum overview



## Cascade FAQ



#### Option 1: Put all blocks in same chain locally, in processing order

##### Pro 

- Locally the same structure can be kept

##### Con

- Exchanging blocks becomes a nightmare, as the local order is different everywhere, the parent links (parentHash) are different everywhere, and we can't use difficulty for sync.

- 

- 

#### [REJECTED] Option 2a: One blockchain, not keeping track of height, allow out of order block imports

##### Pro 

- No need to change blockchain even.

##### Con

- Dropped blocks will never be retransmitted, not even a reliable broadcast mechanism.

#### [REJECTED] Option 2b: One blockchain but no synchronizing, permissonned system, with all peers known.

##### Pro 

- No need to touch downloader. ( I thought)
- No need to create & delete sidechains.

##### Con

- Peers have to start at the exact same time for this to work, and have the full peerset in memory immediately. This is impossible to guarantee, since peer adding and removing is a mostly independent module. 
- Goes against goal of permissionless implementation.
- Not future proof at all.

#### [CURRENT] Option 2c: One blockchain/DAG, with many sidechains.

c1: synchronizing only local chain -> c2: synchronizing all chains

##### Pro 

- Most of the local architecture/db is the same, most modules work in the same way.
- More control.
- Better understanding of system.
- Easier future changes.

##### Con

- Exchanging blocks becomes harder. 
- We need to change blockchain module and keep track of all sidechains.
- Changes to fetching and syncing/downloading.
- Need to spawn more threads, handle that externally but controlled internally.

#### [REJECTED] Option 3: Multiple separate blockchains, one created by each peer

##### Implications

- changing eth66 protocol:
  - different status messages: td is now a vector ?

##### Pro 

- Syncing, Downloading and Fetching can be kept the same.
- 

##### Con

- Changing core and many other modules, as they all rely on single blockchain. : We could keep them and let them have only local chain.
- A new validator means a whole new blockchain: Not really a problem in terms of memory efficiency. List of valid signers can be used to create new chains (for now they can exist from the start.)
- Easier at the start, but might create problems down the line: how can a new validator tell others to keep new chain for his blocks: as soon as a node sees new signature allowed, creates new chain.
- How is state kept between all chains ? New and separate module, insertBlocks can alter that.
- Extremely unclean ! Every chain needs separate db, need so many processes and threads (seperate fetcher, filters, syncer, etc.), does absolutely not scale. Not a good time investment for future, as it will never be good enough for a decent system.
- More changes in backend, config etc. (altough good learning opportunity, very painful)
- Some inner processes (clique snapshot) have big outside effects -> spawning new db's, chains and handlers. Can become very messy.

#### Why do we need ordering for option 2 ? In other words, why should the parents already be imported ?

If we do not have an order, then syncing won't work, as we might already know a future block, but have some missing ones. Eventually we have to request the missing blocks anyways, might as well keep the future blocks in queue until the older ones are received.

#### Why not change broadcast completely and add acks instead of using blocks?

System would not be permission-less anymore, i.e. joining would be harder / impossible. -> We need a mechanism to resend past acks, even if some peers are down. If we allow permissionless, then broadcast algorithm becomes just as complicated as current block distribution.

#### Why do we need downloader/syncing ? 

Mechanism for new peers to join and get the past messages, in order to recreate state.

#### Do we need to sync all chains with one peer ?

UNSURE!  as the original validator of one chain might be offline. (but does that make him count as malicious and then ? )

Big implications, as if syncing only local chain is enough, then we do not need to change td field, which would be big help.

What if we use td and common.Address to snyc specific side chain ? Impossible to know which one is still active -> bad solution, except if we iterate through all of them.









## Cascadeth implementation details

## Overall

- Blocks become simply means of broadcasting acknowledgements of transactions.
- The blockchain becomes the history of acknowledgements, with the idea that a new client can join and verify the validity of transactions by fetching all previous blocks. (through an existing mechanism)
- tx can be sent with invalid funds, will only be approved once enough funds available.
- The chain is actually multiple sidechains branching off after genesis. 
- A checkpoint mechanism can be implemented to regroup chains.
- Sidechains can advance at different speeds -> blockfetcher line 415 removed, check not too old or too young, line 763 again

### Blockchain (Core)

This core component is in charge of handling and storing the blocks in a chain. It leverages the database components, and allows for insertion of blocks, using a corresponding consensus engine.

Changes applied to specifications:

Most changes were applied through the changes in the engine, who verifies which blocks to insert. Notably the new engine allows for old and newer blocks to be inserted.

- IMPORTANT: CHANGE: maintain ordering of import
  - Previous: blocks can be fetched in any order, and old and new blocks will still be imported. Reasoning: If a validator has incorrect parent hash and/or doesn't send a block in the chain, its his problem, as this might simply result in acks being dropped, but no security problem (check?)

##### Changes

- Add new currentBlockByValidator map, to track latest received block for each sidechain.

##### TODO

- [ ] Keep track of height of every side chain (fixed validators for now, every validator has common.Address)
- [ ] Persist all sidechains.
- [ ] Change total difficulty to being a map of addresses to td of that current block.
- [ ] Create side chain accessors (headByValidator, heightByValidator, heightMap -> used for syncing)
- [ ] 

##### Questions:

- do blocks have to be inserted in sequence ? YES
- do we need heightMap or heightVector ? Can height map be transmitted in blocks ?

### Consensus engine

Decides the rules for which header is valid, how to prepare and finalize blocks that have been produced.

#### Changes

- IMPORTANT: consensus engine does NOT prevent multiple of the same number blocks to come through for a single validator. (this might be necessary though in order to prevent spam, and in order to allow clean redistribution of acks)
- 

##### Questions:

- Do blocks have to come in sequence ? (light panic 30s, check last original commit !)

### Transactions 

- Locally ordered (FIFO order ?), by an existing field. If order is not respected, not enough acks might be gathered, and tx might be hanging.

### Checkpoints & Stake flux

TBD

## Ethereum Wire Protocol (package protocols)

I build cascadeth on top of version eth66. As for sync mode I will only support FullSync for now. (other modes are FastSync, LightSync and SnapSync ) 

Thus we use ethHandler instead of snapHandler. (config.SnapshotCache = 0)

With the Ethereum Wire Protocol version eth66, a new Block is first sent to some peers (proportional to the root of the number of peers) and the others only receive an announcement. If after some time they fail to receive the block from other peers, they may request it. This alleviates some network utilization. Note that still n^2 messages are needed, but most of them (announcements) are substantially smaller than full blocks.

#### Timeline

1. Permissionned setting where every peer/validator is present from beginning. Not that we should not need syncing in this context. 
2. Adding checkpoints on top
3. Making it pemissionless -> major changes to downloading and fetching.

### Backend (type Ethereum)

- txPool
- blockchain
- handler,
- etc.

There is also an ethHandler and snapHandler, that handle the respective back-end.

### (full node network) Handler

- SyncMode: fastSync, snapSync, etc.
- Downloader
- BlockFetcher
- TxFetcher
- peers

 -> makes protocols (either eth or snap, whitch then contain more specific handlers)

### Sync

Synchronises blockchain with a peer, by using downloader package. (depends on SyncMode)

##### TODO

- skipped for now

### Handler eth

ethHandler implements the eth.Backend interface to handle the various network packets that are sent as replies or broadcasts.

-> makes use/ forwards packets to fetcher and downloader.

##### Changes

- Disabled sync
- Allow broadcast of all blocks to full set of peers, not subset.
- More debug messages

### Package eth

1. 

#### Downloader 

Part of package: statesync

##### Questions

- How does Clique downloader work without TD field ? Might never use downloader ?
- When does block / header become ancient ?
- Can I forget about syncing for now and work on processing /fetching immediately ? (and add the permissionless part later ?) YES

##### TODO

#### BlockFetcher

In short, the fetcher is in charge of handling blocks received either through propagation or fetched after receiving an announcement. It can be notified by other peers of new blocks/headers as well as their hashes, but it can also directly receive blocks and headers in a queue. It performs most of its operations in a big main loop.

It receives two types of messages: notifications (header/block) or full propagations (header/blocks). One part takes care of requesting/fetching the full payload if after a notification the payload was not obtained through other means. If the node runs a full client, and only a header was received, then the fetching of the body is also scheduled. This operation is called completion. Eventually all fetched and received blocks end up in a queue. The queued blocks are imported if they have not been seen yet, if their parents are already imported and if they are not more than 1 above current chain height.

There is also one component who filters the received header and blocks, such that the requested payloads are kept by the fetcher, while other payloads are returned for other modules to use. (split into unknown, incomplete and complete)

For cascadeth, we need to change the fetcher such that it also fetches older and newer blocks, as with the many side-chains we can't guarantee that all chains grow at the same rate.

Note that so far the chain made sure that blocks are always delivered in order, i.e. their parent is already in the chain/dag. With multiple sidechains the existing mechanism can't guarantee this, without dropping potentially quite a fee packets,  which would then have to be imported by syncing. (?) Hence this restriction was lifted, and now all blocks can be imported irrespective of their parents and age.

This could have implications for chain syncing, but malicious peers who injected too many or not enough blocks are the ones who get punished. (FIXME what if adversary simply reorders packets ? -> both eventually are imported and thus not a problem, as long as we have a perfect link without deletions.)

DOS protection also needs to be adapted, as every validator can produce blocks indefinitely. However, a different kind of protection is added: Too many announcements/blocks in a short sequence can be punished ! (or not ? what about the network stalling and kicking valid peers ?)

##### Questions

- Why does light sequential/concurrent import take so much longer than full ?
- Is it ok to lift "parent known"  & age/height restrictions.

##### Changes

- Remove stale block protection
- Remove block limit from single peer
- Remove restriction to only import if parent already present -> No, but completely drop block if parent not present !
- Allow import of newer blocks (above current, local head) -> this fails most tests (mine included) but allows non-mining nodes to import blocks as well !

##### go-ethereum problems discovered

- can create deadlocks, (in test scenarios only), where queue can't be emptied, since priority is always set as -inf. 

##### TODO 

- Some tests don't work anymore because of line 368 if number > height+1. I removed this to make own tests work every time, as otherwise they could enter deadlock. 
- deadlock when running mix, for unknown reason
- Add new state to chain (height for sidechain) such that blocks can only be received in order, even for sidechains. For now only work in permissionned setting, hence no need right now (as holes will be filled through regular propagation & fetching)

### Validator / block creation



## Multichain attempt

1. Ethereum object needs sidechains and sidechains handlers
2. TEST IF I CAN RUN A SINGLE OTHER HANDLER THAT HANDLES CHAIN ID +1 (in future could be address mod 2^32)
   1. Extremely unclean ! need so many processes and threads, does absolutely not scale
3. Allowed signers/validators are usually read from the (single) block chain, which is hard to do at ceation time. Should engine create sidechains on the go ? 
4. Sidechains by signer address ? Sidechains by id to seperate them ?  

## Permissioned implementation

### 1.06 to 13.06

Debugging for four days: just commenting out chainSyncer does not work, as block fetcher is spawned from there. However, all call to chainSyncer were disabled in the process of debugging and thus I can run syncer loop without triggering sync. (for now this seems an ok solution.)

This tedious process also allowed me to write better scripts.

Worry about broadcast not satisfying necessary guarantees, however it seems that an announcing mechanism is in place.

### meeting 10.06

- each process chooses validator for stake, ie all his fund belong to same validator -> can simply be modeled by one node having multiple accounts, very simple !
- Can we implement a negative balance ? This would be required for us to be able to process confirmed transactions immediately
- If not, we need to keep them in a buffer and execute them as soon as the funds become available
- Also, we only confirm transactions for which the funds are available in the local state, this means we need to keep new incoming transaction in buffer until we can ack them when funds become available.

### 14.06

Finish debugging of block sending. 

Debug other parts, such that all chains can be imported correctly.

Namely: Make sure that the header is always the local chain. This helps to make sure that the time in which we can seal new blocks is right, and also that we order our blocks correctly. This time I feel like I should try understanding the processes more before debugging.

Can we get rid of unconfirmed blocks and add them immediately to main chain ?

### 15.06

- Add check such that only local blocs can be added to canonical chain :) (this prevents mining stop and other errors)
- Prevent reorgs from happening (again would mess with local chain)
- Non mining peer has problem with imports, as own height stays 0.
  - Cascadeth: We need ordering for permissionless syncing. For permissionless case we actually also need it as cascade acks are to be ordered ! Height is local height, which might be 0 if node is not mining. Thus we need some different mechanism.

Known bugs:

- Import if not mining: 

  - Solution short term: Anyone can mine their own blocks for now and thus keep chain growing
  - Solution mid term: Drop ordering requirement and simply drop out of order packets, they can then later be retrieved through syncing.

- Import of out of order blocks

  - Previously out of order blocks (ie. parent not present) were simply discarded and then imported through sync if needed (or other mechanism? do peers announce blocks through different means ? probably not.). two options

    1) keep in queue and keep track of side chain head to make sure we import it at the right time

    2) discard and either implement sync, or other mechanism.

*I need to understand fetcher better* -> done to the degree that I understand that indeed no ordering is guaranteed.



### 16.06

- [ ] Test tx broadcast and tx pool status
- [ ] test whether every miner includes all tx's in their blocks
- [ ] think about way to handle ack's and unconfirmed tx's
- [ ] think about how to process transaction

- Transactions are removed from pool once included in one block: not served to other peers anymore
- work on metrics -> how can we read them? Succeeded !
- Non-local txs are not accepted because they are underpriced.

### meeting 17.06

Broadcast transactions, (ie. make sure they are not removed from pool too early ?) - sounds like a bad idea !

OR read transactions from blocks, and add them to own pool (if not acked yet)

Conclusion:

- broadcast tx fix -> do not read form block now
- collect signatures and add to confirmed
- detach the state from head of local chain 

Either one or two additional data structures to keep unacked and unconfirmed transactions.



### 17.06

- meeting
- debugging underpriced transaction error -> gasPrice is in GWei (ie. 10⁹ or more is required, otherwise one can use --gasprice flag)
- Create new script with debugging option to include node run on VSC.



### 18.06

- [ ] 
- [x] detatch state from latest local block
- [ ] 



- find more occurences of syncing and remove it
- there are two different processes that can change the state: both insertingChain as well as commiting transactions in local blocks. Thus just changing (sidechain)- state has no effect in our case.
- Achieving the same outcome with test script with detached state ! Now missing piece is to process/insert every block and not just canonical chain.

### 20.06

- [x] debug node3, why not consistent state ?
  - [ ] State is read from currentHead and not state accessor. -> same is true for EVM context , receipts etc.
  - [ ] Solution: Update currentHead every time and keep different chain for local block creation ?
- [ ] prevent insert into sidechain

- execution of launch_tx.sh script is successful, ie. returns result as expected !! However, just a subset of all eth functionality of course, hence question on how much I should change/support.

### 21.06

- [x] remove tx reward: actually there are no block rewards but tx fees are distributed to block
- [ ] prevent insert into sidechain

### 22.06

- [ ] upgrade txPool to hold unconfirmed and processable transactions
- [ ] how to include txPool into Processor ? (part of blockchain ?)
- [ ] allow txPool to receive tx multiple times and increase weight of ack accordingly
- [ ] do not immediately process transactions once added to block -> instead check if processable isn't empty both when creating block and when receiving block
- [ ] implement a tx_list that sorts tx by weight of acks.

- can we go negative balance ? (temporarily, we have the guarantee that eventually the person will be positive again !) technically state_object account has balance of type big.Int, hence it could be possible to go negative ! :)

## Proof of stake

txPool has all transactions that have not been acked yet. For now only received through broadcast, later also added from block processing.

ackPool has all transactions that have at least one acknowledgement, and the corresponding weight of those acks. -> Proof of stake riority queue, where weight of acks is priority ? 





## TODO

- [ ] Prevent block spamming from malicious validators (DOS attack) ? Are all notifications accepted ? Are all blocks fetched ?
- [ ] Make sure that permissioned system has right security guarantees for broadcast.
- [ ] Block fetcher: remove ordering check (must not be too much bigger than current head), such that also non-mining nodes can import blocks. (and allow for async network / time drift)
- [ ] Import out of order blocks, for now we drop them. (either keep them in queue by having head per validator, or have syning)
- [ ] Read transactions from sidechains blocks as well
- [ ] Make all nodes archive nodes: bc.cacheConfig.TrieDirtyDisabled
- [ ] Remove transaction rewards for now
- [ ] Add two datastructures, one for transactions to confirm (txPool?) and one for tx waiting to be processed -> processing needs to check pool and see if new txs can be imported





## Testing

```powershell
geth init --datadir data-cascade-1 data/genesis-cascade.json
 

geth --datadir data-cascade --networkid 15 --port 30303 --unlock 0x78161ecF55Dc59Bd9E9c5C6620c0eb2Ad3b4d555 --mine --nodiscover

password: private

geth --datadir data-cascade-2 --networkid 15 --port 30304 --unlock 0xBbd5695c790F13b470c44b5950311C8dd24f78E6 --mine --nodiscover --ipcpath gethpipe.ipc

password: private2

geth attach \\.\pipe\geth.ipc
geth attach \\.\pipe\gethpipe.ipc

admin.nodeInfo.enode
admin.peers
personal.unlockAccount(eth.accounts[0])
eth.sendTransaction({from:eth.accounts[0], to: eth.accounts[1], value: 1, gas: 100000, gasPrice: 1})

admin.addPeer("enode://01bee8f3e8db6de17801bc7273e4171a5a20a136c23d39623337268118132acfe0adcdcc5e5df5f95b8f5d3c0933d632621a3a065cf9b5015a7e7806ee9b5903@127.0.0.1:30303?discport=0")
```



## VSC testing

```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [

        {
            "name": "Geth mainnet",
            "type": "go",
            "request": "launch",
            "mode": "debug",
            "program": "${workspaceFolder}/cmd/geth/",
            "args": [
            ],
        },

        {
            "name": "Launch cascadeth - peer 1",
            "type": "go",
            "request": "launch",
            "mode": "debug",
            "program": "${workspaceFolder}/cmd/geth/",
            "args": [
                "-networkid",
                "15",
                "-datadir",
                "C:\\Users\\Yann\\Documents\\data-cascade",
                "-port",
                "30303",
                "-unlock",
                "0x78161ecF55Dc59Bd9E9c5C6620c0eb2Ad3b4d555",
                "-mine",
                "-nodiscover",
                "-password",
                "C:\\Users\\Yann\\Documents\\pwd1.txt"
            ],
        },

        {
            "name": "Launch cascadeth - peer 2",
            "type": "go",
            "request": "launch",
            "mode": "debug",
            "program": "${workspaceFolder}/cmd/geth/",
            "args": [
                "-networkid",
                "15",
                "-datadir",
                "C:\\Users\\Yann\\Documents\\data-cascade-2",
                "-port",
                "30304",
                "-unlock",
                "0xBbd5695c790F13b470c44b5950311C8dd24f78E6",
                "-mine",
                "-nodiscover",
                "-ipcpath",
                "gethpipe.ipc",
                "-password",
                "C:\\Users\\Yann\\Documents\\pwd2.txt"
            ],
        }
    ]
}
```

### Midterm presentation



1. disco template
2. intro
3. problem statement
4. tldr slide
   1. cascade
   2. cascade and ethereum
   3. details
5. whats most important
6. what will be most important, what challenges remain