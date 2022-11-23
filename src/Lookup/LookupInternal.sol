// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface LookupInternal {
    // Lookup
    error Lookup_InvalidAction();
    error Lookup_NotContract();
    error Lookup_AddExistFunction();
    error Lookup_ReplaceNonexistFunction();
    error Lookup_RemoveNonexistFunction();

    // IDiamond
    enum FacetCutAction {
        Add,
        Replace,
        Remove
    }

    struct FacetCut {
        address facet;
        FacetCutAction action;
        bytes4[] selectors;
    }

    event DiamondCut(FacetCut[] _diamondCut, address _init, bytes _calldata);
}
