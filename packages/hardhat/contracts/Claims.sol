// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./Interfaces/IAddressProvider.sol";

contract Claims is Ownable, Pausable {
    using SafeERC20 for IERC20;
    struct ClaimData {
        address claimer;
        bool isDisputed;
        uint256 amount;
        bytes32 data;
        uint256 verificationDeadline;
        string evidenceFolder;
    }

    struct DisputeData {
        address disputer;
        uint256 claimId;
    }

    mapping(uint256 => ClaimData) internal claims;
    mapping(uint256 => DisputeData) internal disputes;

    IAddressProvider public addressProvider;
    uint256 public counter;

    event Claim(uint256 indexed claimID, bytes32 _data, string _evidenceURI);
    event Dispute(uint256 indexed disputeId, uint256 indexed claimID);

    constructor(address _addressProvider) {
        counter = 0;
        addressProvider = IAddressProvider(_addressProvider);
    }

    function submitClaim(
        uint256 _amount,
        bytes32 _data,
        string calldata _evidenceURI
    ) external returns (uint256 claimID) {
        ClaimData memory newClaim;
        newClaim.claimer = msg.sender;
        newClaim.amount = _amount;
        newClaim.data = _data;
        newClaim.evidenceFolder = _evidenceURI;
        newClaim.verificationDeadline = block.timestamp + 7 days;
        claims[counter] = newClaim;
        claimID = counter;
        counter++;
        emit Claim(claimID, _data, _evidenceURI);
        return claimID;
    }

    function processClaim(uint256 claimId) external {
        ClaimData memory claim = claims[claimId];
        require(
            block.timestamp > claim.verificationDeadline,
            "Verification still in progress"
        );
        // IERC20(stablecoin).transferFrom(treasury, claim.claimer, claim.amount);
        delete claims[claimId];
    }

    function disputeClaim(uint256 claimId) external {}

    function settleDispute(uint256 _disputeId, bytes calldata _data) external {}
}
