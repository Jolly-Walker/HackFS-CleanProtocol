// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressProvider is Ownable {
	address public claims;
	address public cleanToken;
	address public vault;
	address public stablecoin;

	constructor() {}

	function setClaims(address _claims) external onlyOwner {
		claims = _claims;
	}

	function setCleanToken(address _cleanToken) external onlyOwner {
		cleanToken = _cleanToken;
	}

	function setVault(address _vault) external onlyOwner {
		vault = _vault;
	}

	function setStablecoin(address _stablecoin) external onlyOwner {
		stablecoin = _stablecoin;
	}
}
