// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../EVT.sol";
import "../interfaces/IEVTEncryption.sol";

abstract contract EVTEncryption is EVT, IEVTEncryption {

    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // mapping from tokenId to list of encryptionKeyID => addressSet
    mapping(uint256 => mapping(bytes32 => EnumerableSet.AddressSet)) private _permissions;

    mapping(uint256 => EnumerableSet.Bytes32Set) private _tokenKeyIds;

    /**
     * @dev See {IERC165-supportsInterface}.
     * IEVTEncryption: 0xd28afde2
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, EVT) returns (bool) {
        return interfaceId == type(IEVTEncryption).interfaceId || super.supportsInterface(interfaceId);
    }
   
    function registerEncryptedKey(uint256 tokenId, bytes32 encryptedKeyID) public payable virtual override {
        ERC721._requireMinted(tokenId);
        EnumerableSet.Bytes32Set storage _keyIds = _tokenKeyIds[tokenId];
        require(!_keyIds.contains(encryptedKeyID), "encryptedKeyID already exist");
        _keyIds.add(encryptedKeyID);

        emit EncryptedKeyRegisted(tokenId, encryptedKeyID);
    }
	
    function addPermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) public payable virtual override {
        ERC721._requireMinted(tokenId);
        require(_tokenKeyIds[tokenId].contains(encryptedKeyID), "EVTEncrytion: encryptedKeyID not registered");
        EnumerableSet.AddressSet storage _allowances = _permissions[tokenId][encryptedKeyID];
        _allowances.add(owner);

        emit PermissionAdded(tokenId, encryptedKeyID, owner);
    }
	
    function removePermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) public virtual override {
        ERC721._requireMinted(tokenId);
        EnumerableSet.AddressSet storage _allowances = _permissions[tokenId][encryptedKeyID];
        _allowances.remove(owner);

        emit PermissionRemoved(tokenId, encryptedKeyID, owner);
    }

    function hasPermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) public view virtual override returns (bool) {
        ERC721._requireMinted(tokenId);
        EnumerableSet.AddressSet storage _allowances = _permissions[tokenId][encryptedKeyID];
        return _allowances.contains(owner);
    }
}