pragma solidity ^0.4.24;


import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./EIP20Interface.sol";
import "./Parameterizer.sol";
import "./PLCRVoting.sol";

contract Registry {
    using SafeMath for uint;

    struct Contender {
        address issuer;
        bool isChampion;
        uint challengeID;
        uint256 deposit;
        uint256 applicationExpiry;
    }

    struct Challenge {
        address challenger;
        uint256 incentivePool;
        bool isConcluded;
        uint256 stake;
        uint256 wonTokens;
        mapping(address => bool) incentiveClaims;
    }

    mapping(bytes32 => Contender) public contenders;
    mapping(uint256 => Challenge) public challenges;

    EIP20Interface public token;
    PLCRVoting public voting;
    Parameterizer public parameterizer;
    string public name;

    event NewContender(address indexed issuer, bytes32 indexed contenderHash, uint256 stake, uint256 applicationExpiry, string extra);
    event Deposit(address indexed issuer, bytes32 indexed contenderHash, uint256 depositAmount, uint256 total);
    event Withdrawal(address indexed issuer, bytes32 indexed contenderHash, uint256 withdrawAmount, uint256 total);
    event ChampionRemoved(bytes32 indexed contenderHash);
    event ContenderRemoved(bytes32 indexed contenderHash);
    event NewChallenge(address indexed challenger, bytes32 indexed contenderHash, uint256 challengeID, string evidence, uint256 commitEnd, uint256 revealEnd);
    event NewChampion(bytes32 indexed contenderHash);
    event ChallengerLost(uint256 challengeID, bytes32 indexed contenderHash, uint256 incentivePoo, uint256 wonTokens);
    event ChallengerWon(uint256 challengeID, bytes32 indexed contenderHash, uint256 incentivePoo, uint256 wonTokens);
    event IncentiveClaimed(address indexed voter, uint256 indexed challengeID, uint256 reward);
    event TouchedAndRemoved(bytes32 indexed contenderHash);


    function init(address _token, string _name, address _parameterizer, address _voting) public {
        require((_token != 0 && address(token) == 0) &&
                (_voting != 0 && address(voting) == 0) &&
                (_parameterizer != 0 && address(parameterizer) == 0));
        
        token = EIP20Interface(_token);
        voting = PLCRVoting(_voting);
        parameterizer = Parameterizer(_parameterizer);
        name = _name;
    }

    //Pending changes: PLCRVoting -> voteOption to boolean
    //To be reviewed:  claimReward(), reward can be viewed only after claiming?
    
    //Contender Functions

    function register(bytes32 _contenderHash, uint256 _amount, string _extra) external {
        require(_amount >= parameterizer.get("minDeposit") && 
                !isChampion(_contenderHash) && 
                !existingContender(_contenderHash));

        Contender storage contender = contenders[_contenderHash];
        contender.issuer = msg.sender;
        contender.deposit = _amount;
        contender.applicationExpiry = block.timestamp.add(parameterizer.get("applyStageLen"));
        
        require(token.transferFrom(contenders[_contenderHash].issuer, this, _amount));
        emit NewContender(msg.sender, _contenderHash, _amount, contenders[_contenderHash].applicationExpiry, _extra);
    }

    function deposit(bytes32 _contenderHash, uint256 _amount) external {
        Contender storage contender = contenders[_contenderHash];
        require(contender.issuer == msg.sender && 
                token.transferFrom(msg.sender, this, _amount));
        contender.deposit += _amount;

        emit Deposit(msg.sender, _contenderHash, _amount, contender.deposit);
    }

    function withdraw(bytes32 _contenderHash, uint256 _amount) external {
        Contender storage contender = contenders[_contenderHash];

        require(contender.issuer == msg.sender &&
                contender.deposit >= _amount  &&
                contender.deposit - _amount >= parameterizer.get("minDeposit") &&
                token.transfer(msg.sender, _amount));

        contender.deposit -= _amount;
        emit Withdrawal(msg.sender, _contenderHash, _amount, contender.deposit);
    }

    //Challenger Functions

    function challenge(bytes32 _contenderHash, string _evidence) external returns(uint256 challengeID){
        Contender storage contender = contenders[_contenderHash];
        
        
        require((existingContender(_contenderHash) || contender.isChampion) &&
                (contender.challengeID == 0 || challenges[contender.challengeID].isConcluded));

        uint256 minDeposit = parameterizer.get("minDeposit");

        if(contender.deposit < minDeposit) {
            backtrackState(_contenderHash);
            emit TouchedAndRemoved(_contenderHash);
            return 0;
        }

        contender.challengeID = voting.startPoll(
            parameterizer.get("voteQuorum"),
            parameterizer.get("commitStageLen"),
            parameterizer.get("revealStageLen")
        );

        
        Challenge storage _challenge = challenges[contender.challengeID];
        _challenge.challenger = msg.sender;
        _challenge.incentivePool = SafeMath.sub(100, parameterizer.get("dispensationPct")).mul(minDeposit).div(100);
        _challenge.stake = minDeposit;
        _challenge.wonTokens = 0;
        
        contender.deposit -= minDeposit;
        (uint commitEndDate, uint revealEndDate,,,) = voting.pollMap(contender.challengeID);
        
        require(token.transferFrom(msg.sender, this, minDeposit));
        emit NewChallenge(msg.sender, _contenderHash, contender.challengeID, _evidence,  commitEndDate, revealEndDate);
    }

    function updateStatus(bytes32 _contenderHash) public {
        if(canBecomeChampion(_contenderHash)) crownAsChampion(_contenderHash);
        else if(challengeCanBeConcluded(_contenderHash)) concludeChallenge(_contenderHash);
        else revert();
    }

    function batchUpdateStatuses(bytes32[] _contenderHashes) public {
        for(uint256 i = 0; i < _contenderHashes.length; i++) updateStatus(_contenderHashes[i]);
    }

    function claimIncentive(uint _challengeID) public {
        Challenge storage _challenge = challenges[_challengeID];

        require(incentiveClaimStatus(_challengeID, msg.sender) == false &&
                _challenge.isConcluded == true);

        uint256 voterStake = voting.getNumPassingTokens(msg.sender, _challengeID);
        uint256 reward = voterStake.mul(_challenge.incentivePool).div(_challenge.wonTokens);
        
        _challenge.wonTokens -= voterStake;
        _challenge.incentivePool -= reward;

        _challenge.incentiveClaims[msg.sender] = true;
        require(token.transfer(msg.sender, reward));

        emit IncentiveClaimed(msg.sender, _challengeID, reward);
    }

    function batchClaimIncentives(uint256[] _challengeIDs) public {
        for(uint256 i = 0; i < _challengeIDs.length; i++) claimIncentive(_challengeIDs[i]);
    }

    function viewVoterIncentive(address _voter, uint _challengeID) public view returns(uint256) {
        uint256 voterStake = voting.getNumPassingTokens(_voter, _challengeID);
        uint256 total = challenges[_challengeID].wonTokens;
        uint256 incentivePool = challenges[_challengeID].incentivePool;

        return voterStake.mul(incentivePool).div(total);
    }

    function incentiveClaimStatus(uint256 _challengeID, address _voter) public view returns(bool) {
        return challenges[_challengeID].incentiveClaims[_voter];
    }

    function canBecomeChampion(bytes32 _contenderHash) view public returns(bool){
        uint256 challengeID = contenders[_contenderHash].challengeID;

        if ((challengeID == 0 || challenges[challengeID].isConcluded == true) &&
            existingContender(_contenderHash) &&
            contenders[_contenderHash].applicationExpiry < now &&
            !isChampion(_contenderHash)) return true;
        else return false;
    }

    function crownAsChampion(bytes32 _contenderHash) private {
        Contender storage contender = contenders[_contenderHash];

        if(!contender.isChampion) {
            contender.isChampion = true;
            emit NewChampion(_contenderHash);
        }
    }

    function challengeCanBeConcluded(bytes32 _contenderHash) view public returns(bool) {
        uint256 challengeID = contenders[_contenderHash].challengeID;
        if(challengeID > 0 && !challenges[challengeID].isConcluded) return voting.pollEnded(challengeID);
        else return false;
    }

    function concludeChallenge(bytes32 _contenderHash) private {
        uint256 challengeID = contenders[_contenderHash].challengeID;
        Challenge storage _challenge = challenges[challengeID];
        uint256 reward = calculateIncentive(challengeID);
        
        _challenge.isConcluded = true;

        _challenge.wonTokens = voting.getTotalNumberOfTokensForWinningOption(challengeID);

        if(voting.isPassed(challengeID)){
            crownAsChampion(_contenderHash);
            contenders[_contenderHash].deposit += reward;
            emit ChallengerLost(challengeID, _contenderHash, _challenge.incentivePool, _challenge.wonTokens);
        }
        else {
            backtrackState(_contenderHash);
            require(token.transfer(challenges[challengeID].challenger, reward));
            emit ChallengerWon(challengeID, _contenderHash, _challenge.incentivePool, _challenge.wonTokens);
        }
    }

    function calculateIncentive(uint _challengeID) private view returns(uint256) {
        
        if(voting.getTotalNumberOfTokensForWinningOption(_challengeID) == 0) 
            return 2 * challenges[_challengeID].stake;
        else
            return (2 * challenges[_challengeID].stake) - challenges[_challengeID].incentivePool;
    }

    function backtrackState(bytes32 _contenderHash) private {

        Contender storage contender = contenders[_contenderHash];
        bool contenderState = contender.isChampion;
        if(contender.deposit > 0) require(token.transfer(contender.issuer, contender.deposit));
        
        if(contenderState) emit ChampionRemoved(_contenderHash);
        else emit ContenderRemoved(_contenderHash);

        delete contenders[_contenderHash];
    }

    function isChampion(bytes32 _contenderHash) view public returns(bool){
        return contenders[_contenderHash].isChampion;
    }

    function existingContender(bytes32 _contenderHash) view public returns(bool exists){
        return contenders[_contenderHash].applicationExpiry > 0; 
    }

}