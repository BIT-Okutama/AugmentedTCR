pragma solidity ^0.4.24;

import "./PLCRFactory.sol";
import "./ParameterizerFactory.sol";
import "./RegistryFactory.sol";

contract Orchestrator {
    
    PLCRFactory plcrFactory;
    mapping (address => ParameterizerFactory) private paramsFactories;
    mapping (address => RegistryFactory) private regFactories;

    //This contract only needs one instance of PLCRFactory
    constructor() public {
        plcrFactory = new PLCRFactory();
    }
    
    function buildGoverningEnvironment() public {
        paramFactories[msg.sender] = new ParameterizerFactory(plcrFactory);
    }
    
    function buildTRCEnvironment() public {
        regFactories[msg.sender] = new RegistryFactory(paramFactory);
    }
}
