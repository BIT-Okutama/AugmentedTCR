pragma solidity ^0.4.24;

import "./EIP20.sol";
import "./ProxyFactory.sol";
import "./PLCRVoting.sol";
import "./Parameterizer.sol";
import "./Registry.sol";

contract AugmentedTCRFactory{
    
    ProxyFactory public proxyFactory;
    PLCRVoting public canonPLCR;
    Parameterizer public canonParam;
    Registry public canonRegistry;
    
    constructor () public {
        canonPLCR = new PLCRVoting();
        proxyFactory = new ProxyFactory();
        canonParam = new Parameterizer();
        canonRegistry = new Registry();
    }
    
    function createNewEnvironment(EIP20 _token, string _registryName, uint256[] _parameters) public returns(Registry reg, Parameterizer param, PLCRVoting plcr) {
        
        plcr = PLCRVoting(proxyFactory.createProxy(canonPLCR, ""));
        plcr.init(_token);
        
        param = Parameterizer(proxyFactory.createProxy(canonParam, ""));
        param.init(_token, plcr, _parameters);
        
        reg = Registry(proxyFactory.createProxy(canonRegistry, ""));
        reg.init(_token, _registryName, param, plcr);
        
        return (reg, param, plcr);
        
    }
    
    
    
}