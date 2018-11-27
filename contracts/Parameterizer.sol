pragma solidity^0.4.11;

import "./PLCRVoting.sol";
import "./EIP20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Parameterizer {
    using SafeMath for uint;
    
    struct PChallenge {
        address pChallenger;
        uint256 pIncentivePool;
        bool pIsConcluded;
        uint256 pStake;
        uint256 pWonTokens;
        mapping(address => bool) pIncentiveClaims;
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
    mapping(uint256 => PChallenge) public challenges;
    mapping(bytes32 => Proposal) public proposals;
    
    EIP20Interface public token;
    PLCRVoting public voting;
    uint256 public PROCESSBY = 604800;
    
    event NewProposal(address indexed issuer, bytes32 proposalID, string name, uint value, uint deposit, uint appEndDate);
    event NewProposalChallenge(address indexed challenger, bytes32 indexed proposalID, uint challengeID, uint commitEndDate, uint revealEndDate);
    event PChallengerWon(bytes32 indexed proposalID, uint indexed challengeID, uint incentivePool, uint wonTokens);
    event PChallengerLost(bytes32 indexed proposalID, uint indexed challengeID, uint incentivePool, uint wonTokens);
    event ProposalPassed(bytes32 indexed proposalID, string name, uint value);
    event ProposalExpired(bytes32 indexed proposalID);
    event IncentiveClaimed(address indexed voter, uint indexed challengeID, uint incentive);
    
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

    function proposeAdjustment(string _paramName, uint _paramVal) public returns (bytes32) {
        uint minDeposit = get("pMinDeposit");
        bytes32 proposalID = keccak256(abi.encodePacked(_paramName, _paramVal));

        if (keccak256(abi.encodePacked(_paramName)) == keccak256(abi.encodePacked("dispensationPct")) ||
            keccak256(abi.encodePacked(_paramName)) == keccak256(abi.encodePacked("pDispensationPct"))) {
            require(_paramVal <= 100);
        }

        require(!exisitingProposal(proposalID)); 
        require(get(_paramName) != _paramVal); 

        Proposal storage proposal = proposals[proposalID];

        proposal.pIssuer = msg.sender;
        proposal.pChallengeID = 0; //i will check if omittable. 
        proposal.proposalExpiry = now.add(get("pApplyStageLen"));
        proposal.pDeposit = minDeposit;
        proposal.paramName = _paramName;
        proposal.processBy = now.add(get("pApplyStageLen")).add(get("pCommitStageLen")).add(get("pRevealStageLen")).add(PROCESSBY);
        proposal.paramVal = _paramVal;

        require(token.transferFrom(msg.sender, this, minDeposit));
        emit NewProposal(msg.sender, proposalID, _paramName, _paramVal, minDeposit, proposal.proposalExpiry);
        return proposalID;
    }

    function challengeProposal(bytes32 _proposalID) public returns (uint256) {
        Proposal storage proposal = proposals[_proposalID];
        uint minDeposit = proposal.pDeposit;

        require(exisitingProposal(_proposalID) && proposal.pChallengeID == 0);
        
        proposal.pChallengeID = voting.startPoll(
            get("pVoteQuorum"),
            get("pCommitStageLen"),
            get("pRevealStageLen")
        );

        PChallenge storage _challenge = challenges[proposal.pChallengeID];
        _challenge.pChallenger = msg.sender;
        _challenge.pIncentivePool = SafeMath.sub(100, get("pDispensationPct")).mul(minDeposit).div(100);
        _challenge.pStake = minDeposit;
        _challenge.pIsConcluded = false; //i will check if omittable. 
        _challenge.pWonTokens = 0; //i will check if omittable. 
    
        require(token.transferFrom(msg.sender, this, minDeposit));

        (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(proposal.pChallengeID);
        emit NewProposalChallenge(msg.sender, _proposalID, proposal.pChallengeID, commitEndDate, revealEndDate);
        return proposal.pChallengeID;
    }

    //i will review this 
    function processProposalResult(bytes32 _proposalID) public {
        Proposal storage proposal = proposals[_proposalID];

        if (proposalPassed(_proposalID)) {
            set(proposal.paramName, proposal.paramVal);
            emit ProposalPassed(_proposalID, proposal.paramName, proposal.paramVal);
            delete proposals[_proposalID];
            require(token.transfer(proposal.pIssuer, proposal.pDeposit));
        } 
        else if (challengeCanBeConcluded(_proposalID)) {
            concludeChallenge(_proposalID);
        } 
        else if (now > proposal.processBy) {
            emit ProposalExpired(_proposalID);
            delete proposals[_proposalID];
            require(token.transfer(proposal.pIssuer, proposal.pDeposit));
        }
        else revert();

        assert(get("dispensationPct") <= 100);
        assert(get("pDispensationPct") <= 100);
        now.add(get("pApplyStageLen")).add(get("pCommitStageLen")).add(get("pRevealStageLen")).add(PROCESSBY);

        delete proposals[_proposalID];
    }

    //Needs to be looped.
    function claimIncentive(uint256 _challengeID) public {
        PChallenge storage challenge = challenges[_challengeID];
        require(incentiveClaimStatus(_challengeID,msg.sender) == false);
        require(challenge.pIsConcluded == true);

        uint voterStake = voting.getNumPassingTokens(msg.sender, _challengeID);
        uint incentive = voterStake.mul(challenge.pIncentivePool).div(challenge.pWonTokens);

        challenge.pWonTokens -= voterStake;
        challenge.pIncentivePool -= incentive;

        challenge.pIncentiveClaims[msg.sender] = true;

        emit IncentiveClaimed(msg.sender, _challengeID, incentive);
        require(token.transfer(msg.sender, incentive));
    }

    function batchClaimIncentives(uint256[] _challengeIDs) public {
        for(uint256 i = 0; i < _challengeIDs.length; i++) claimIncentive(_challengeIDs[i]);
    }

    function viewVoterIncentive(address _voter, uint _challengeID) public view returns(uint256) {
        uint256 voterStake = voting.getNumPassingTokens(_voter, _challengeID);
        uint256 wonTokens = challenges[_challengeID].pWonTokens;
        uint256 incentivePool = challenges[_challengeID].pIncentivePool;

        return voterStake.mul(incentivePool).div(wonTokens);
    }

    function incentiveClaimStatus(uint256 _challengeID, address _voter) public view returns(bool) {
        return challenges[_challengeID].pIncentiveClaims[_voter];
    }

    function proposalPassed(bytes32 _proposalID) view public returns (bool) {
        Proposal memory proposal = proposals[_proposalID];

        return (now > proposal.proposalExpiry &&
                now < proposal.processBy && 
                proposal.pChallengeID == 0);
    }

    function challengeCanBeConcluded(bytes32 _proposalID) view public returns (bool) {
        Proposal memory proposal = proposals[_proposalID];

        return (proposal.pChallengeID > 0 &&
                challenges[proposal.pChallengeID].pIsConcluded == false &&
                voting.pollEnded(proposal.pChallengeID));
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

    //i will review this 
    function concludeChallenge(bytes32 _proposalID) private {
        Proposal memory proposal = proposals[_proposalID];
        PChallenge storage challenge = challenges[proposal.pChallengeID];

        uint incentive = calculateIncentive(proposal.pChallengeID);

        challenge.pWonTokens = voting.getTotalNumberOfTokensForWinningOption(proposal.pChallengeID);
        challenge.pIsConcluded = true;

        if (voting.isPassed(proposal.pChallengeID)) { 
            if(proposal.processBy > now) {
                set(proposal.paramName, proposal.paramVal);
            }
            emit PChallengerLost(_proposalID, proposal.pChallengeID, challenge.pIncentivePool, challenge.pWonTokens);
            require(token.transfer(proposal.pIssuer, incentive));
        }
        else {
            emit PChallengerWon(_proposalID, proposal.pChallengeID, challenge.pIncentivePool, challenge.pWonTokens);
            require(token.transfer(challenge.pChallenger, incentive));
        }
    }

    function calculateIncentive(uint256 _challengeID) public view returns (uint256) {
        if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) {
            return 2 * challenges[_challengeID].pStake;
        }

        return (2 * challenges[_challengeID].pStake) - challenges[_challengeID].pIncentivePool;
    }
}