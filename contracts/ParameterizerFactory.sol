pragma solidity ^0.4.24;

import "./PLCRFactory.sol";
import "./PLCRVoting.sol";
import "./Parameterizer.sol";
import "./EIP20.sol";

contract ParameterizerFactory {

    PLCRFactory public plcrFactory;
    ProxyFactory public proxyFactory;
    Parameterizer public parameterizer;

    constructor(PLCRFactory _plcrFactory) public {
        plcrFactory = _plcrFactory;
        proxyFactory = plcrFactory.proxyFactory();
        parameterizer = new Parameterizer();
    }

    // ...
}
