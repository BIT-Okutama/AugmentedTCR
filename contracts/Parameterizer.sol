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
        uint256 pWonTokens;
        mapping(address => bool) incentiveClaims;
    }

    struct Proposal {
        address pIssuer;
        uint256 pChallengeID;
        uint256 proposalExpiry;
        string paramName;
        uint256 paramVal;
        uint256 pDeposit;
        uint256 processBy;
    }
    
    mapping(bytes32 => uint) public params;
    mapping(uint256 => Challenge) public challenges;
    mapping(uint256 => ParamProposal) public proposals;
    
    EIP20Interface public token;
    PLCRVoting public voting;
    uint256 public PROCESSBY = 604800;
    
    event NewProposal(address indexed issuer, bytes32 propID, string name, uint value, uint deposit, uint appEndDate);
    event NewProposalChallenge(address indexed challenger, bytes32 indexed propID, uint challengeID, uint commitEndDate, uint revealEndDate);
    event ProposalPassed(bytes32 indexed propID, string name, uint value);
    event _ProposalExpired(bytes32 indexed propID);
    event _ChallengeSucceeded(bytes32 indexed propID, uint indexed challengeID, uint incentivePool, uint wonTokens);
    event _ChallengeFailed(bytes32 indexed propID, uint indexed challengeID, uint incentivePool, uint wonTokens);
    event _RewardClaimed( address indexed voter, uint indexed challengeID, uint incentive);
    
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

    function proposeAdjustment(string _paramName, uint _value) public returns (bytes32) {
        uint minDeposit = get("pMinDeposit");
        bytes32 propID = keccak256(abi.encodePacked(_name, _value));

        if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("dispensationPct")) ||
            keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("pDispensationPct"))) {
            require(_value <= 100);
        }

        require(!exisitingProposal(propID)); 
        require(get(_name) != _value); 

        Proposal storage proposal = proposals[propID];

        proposal.issuer = msg.sender;
        proposal.challengeID = 0; //i will check this next time. 
        proposal.proposalExpiry = now.add(get("pApplyStageLen"));
        proposal.deposit = minDeposit;
        proposal.paramName = _name;
        proposal.processBy = now.add(get("pApplyStageLen")).add(get("pCommitStageLen")).add(get("pRevealStageLen")).add(PROCESSBY);
        proposal.paramVal = _value;

        require(token.transferFrom(msg.sender, this, minDeposit));
        emit NewProposal(msg.sender, propID, _name, _value, minDeposit, proposal.appExpiry);
        return propID;
    }

    function challengeProposal(bytes32 _proposalID) public returns (uint256) {
        ParamProposal memory prop = proposals[_proposalID];
        uint minDeposit = prop.deposit;

        require(exisitingProposal(_proposalID) && prop.challengeID == 0);
        
        proposals[_proposalID].challengeID = voting.startPoll(
            get("pVoteQuorum"),
            get("pCommitStageLen"),
            get("pRevealStageLen")
        );

        PChallenge challenge = pChallenges[pollID];
        challenge.pChallenger = msg.sender;
        challenge.pIncentivePool = SafeMath.sub(100, get("pDispensationPct")).mul(deposit).div(100);
        challenge.pStake = minDeposit;
        challenge.pIsConcluded = false; //i will check this next time. 
        challenge.pWonTokens = 0; //i will check this next time.
    
        require(token.transferFrom(msg.sender, this, minDeposit));

        (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(pollID);
        emit NewProposalChallenge(msg.sender, _propID, pollID, commitEndDate, revealEndDate);
        return pollID;
    }

    function processProposal(bytes32 _proposalID) public {
        Proposal storage proposal = proposals[_propID];

        if (proposalPassed(_propID)) {
            set(proposal.paramName, proposal.paramName);
            emit ProposalPassed(_proposalID, proposal.paramName, proposal.paramVal);
            delete proposals[_propID];
            require(token.transfer(proposal.pIssuer, proposal.pDeposit));
        } 
        else if (challengeCanBeConcluded(_proposalID)) {
            concludeChallenge(_proposalID);
        } 
        else if (now > proposal.processBy) {
            emit _ProposalExpired(_proposalID);
            delete proposals[_proposalID];
            require(token.transfer(proposal.pIssuer, proposal.pDeposit));
        }
        else revert();

        assert(get("dispensationPct") <= 100);
        assert(get("pDispensationPct") <= 100);
        now.add(get("pApplyStageLen")).add(get("pCommitStageLen")).add(get("pRevealStageLen")).add(PROCESSBY);

        delete proposals[_propID];
    }

    function proposalPassed(bytes32 _proposalID) view public returns (bool) {
        Proposal memory proposal = proposals[_propID];

        return (now > proposal.proposalExpiry &&
                now < proposal.processBy && 
                proposal.pChallengeID == 0);
    }

    function challengeCanBeConcluded(bytes32 _proposalID) view public returns (bool) {
        Proposal memory proposal = proposals[_propID];

        return (proposal.pChallengeID > 0 &&
                challenges[proposal.challengeID].pIsConcluded == false &&
                voting.pollEnded(proposal.pChallengeID));
    }

    function concludeChallenge(bytes32 _proposalID) private {
        //Continue Here...
    }
    
    
    function exisitingProposal(bytes32 _propID) view public returns(bool) {
        return proposals[_propID].processBy > 0;
    }
    
    function set(string _name, uint256 _value) public {
        params[keccak256(abi.encodePacked(_name))] = _value;
    }

    function get(string _name) public view returns(uint256 value){
        return params[keccak256(abi.encodePacked(_name))];
    }
}