// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Address} from "openzeppelin-contracts/utils/Address.sol";

import {LookupInternal} from "./LookupInternal.sol";
import {LookupStorage} from "./LookupStorage.sol";

abstract contract LookupAbstraction is LookupInternal {
    using Address for address;
    using LookupStorage for LookupStorage.Layout;

    function _lookup(bytes4 _selector) internal view returns (address) {
        return LookupStorage.layout().lookup_table[_selector];
    }

    function _diamondCut(
        FacetCut[] memory _Facets,
        address _init,
        bytes memory _calldata
    ) internal {
        address facet;
        bytes4[] memory selectors;
        FacetCutAction action;
        uint256 facetIndex;

        while (facetIndex < _Facets.length) {
            // decode data
            facet = _Facets[facetIndex].facet;
            selectors = _Facets[facetIndex].selectors;
            action = _Facets[facetIndex].action;

            // take action
            if (action == FacetCutAction.Add) {
                __addFunctions(facet, selectors);
            } else if (action == FacetCutAction.Replace) {
                __replaceFunctions(facet, selectors);
            } else if (action == FacetCutAction.Remove) {
                __removeFunctions(facet, selectors);
            } else {
                // revert if invalid action
                revert Lookup_InvalidAction();
            }

            // index
            unchecked {
                ++facetIndex;
            }
        }

        __initDiamond(_init, _calldata);
        emit DiamondCut(_Facets, _init, _calldata);
    }

    /**
     * set `table[bytes4]` from zero to non-zero
     * `_implementation` must be a contract
     */
    function __addFunctions(address _implementation, bytes4[] memory _selectors)
        private
    {
        if (!_implementation.isContract()) {
            // revert if not a contract
            revert Lookup_NotContract();
        }

        LookupStorage.Layout storage l = LookupStorage.layout();
        address oldFacet;
        uint256 i;
        while (i < _selectors.length) {
            oldFacet = l.lookup_table[_selectors[i]];

            if (oldFacet != address(0)) {
                // revert if `table[bytes4]` is exist
                revert Lookup_AddExistFunction();
            }

            l.lookup_table[_selectors[i]] = _implementation;
            unchecked {
                ++i;
            }
        }
    }

    /**
     * set `table[bytes4]` from non-zero to non-zero
     * `_implementation` must be a contract
     */
    function __replaceFunctions(
        address _implementation,
        bytes4[] memory _selectors
    ) private {
        if (!_implementation.isContract()) {
            // revert if not a contract
            revert Lookup_NotContract();
        }

        LookupStorage.Layout storage l = LookupStorage.layout();
        address oldFacet;
        uint256 i;
        while (i < _selectors.length) {
            oldFacet = l.lookup_table[_selectors[i]];

            if (oldFacet == address(0)) {
                // revert if `table[bytes4]` is non-exist
                revert Lookup_ReplaceNonexistFunction();
            }

            l.lookup_table[_selectors[i]] = _implementation;
            unchecked {
                ++i;
            }
        }
    }

    /**
     * set `table[bytes4]` from non-zero to zero
     * `_implementation` must be a address(0)
     */
    function __removeFunctions(
        address _implementation,
        bytes4[] memory _selectors
    ) private {
        if (_implementation != address(0)) {
            // revert if non-zero
            revert Lookup_NotContract();
        }

        LookupStorage.Layout storage l = LookupStorage.layout();
        address oldFacet;
        uint256 i;
        while (i < _selectors.length) {
            oldFacet = l.lookup_table[_selectors[i]];

            if (oldFacet == address(0)) {
                // revert if `table[bytes4]` is zero
                revert Lookup_RemoveNonexistFunction();
            }

            delete l.lookup_table[_selectors[i]];
            unchecked {
                ++i;
            }
        }
    }

    function __initDiamond(address _init, bytes memory _calldata) private {
        if (!_init.isContract()) {
            // revert if not a contract
            revert Lookup_NotContract();
        }
        _init.functionDelegateCall(_calldata);
    }
}
