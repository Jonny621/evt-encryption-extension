// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "../IEVT.sol";

interface IEVTEncryption is IEVT {

    event EncryptedKeyRegisted(uint256 indexed tokenId, bytes32 encryptedKeyID);

    event PermissionAdded(uint256 indexed tokenId, bytes32 encryptedKeyID, address indexed owner);

    event PermissionRemoved(uint256 indexed tokenId, bytes32 encryptedKeyID, address indexed owner);

    /**
     * @dev registerEncryptedKey `tokenId`
     * encryptedKeyID = bytes32(keccak256('encryptedKey');
     * Requirements:
     *
     * - `tokenId` token must exist and be owned by `from`.
     *
     */
    function registerEncryptedKey(uint256 tokenId, bytes32 encryptedKeyID) external payable;
	
    /**
     * @dev Returns the results - bool
     * expiredTime is the limit dateTime for one permission
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist.
     * - `owner` must exist.
     */
    function addPermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) external payable;
	
    /**
     * @dev Returns the results - bool
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist.
     * - `owner` must exist.
     */
    function removePermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) external;

    /**
     * @dev Returns the results - bool
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `encryptedKeyID` must exist.
     * - `owner` must exist.
     */
    function hasPermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) external view returns (bool);
}