// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAddressProvider {
    function claims() external returns (address);

    function cleanToken() external returns (address);

    function vault() external returns (address);

    function stablecoin() external returns (address);
}
