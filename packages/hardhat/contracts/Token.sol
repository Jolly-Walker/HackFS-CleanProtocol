// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "./Interfaces/IAddressProvider.sol";

contract CleanToken is ERC20Permit {

    address payable public owner;
    IAddressProvider public addressProvider;
    mapping(address => bool) public isClaimsContracts;

    event Withdrawal(uint amount, uint when);

    constructor(
        string memory _name,
        string memory _symbol,
        address _addressProvider
    ) ERC20(_name, _symbol) ERC20Permit(_name) {
        addressProvider = IAddressProvider(_addressProvider);
    }

    function mintForClaim(uint256 _amount, address _recipient) external onlyClaims {
        _mint(_recipient, _amount);
    }


    modifier onlyClaims() {
        require(msg.sender == addressProvider.claims(), "Not claims contract");
        _;
    }
}
