package aposteriori

import (
	"log"
	"math/big"
	"strings"
	"time"

	contract "github.com/yannvon/cascadeth/contracts/aposteriori/contr"

	"github.com/yannvon/cascadeth/accounts/abi/bind"
	"github.com/yannvon/cascadeth/common"
	"github.com/yannvon/cascadeth/ethclient"
)

const Key1 = `{"address":"1de5fd683d94281f444eef6d27d4ed28c74296ee","crypto":{"cipher":"aes-128-ctr","ciphertext":"db6468bc882cdebc0e91390f1ca89ec5fd01f58588e4b59e242d165fec651e70","cipherparams":{"iv":"2eb45747c43554e62d190caeacde369a"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"7fb4c263ac42fed18f70ac956bf4145359bc9818809d4d7830df24e84ea190ce"},"mac":"d6798382908a7779eeffb79caaa6d9b236175b677cdc561c331b0fb8f3930425"},"id":"7cff8b67-840b-440d-aed7-ba83d64345ba","version":3}`
const Key2 = `{"address":"8f2fefcec9c4990beecbc024fb766f1c4c0fba13","crypto":{"cipher":"aes-128-ctr","ciphertext":"306ab023028a65eaaf0d22567854e46a578c136db2b079b4f3ef16b79a8fa9fd","cipherparams":{"iv":"ec4e1202d7f961365071b586eb01c68d"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"868c85b762aa0c29fcec8693017c421e9d78a68282db7247aad1213f37fafa9c"},"mac":"9ba6185bbacd8de6b6b0e0e476eb8189f4315961920c4adee678010e177fcf16"},"id":"34f829a9-b680-42cf-9d85-01f1923294b6","version":3}`
const Key3 = `{"address":"28e7caf4e28206df61cb1b944ca605161fcd5748","crypto":{"cipher":"aes-128-ctr","ciphertext":"30a69d8de0e2d3e3dd41c94b7115b5e2da6c67d0c5f901f2818cf8ecdf526d83","cipherparams":{"iv":"8549263bed0a8260e9315db68b3583fc"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"9a1fbba59f1dc83dc8f695055cc60b789331d3afec0a1c78666e005ec76e2537"},"mac":"2ada6c4f978f1502945c9b16074c2135a7d0a7c4eb28488ff0dc72466429bdf0"},"id":"0adf3199-8608-442a-8252-ad449d021554","version":3}`
const Key4 = `{"address":"7e8dcd2e30485fd4db1f7c6fa1c4fc875a45f160","crypto":{"cipher":"aes-128-ctr","ciphertext":"955e0f9a35656359f86c218d87f4d19a80a85c8e1f6d337559018efe02e91565","cipherparams":{"iv":"1440936dd6f1fd4027a1d1ed9cf1519d"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"3b435081a54872e804b4538af96a89aed7962dbd6b06a01f7f14022d2294eabb"},"mac":"969d47895d3bed9352fab33360bf7dee48fc867be3ec445c1e6b5c93949c8d28"},"id":"8996a081-6d52-4cd5-8756-bae51b69c4ed","version":3}`
const Key5 = `{"address":"560b52b1a82fc8fd3715345a5ee4080502d82f2d","crypto":{"cipher":"aes-128-ctr","ciphertext":"bfd84ed264cdddeb2b7823ee15c7a6d31804a746e57428d177ae76cec8f787b7","cipherparams":{"iv":"af6000007a87f1d31a3837ec6cb5899d"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"fa812a1c74d17e374d98a6bafad217516821640388c432677a000a92abe2ca8a"},"mac":"4151778b122f59fc68c161944787d369ff0286e38be65ffeb7423303d33c6b72"},"id":"5084e7ab-800a-43e0-bbaf-9c7503a840a5","version":3}`

func main() {
	// connect to an ethereum node  hosted by infura
	blockchain, err := ethclient.Dial("https://rinkeby.infura.io/v3/f9b32e6b21e740eab75d12e2e0318f3d")
	chainID := big.NewInt(4)

	if err != nil {
		log.Fatalf("Unable to connect to network:%v\n", err)
	}

	// Get credentials for the account to charge for contract deployments
	auth1, err := bind.NewTransactorWithChainID(strings.NewReader(Key1), "", chainID)
	if err != nil {
		log.Fatalf("Failed to create authorized transactor: %v", err)
	}

	auth2, err := bind.NewTransactorWithChainID(strings.NewReader(Key2), "", chainID)
	if err != nil {
		log.Fatalf("Failed to create authorized transactor: %v", err)
	}
	auth3, err := bind.NewTransactorWithChainID(strings.NewReader(Key3), "", chainID)
	if err != nil {
		log.Fatalf("Failed to create authorized transactor: %v", err)
	}
	auth4, err := bind.NewTransactorWithChainID(strings.NewReader(Key4), "", chainID)
	if err != nil {
		log.Fatalf("Failed to create authorized transactor: %v", err)
	}

	auth5, err := bind.NewTransactorWithChainID(strings.NewReader(Key5), "", chainID)
	if err != nil {
		log.Fatalf("Failed to create authorized transactor: %v", err)
	}

	// Access contract
	addr := common.HexToAddress("0x5a79615D346bb6924ae8CF3B665380ba3C4FBFc8")
	contract, err := contract.NewMultishot(addr, blockchain)
	if err != nil {
		log.Fatalf("Unable to bind to deployed instance of contract:%v\n", addr)
	}

	// Define consensus instance
	txOrigin := auth1.From
	nonce := big.NewInt(1)
	proposal := big.NewInt(42)

	// Print start state
	out, _ := contract.Read(nil, auth1.From, nonce)
	println(out.String())

	// 4 out of 5 propose

	_, err = contract.Propose(auth1, txOrigin, nonce, proposal)
	if err != nil {
		log.Fatalf("%v", err)
	}

	_, err = contract.Propose(auth2, txOrigin, nonce, proposal)
	if err != nil {
		log.Fatalf("%v", err)
	}
	_, err = contract.Propose(auth3, txOrigin, nonce, proposal)
	if err != nil {
		log.Fatalf("%v", err)
	}
	_, err = contract.Propose(auth4, txOrigin, nonce, proposal)
	if err != nil {
		log.Fatalf("%v", err)
	}
	out, _ = contract.Read(nil, txOrigin, nonce)
	println(out.String())

	// Final propose needed to decide
	auth5.GasLimit = 2000000
	_, err = contract.Propose(auth5, txOrigin, nonce, proposal)
	if err != nil {
		log.Fatalf("%v", err)
	}

	println("Sleep 20 seconds to see effect.")
	time.Sleep(20 * time.Second)
	out, _ = contract.Read(nil, txOrigin, nonce)
	println(out.String())

}
