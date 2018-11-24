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
        uint256 balance;
        uint256 applicationExpiry;
        uint256 exitTime;
        uint256 exitTimeExpiry;
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

    event NewContender(bytes32 indexed contenderHash, uint256 stake, uint256 applicationExpiry, string extra, address indexed issuer);
    
    function init(address _token, string _name, address _parameterizer, address _voting) public {
        require(_token != 0 && address(token) == 0);
        require(_voting != 0 && address(voting) == 0);
        require(_parameterizer != 0 && address(parameterizer) == 0);
        
        token = EIP20Interface(_token);
        voting = PLCRVoting(_voting);
        parameterizer = Parameterizer(_parameterizer);
        name = _name;
    }

    function compete(bytes32 _contenderHash, uint256 _amount, string _extra) external {
        require(_amount >= parameterizer.get("minDeposit") && 
                !isAlreadyChampion(_contenderHash) && 
                !existingContender(_contenderHash));

        contenders[_contenderHash] = Contender(
            {
                owner: msg.sender,
                applicationExpiry: block.timestamp.add(parameterizer.get("applyStageLen")),
                balance: _amount  
            }
        );
        require(token.transferFrom(contenders[_contenderHash].issuer, this, _amount));
        emit NewContender(_contenderHash, _amount, contenders[_contenderHash].applicationExpiry, _extra, msg.sender);
    }

    function isChampion(bytes32 _contenderHash) view public returns(bool){
        return contenders[_contenderHash].isChampion;
    }

    function existingContender(bytes32 _contenderHash) view public returns(bool){
        return contenders[_contenderHash].applicationExpiry > 0; 
    }

    
}