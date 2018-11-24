pragma solidity ^0.4.24;

import "./EIP20.sol";
import "./ProxyFactory.sol";
import "./PLCRVoting.sol";
import "./Parameterizer.sol";
import "./Registry.sol";


contract Orchestrator{
    
    ProxyFactory public proxyFactory;
    PLCRVoting public canonPLCR;
    Parameterizer public canonParam;
    Registry public canonRegistry;
    
    struct EnvInstance {
        address creator;
        address plcrInstance;
        address paramInstance;
        address regInstance;
    }
    
    mapping (uint256 => EnvInstance) public envInstances;
    
    uint256 instanceCtr;
    
    constructor () public {
        canonPLCR = new PLCRVoting();
        proxyFactory = new ProxyFactory();
        canonParam = new Parameterizer();
        canonRegistry = new Registry();
    }
    
    event onCreateEnvironment(address origin, Parameterizer param, Registry reg, EIP20 token, PLCRVoting plcr);
    
    //To create new augmented TCR environment with an existing token.
    function buildEnv(EIP20 _token, string _registryName, uint256[] _parameters) public returns(Registry reg, Parameterizer param, PLCRVoting plcr) {
        
        //Instantiates new Partial Lock Commit/Reveal poll handler.
        plcr = PLCRVoting(proxyFactory.createProxy(canonPLCR, ""));
        plcr.init(_token);
        
        //Instantiates new Parameterizer for a reg.
        param = Parameterizer(proxyFactory.createProxy(canonParam, ""));
        param.init(_token, plcr, _parameters);
        
        //Instantiates new Registry for listings.
        reg = Registry(proxyFactory.createProxy(canonRegistry, ""));
        reg.init(_token, _registryName, param, plcr);
        
        envInstances[++instanceCtr] = EnvInstance({
            creator: msg.sender,
            plcrInstance: address(plcr),
            paramInstance: address(param),
            regInstance: address(reg)
        });
        
        emit onCreateEnvironment(msg.sender, param, reg, _token, plcr);
        return (reg, param, plcr);
        
    }
    
    //To create new augmented TCR environment with an existing token.
    function buildEnvAndToken(uint256 _supply, string _tokenName, uint8 _decimals, string _symbol, uint256[] _parameters, string _registryName) public returns(Registry reg, Parameterizer param, PLCRVoting plcr) {
    
        //Instantiates new token for the environment.
        EIP20 token = new EIP20(_supply, _tokenName, _decimals, _symbol);
        token.transfer(msg.sender, _supply);
    
        //Instantiates new Partial Lock Commit/Reveal poll handler.
        plcr = PLCRVoting(proxyFactory.createProxy(canonPLCR, ""));
        plcr.init(token);
        
        //Instantiates new Parameterizer for a reg.
        param = Parameterizer(proxyFactory.createProxy(canonParam, ""));
        param.init(token, plcr, _parameters);
        
        //Instantiates new Registry for listings.
        reg = Registry(proxyFactory.createProxy(canonRegistry, ""));
        reg.init(token, _registryName, param, plcr);
        
        envInstances[++instanceCtr] = EnvInstance({
            creator: msg.sender,
            plcrInstance: address(plcr),
            paramInstance: address(param),
            regInstance: address(reg)
        });
        
        emit onCreateEnvironment(msg.sender, param, reg, token, plcr);
        return (reg, param, plcr);
    }
    
    function getEnvInstances(uint256 _id, address _creator) public view returns(address _plcr, address _param, address _reg) {
        
        require(msg.sender == _creator);
        require(envInstances[_id].creator == _creator);
        
        _plcr = envInstances[_id].plcrInstance;
        _param = envInstances[_id].paramInstance;
        _reg = envInstances[_id].regInstance;
        
    }
    
}