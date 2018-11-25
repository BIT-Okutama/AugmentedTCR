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
        uint256 stake;
        uint256 applicationExpiry;
    }

    struct Challenge {
        address challenger;
        uint256 rewardPool;
        bool isConcluded;
        uint256 stake;
        uint256 totalTokens;
        mapping(address => bool) rewardClaims;
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
    event NewChallenge(address indexed challenger, bytes32 indexed contenderHash, uint challengeID, string evidence, uint commitEnd, uint revealEnd);
    event NewChampion(bytes32 indexed contenderHash);
    event ChallengerLost(uint256 challengeID, bytes32 indexed contenderHash, uint256 rewardPool, uint256 totalTokens);
    event ChallengerWon(uint256 challengeID, bytes32 indexed contenderHash, uint256 rewardPool, uint256 totalTokens);
    event RewardClaimed(address indexed voter, uint256 indexed challengeID, uint256 reward);


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
        contender.stake = _amount;
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

        require(contender.owner == msg.sender &&
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
                (contender.challengeID == 0 || challenges[contender.challengeID].resolved));

        uint256 minDeposit = parameterizer.get("minDeposit");

        if(contender.deposit < minDeposit) {
            backtrackState(_contenderHash);
            emit TouchedAndRemoved(_contenderHash);
            return 0;
        }

        uint256 pollID = voting.startPoll(
            parameterizer.get("voteQuorum"),
            parameterizer.get("commitStageLen"),
            parameterizer.get("revealStageLen")
        );


        uint256 oneHundred = 100; 
        Challenge storage challenge = challenges[pollID];
        challenge.challenger = msg.sender;
        challenge.rewardPool = ((oneHundred.sub(parameterizer.get("dispensationPct"))).mul(minDeposit)).div(100);
        challenge.stake = minDeposit;
        challenge.totalTokens = 0;
        
        contender.challengeID = pollID;
        contender.deposit -= minDeposit;

        require(token.transferFrom(msg.sender, this, minDeposit));
        emit NewChallenge(msg.sender, _contenderHash, pollID, _evidence,  commitEnd, revealEnd);
    }

    //Needs to be looped
    function updateStatus(bytes32 _contenderHash) public {
        if(canBecomeChampion(_contenderHash)) crownAsChampion(_contenderHash);
        else if(challengeCanBeConcluded(_contenderHash)) concludeChallange(_contenderHash);
        else revert();
    }

    
    //Needs to be looped
    function claimReward(uint _challengeID) public {
        Challange storage challenge = challenges[_challengeID];

        require(challenge.rewardClaims[msg.sender] == false &&
                challenge.isConcluded == true);

        uint256 voterStake = voting.getNumPassingTokens(msg.sender, _challengeID);
        uint256 reward = voterStake.mul(challenge.rewardPool).div(challenge.totalTokens);
        
        challenge.totalTokens -= voterStake;
        challenge.rewardPool -= reward;

        challenge.rewardClaims[msg.sender] = true;
        require(token.transfer(msg.sender, reward));

        emit RewardClaimed(msg.sender, _challengeID, reward);

    }

    function viewVoterReward(address _voter, uint _challengeID) public view returns(uint256) {
        uint256 voterStake = voting.getNumPassingTokens(_voter, _challengeID);
        uint256 total = challenges[_challengeID].totalTokens;
        uint256 rewardPool = challenged[_challengeID].rewardPool;

        return voterStake.mul(rewardPool).div(total);
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
        else false;
    }

    function concludeChallenge(bytes32 _contenderHash) private {
        uint256 challengeID = contenders[_contenderHash].challengeID;
        Challenge storage challenge = challenges[challengeID];
        uint256 reward = calculateReward(challengeID);
        
        challenge.isConcluded = true;

        challenge.totalTokens = voting.getTotalNumberOfTokensForWinnningOption(challengeID);

        if(voting.isPassed(challengeID)){
            crownAsChampion(_contenderHash);
            contenders[_contenderHash].deposit += reward;
            emit ChallengerLost(challengeID, _contenderHash, challenge.rewardPool, challenge.totalTokens);
        }
        else {
            backtrackState(_contenderHash);
            require(token.transfer(challenges[challengeID].challenger, reward));
            emit ChallengerWon(challengeID, _contenderHash, challenge.rewardPool, challenge.totalTokens);
        }
    }

    function calculateReward(uint _challengeID) private view returns(uint256) {
        
        if(voting.getTotalNumberOfTokensForWinnningOption(_challengeID) == 0) 
            return 2 * challenges[_challengeID].stake;
        else
            return (2 * challenges[_challengeID].stake) - challenges[_challengeID].rewardPool;
    }

    function backtrackState(bytes32 _contenderHash) private {

        Contender storage contender = contenders[_contenderHash];
        bool contenderState = contender.isChampion;
        if(contender.deposit > 0) require(token.transfer(contender.issuer, contender.deposit));
        
        if(contenderState) emit _ChampionRemoved(_contenderHash);
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