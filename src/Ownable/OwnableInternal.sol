// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface OwnableInternal {
    error Ownable_OnlyOwner();

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
}
