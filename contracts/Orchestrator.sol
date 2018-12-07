pragma solidity ^0.4.24;

import "./ERC20Detailed.sol";
import "./ProxyFactory.sol";

interface IPLCRVoting {
    function init(ERC20Detailed _token) public;
}

interface IParameterizer {
    function init(ERC20Detailed _token, address _plcr, uint256[] _parameters) public;
}

interface IRegistry {
    function init(ERC20Detailed _token, string _name, address _parameterizer, address _voting) public;
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
        canonPLCR = IPLCRVoting(0xd2414f39fac18a2e23f00d3a69aff687175d64dc);
        canonParam = IParameterizer(0x848c8710dcdeeeade9dc870e09ede47620922690);
        canonRegistry = IRegistry(0xb94e35f2fd936d26fa2596611583403803573621);
        proxyFactory = new ProxyFactory();
    }
    
    event onCreateEnvironment(address origin, IParameterizer param, IRegistry reg, ERC20Detailed token, IPLCRVoting plcr);
    
    //To create new augmented TCR environment with an existing token.
    function buildEnv(ERC20Detailed _token, string _registryName, uint256[] _parameters) public {
        
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
        ERC20Detailed token = new ERC20Detailed(_tokenName, _symbol, _decimals);
        token._mint(msg.sender, _supply);
    
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