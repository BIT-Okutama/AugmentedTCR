pragma solidity ^0.4.24;


import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract GenerateToken is ERC20, ERC20Detailed {

    constructor(string _name, string _symbol, string _decimals, address owner, uint256 totalSupply) ERC20Detailed( _name, _symbol, _decimals) public {
        _mint(owner, totalSupply);
    }
}