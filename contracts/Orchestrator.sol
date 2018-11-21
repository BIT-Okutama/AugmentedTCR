pragma ^0.4.20;

import './GenerateToken.sol';

contract Orchestrator {

    mapping(address => GenerateToken) generatedTokens;

    function createNewToken(string _name, string _symbol, string _decimals, address owner, uint256 totalSupply) public {
        
    }

}