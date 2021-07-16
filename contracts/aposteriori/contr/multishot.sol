// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title Multishot
 * @dev Implements cascade a posteriori consensus
 */
contract Multishot {

    event Decided(address indexed txOrigin, uint txNonce, uint256 decision);

    struct Decision {
        // If you can limit the length to a certain number of bytes, 
        // always use one of bytes1 to bytes32 because they are much cheaper
        uint256 decision;
        uint weight_received;
        uint256 currentMax;
        
        mapping(address => bool) proposed;
        mapping(uint256 => uint) total_ack_weight;
    }

    mapping(address => uint) public validatorStake;
    uint public majorityStake;
    mapping(address => mapping(uint => Decision)) public decisions;
    
    
    /** 
     * @dev Create a new multishot.
     * @param validators addresses allowed to propose tx hash value
     * @param stake corresponding stake
     */
    constructor(address[] memory validators, uint[] memory stake) {
        
        uint tmp = 0;

        for (uint i = 0; i < validators.length; i++) {
            
            validatorStake[validators[i]] = stake[i];
            tmp += stake[i];
        }
        
        majorityStake = (uint(4) * tmp) / uint(5);
    }
    
    /** 
     * @dev 
     * @param txOrigin public address of tx sender
     * @param nonce nonce of tx
     */
    function read(address txOrigin, uint nonce) public view
            returns (uint txHash){
        
        Decision storage dec = decisions[txOrigin][nonce];
        
        // Check if decision created
        if (dec.decision != 0) {
            return dec.decision;
        } else {
            return 0;
        }
    }


    /**
     * @dev 
     */
    function propose(address txOrigin, uint nonce, uint txHash) public {

        Decision storage dec = decisions[txOrigin][nonce];

        // Create new decision if necessary
        //if (dec == 0) {
        //    dec = Decision({}); // Create new decision struct, FIXME needed ?
        //}

        require(!dec.proposed[msg.sender], "You already proposed.");
        require(dec.decision == 0, "Consensus already delivered.");
        require(validatorStake[msg.sender] > 0, "You need stake to be able to propose a value.");


        dec.total_ack_weight[txHash] += validatorStake[msg.sender]; 
        dec.weight_received += validatorStake[msg.sender];

        // Adapt currentMax if necessary
        if (dec.total_ack_weight[dec.currentMax] < dec.total_ack_weight[txHash]) {
            dec.currentMax = txHash;
        }

        // Check if we can decide on value
        // Decision can be reached for a DoubleSpend with following constraints
        // 1) more than 4/5 of stake received
        // 2) decide on max value

        if (dec.weight_received > majorityStake) {
            // Decision can be made
            dec.decision = dec.currentMax;

            // Emit event, such that processes don't have to query themselves
            emit Decided(txOrigin, nonce, dec.decision);
        }      

        // Save new decision object & mark sender as having already proposed
        dec.proposed[msg.sender] = true;
    }  

}
