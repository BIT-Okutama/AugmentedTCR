pragma solidity ^0.4.24;

import "https://github.com/ConsenSys/Tokens/contracts/eip20/EIP20.sol";
import "./ProxyFactory.sol";

interface IPLCRVoting {
    function init(address _token) public;
}

interface IParameterizer {
    function init(address _token, address _plcr, uint256[] _parameters) public;
}

interface IRegistry {
    function init(address _token, string _name, address _parameterizer, address _voting) public;
}

contract Orchestrator{
    
    ProxyFactory public proxyFactory;
    IPLCRVoting public canonPLCR;
    IParameterizer public canonParam;
    IRegistry public canonRegistry;
    
    struct EnvInstance {
        address creator;
        address plcrInstance;
        address paramInstance;
        address regInstance;
    }
    
    mapping (uint256 => EnvInstance) public envInstances;
    
    uint256 instanceCtr;
    
    constructor () public {
        canonPLCR = IPLCRVoting(0x41b5af59a230c387c8dc999a9596b85d97221252);
        canonParam = IParameterizer(0x74c94f517c6f4d3536ca448d2ba0465b5d11dd9a);
        canonRegistry = IRegistry(0xc00a70fe2125612677356b1d32f1c2f9308fd047);
        proxyFactory = new ProxyFactory();
    }
    
    event onCreateEnvironment(address origin, IParameterizer param, IRegistry reg, EIP20 token, IPLCRVoting plcr);
    
    //To create new augmented TCR environment with an existing token.
    function buildEnv(EIP20 _token, string _registryName, uint256[] _parameters) public {
        
        //Instantiates new Partial Lock Commit/Reveal poll handler.
        IPLCRVoting plcr = IPLCRVoting(proxyFactory.createProxy(canonPLCR, ""));
        plcr.init(_token);
        
        //Instantiates new Parameterizer for a reg.
        IParameterizer param = IParameterizer(proxyFactory.createProxy(canonParam, ""));
        param.init(_token, plcr, _parameters);
        
        //Instantiates new Registry for listings.
        IRegistry reg = IRegistry(proxyFactory.createProxy(canonRegistry, ""));
        reg.init(_token, _registryName, param, plcr);
        
        envInstances[++instanceCtr] = EnvInstance({
            creator: msg.sender,
            plcrInstance: address(plcr),
            paramInstance: address(param),
            regInstance: address(reg)
        });
        
        emit onCreateEnvironment(msg.sender, param, reg, _token, plcr);
        
    }
    
    //To create new augmented TCR environment with an existing token.
    function buildEnvAndToken(uint256 _supply, string _tokenName, uint8 _decimals, string _symbol, uint256[] _parameters, string _registryName) public {
    
        //Instantiates new token for the environment.
        EIP20 token = new EIP20(_supply, _tokenName, _decimals, _symbol);
        token.transfer(msg.sender, _supply);
    
        //Instantiates new Partial Lock Commit/Reveal poll handler.
        IPLCRVoting plcr = IPLCRVoting(proxyFactory.createProxy(canonPLCR, ""));
        plcr.init(token);
        
        //Instantiates new Parameterizer for a reg.
        IParameterizer param = IParameterizer(proxyFactory.createProxy(canonParam, ""));
        param.init(token, plcr, _parameters);
        
        //Instantiates new Registry for listings.
        IRegistry reg = IRegistry(proxyFactory.createProxy(canonRegistry, ""));
        reg.init(token, _registryName, param, plcr);
        
        envInstances[++instanceCtr] = EnvInstance({
            creator: msg.sender,
            plcrInstance: address(plcr),
            paramInstance: address(param),
            regInstance: address(reg)
        });
        
        emit onCreateEnvironment(msg.sender, param, reg, token, plcr);
    }
    
    function getEnvInstances(uint256 _id, address _creator) public view returns(address _plcr, address _param, address _reg) {
        
        require(msg.sender == _creator);
        require(envInstances[_id].creator == _creator);
        
        _plcr = envInstances[_id].plcrInstance;
        _param = envInstances[_id].paramInstance;
        _reg = envInstances[_id].regInstance;
        
    }
    
    function getEnvCount() public view returns(uint256){
        return instanceCtr;
    }
    
}