pragma solidity ^0.4.24;

import './SampleToken.sol';

contract MainTCR is SampleToken {

    struct Challenge {

        address challengeCreator;
        uint incentivePool;
        mapping (uint256 => mapping (address => bool)) tokenHolders;
        string challengeExpiryDate;

    }

    struct Proposal { 

        address owner;
        string proposalDesc;
        bool isElected;
        uint256 stakeVal;
        string proposalExpiryDate;
        uint256 challengeID;

    }

    uint256 private CURRENT_TOKEN_VAL = 10000;
    uint256 private MINIMUM_PROPOSAL_FEE = 3;

    mapping (uint256 => Challenge) challengers;
    mapping (uint256 => Candidate) candidates;

    uint256 challengerNonce;
    uint256 candidateNonce;

    constructor () public 
    SampleToken(msg.sender, 100000000) {}
    
    function challenge(uint256 _proposalID) {

    }


    function applyProposal(uint256 _amountToStake, string _proposalDesc) public {
        require(_balances[msg.sender] >= MINIMUM_PROPOSAL_FEE && 
                _amountToStake >= _balances[msg.sender]);

        candidates[++candidateNonce] = Candidate(
            {
                owner: msg.sender,
                proposalDescription: _proposalDesc,
                isElected: false,
                stakeVal: _amountToStake,
                proposalExpiryDate: "the date is here"
            }
        );

        _balances[msg.sender]-= _amountToStake;
    }
    

    function buyToken(uint32 quantity) public payable{
        require(msg.value >= quantity*CURRENT_TOKEN_VAL);
        _mint(msg.sender, quantity);
    }

    function changeTokenValue(uint256 value) public {
        CURRENT_TOKEN_VAL = value;
    }
} 