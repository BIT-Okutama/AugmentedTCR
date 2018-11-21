pragma solidity ^0.4.24;

import "./ParameterizerFactory.sol";

contract RegistryFactory {
    
    ParameterizerFactory paramFactory;
    
    constructor(ParameterizerFactory _paramFactory) public {
        paramFactory = _paramFactory;
    }
}