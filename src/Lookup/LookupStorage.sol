// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library LookupStorage {
    struct Layout {
        mapping(bytes4 => address) lookup_table;
    }

    bytes32 private constant STORAGE_SLOT =
        keccak256("abstraction.lookup.storage");

    function layout() internal pure returns (Layout storage ret) {
        bytes32 slot = STORAGE_SLOT;
        /// @solidity memory-safe-assembly
        assembly {
            ret.slot := slot
        }
    }
}
