// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./Interfaces/IAddressProvider.sol";

contract Vault is Ownable, Pausable {
	using SafeERC20 for IERC20;

	IAddressProvider public addressProvider;
	mapping(address => uint256) public donationTotal;
	mapping(address => bool) public isClaimsContracts;

	constructor(address _addressProvider) {
		addressProvider = IAddressProvider(_addressProvider);
	}

	function donateFunds(uint256 _amount) external {
		IERC20(addressProvider.stablecoin()).safeTransferFrom(
			msg.sender,
			address(this),
			_amount
		);
	}

	function collectFunds(
		uint256 _amount
	) external onlyClaims returns (uint256) {
		IERC20(addressProvider.stablecoin()).safeTransfer(msg.sender, _amount);
		return _amount;
	}

	modifier onlyClaims() {
		require(msg.sender == addressProvider.claims(), "Not claims contract");
		_;
	}
}
