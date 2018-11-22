pragma solidity ^0.4.24;


import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./EIP20Interface.sol";
import "./Parameterizer.sol";
import "./PLCRVoting.sol";

contract Registry {
    
    EIP20Interface public token;
    PLCRVoting public voting;
    Parameterizer public parameterizer;
    string public name;
    
    function init(address _token, string _name, address _parameterizer, address _voting) public {
        require(_token != 0 && address(token) == 0);
        require(_voting != 0 && address(voting) == 0);
        require(_parameterizer != 0 && address(parameterizer) == 0);
        
        token = EIP20Interface(_token);
        voting = PLCRVoting(_voting);
        parameterizer = Parameterizer(_parameterizer);
        name = _name;
    }
}