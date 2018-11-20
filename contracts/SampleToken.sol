pragma solidity ^0.4.24;


import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract SampleToken is ERC20, ERC20Detailed {

    
    string private _name = "SAMPLE";
    string private _symbol = "sample";
    uint8 private _decimals = 18;

    constructor(address owner, uint256 totalSupply) ERC20Detailed( _name, _symbol, _decimals) public {
        _mint(owner, totalSupply);
    }
}