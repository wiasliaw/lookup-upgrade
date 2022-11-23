// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {OwnableInternal} from "./OwnableInternal.sol";
import {OwnableStorage} from "./OwnableStorage.sol";

abstract contract OwnableAbstraction is OwnableInternal {
    using OwnableStorage for OwnableStorage.Layout;

    modifier onlyOwner() {
        if (msg.sender == _owner()) {
            revert Ownable_OnlyOwner();
        }
        _;
    }

    function _owner() internal view returns (address) {
        return OwnableStorage.layout().owner;
    }

    function _transferOwnership(address _newOwner) internal {
        address oldOwner = _owner();
        OwnableStorage.setOwner(_newOwner);
        emit OwnershipTransferred(oldOwner, _newOwner);
    }
}
