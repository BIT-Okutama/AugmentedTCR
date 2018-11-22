pragma solidity ^0.4.24;


import "./PLCRFactory.sol";
import "./PLCRVoting.sol";
import "./Parameterizer.sol";
import "./EIP20.sol";

contract ParameterizerFactory {

    PLCRFactory public plcrFactory;
    ProxyFactory public proxyFactory;
    Parameterizer public canonParam;
    
    constructor(PLCRFactory _plcrFactory) public {
        plcrFactory = _plcrFactory;
        proxyFactory = plcrFactory.proxyFactory();
        canonParam = new Parameterizer();
    }
    
    event onCreateParameterizer(address origin, address token, Parameterizer parameterizer, address plcr);
    
    function createNewParameterizer(EIP20 _token, uint256[] _parameters) public returns(Parameterizer) {
        
        PLCRVoting plcr = plcrFactory.createNewPLCR(_token);
        
        Parameterizer parameterizer = Parameterizer(proxyFactory.createProxy(canonParam, ""));
        parameterizer.init(_token, plcr, _parameters);
        
        emit onCreateParameterizer(msg.sender, _token, parameterizer, plcr);
        return parameterizer;
    }
    
    function createNewParameterizerWithToken(uint256 _supply, string _name, uint8 _decimals, string _symbol, uint256[] _parameters) public returns(Parameterizer) {
        
        PLCRVoting plcr = plcrFactory.createNewPLCRWithToken(_supply, _name, _decimals, _symbol);
        
        EIP20 token = EIP20(plcr.token());
        token.transfer(msg.sender, _supply);
        
        Parameterizer parameterizer = Parameterizer(proxyFactory.createProxy(canonParam, ""));
        parameterizer.init(token, plcr, _parameters);
        
        emit onCreateParameterizer(msg.sender, token, parameterizer, plcr);
        return parameterizer;
    }

}
