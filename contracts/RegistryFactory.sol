pragma solidity ^0.4.24;

import "./EIP20.sol";
import "./ParameterizerFactory.sol";
import "./Registry.sol";
import "./PLCRVoting.sol";
import "./Parameterizer.sol";


contract RegistryFactory {
    
    ParameterizerFactory paramFactory;
    ProxyFactory public proxyFactory;
    Registry public canonRegistry;
    
    constructor(ParameterizerFactory _paramFactory) public {
        paramFactory = _paramFactory;
        proxyFactory = paramFactory.proxyFactory();
        canonRegistry = new Registry();
    }
    
    event onCreateRegistry(address origin, Parameterizer parameterizer, Registry registry, EIP20 token, PLCRVoting plcr);
 
    function createNewRegistry(EIP20 _token, string _registryName, uint256[] _parameters) public returns(Registry) {
        
        Parameterizer parameterizer = paramFactory.createNewParameterizer(_token, _parameters);
        PLCRVoting plcr = parameterizer.voting();
        
        Registry registry = Registry(proxyFactory.createProxy(canonRegistry, ""));
        registry.init(_token, _registryName, parameterizer, plcr);
        
        emit onCreateRegistry(msg.sender, parameterizer, registry, _token, plcr);
    }
    
    function createNewRegistryWithToken(uint256 _supply, string _tokenName, uint8 _decimals, string _symbol, uint256[] _parameters, string _registryName) public returns(Registry) {
        
        Parameterizer parameterizer = paramFactory.createNewParameterizerWithToken(_supply, _tokenName, _decimals, _symbol, _parameters);
        PLCRVoting plcr = parameterizer.voting();
        
        EIP20 token = EIP20(parameterizer.token());
        token.transfer(msg.sender, _supply);
        
        Registry registry = Registry(proxyFactory.createProxy(canonRegistry, ""));
        registry.init(token, _registryName, parameterizer, plcr);
        
        emit onCreateRegistry(msg.sender, parameterizer, registry, token, plcr);
        return registry;
    }
}