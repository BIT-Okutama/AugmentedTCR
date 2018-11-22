pragma solidity^0.4.11;

import "./PLCRVoting.sol";
import "./EIP20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Parameterizer {
    
    
    mapping(bytes32 => uint) public params;
    
    EIP20Interface public token;
    PLCRVoting public voting;
    
    
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
}