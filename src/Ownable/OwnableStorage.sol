// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library OwnableStorage {
    struct Layout {
        address owner;
    }

    bytes32 private constant STORAGE_SLOT =
        keccak256("abstraction.ownable.storage");

    function layout() internal pure returns (Layout storage ret) {
        bytes32 slot = STORAGE_SLOT;
        /// @solidity memory-safe-assembly
        assembly {
            ret.slot := slot
        }
    }

    function setOwner(address _newOwner) internal {
        layout().owner = _newOwner;
    }
}
