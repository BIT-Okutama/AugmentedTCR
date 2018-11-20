pragma solidity ^0.4.24;

import './SampleToken.sol';

contract MainTCR is SampleToken {

    struct Challenge {

        address challengeCreator;
        uint incentivePool;
        mapping (uint256 => mapping (address => bool)) tokenHolders;
        uint256 challengeExpiryDate;

    }

    struct Proposal { 

        address owner;
        string proposalDesc;
        bool isElected;
        uint256 stakeVal;
        uint256 proposalExpiryDate;
        uint256 challengeID;

    }

    uint256 private CURRENT_TOKEN_VAL = 10000;
    uint256 private MINIMUM_PROPOSAL_FEE = 3;
    uint256 private MINIMUM_CHALLENGE_STAKE = 3;

    mapping (uint256 => Challenge) challengers;
    mapping (uint256 => Candidate) candidates;

    uint256 challengerNonce;
    uint256 candidateNonce;

    constructor () public 
    SampleToken(msg.sender, 100000000) {}
    
    function challenge(uint256 _proposalID, uint256 _challengeStake) {
        require(_balances[msg.sender] >= MINIMUM_CHALLENGE_STAKE && 
                _challengeStake >= _balances[msg.sender]);

        challengers[++challengerNonce] = Challenger(
            {
                challengeCreator: msg.sender,
                incentivePool: _challengerStake
            }
        )
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
                proposalExpiryDate: getDateNow() + 2 //Adds 2 days from now.
            }
        );

        _balances[msg.sender]-= _amountToStake;
    }
    
    function getDateNow() public returns(uint256) {
        return 20181120; //I should use a library for getting dates.
    }


    function buyToken(uint32 quantity) public payable{
        require(msg.value >= quantity*CURRENT_TOKEN_VAL);
        _mint(msg.sender, quantity);
    }

    function changeTokenValue(uint256 value) public {
        CURRENT_TOKEN_VAL = value;
    }
} 