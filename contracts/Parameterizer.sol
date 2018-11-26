pragma solidity^0.4.11;

import "./PLCRVoting.sol";
import "./EIP20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Parameterizer {
    
    struct PChallenge {
        address pChallenger;
        uint256 pIncentivePool;
        bool pIsConcluded;
        uint256 pStake;
        uint256 wonTokens;
        mapping(address => bool) incentiveClaims;
    }

    struct Proposal {
        address pIssuer;
        uint256 pChallengeID;
        uint256 proposalExpiry;
        string paramDesc;
        uint256 paramVal;
        uint256 pDeposit;
        uint256 processBy;
    }
    
    mapping(bytes32 => uint) public params;
    mapping(uint256 => Challenge) public challenges;
    mapping(uint256 => ParamProposal) public proposals;
    
    EIP20Interface public token;
    PLCRVoting public voting;
    
    event _ReparameterizationProposal(string name, uint value, bytes32 propID, uint deposit, uint appEndDate, address indexed proposer);
    event _NewChallenge(bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate, address indexed challenger);
    event _ProposalAccepted(bytes32 indexed propID, string name, uint value);
    event _ProposalExpired(bytes32 indexed propID);
    event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
    event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint rewardPool, uint totalTokens);
    event _RewardClaimed(uint indexed challengeID, uint reward, address indexed voter);
    
    function init(address _token, address _plcr, uint256[] _parameters) public {
        
        require(_token != 0 && address(token) == 0);
        require(_plcr != 0 && address(voting) == 0);

        token = EIP20Interface(_token);
        voting = PLCRVoting(_plcr);
        
        set("minDeposit", _parameters[0]);
        set("pMinDeposit", _parameters[1]);
        set("applyStageLen", _parameters[2]);
        set("pApplyStageLen", _parameters[3]);
        set("commitStageLen", _parameters[4]);
        set("pCommitStageLen", _parameters[5]);
        set("revealStageLen", _parameters[6]);
        set("pRevealStageLen", _parameters[7]);
        set("dispensationPct", _parameters[8]);
        set("pDispensationPct", _parameters[9]);
        set("voteQuorum", _parameters[10]);
        set("pVoteQuorum", _parameters[11]);
        set("exitTimeDelay", _parameters[12]);
        set("exitPeriodLen", _parameters[13]);
        
    }

    
    
    function set(string _name, uint256 _value) public {
        params[keccak256(abi.encodePacked(_name))] = _value;
    }

    function get(string _name) public view returns(uint256 value){
        return params[keccak256(abi.encodePacked(_name))];
    }
}