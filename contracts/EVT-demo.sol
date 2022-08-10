// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./EVT.sol";
import "./extensions/EVTEncryption.sol";


contract EVTEncryptionDemo is EVT, EVTEncryption {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    address public tokenContract;

    constructor(string memory name_, string memory symbol_, address tokenContract_) EVT(name_, symbol_) {
        tokenContract = tokenContract_;
    }

    function mint(address to) public payable {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function getEncryptionKeyId(bytes memory EncryptionKey) public pure returns (bytes32){
        return bytes32(keccak256(EncryptionKey));
    }

    function getTokenCount(address owner) public returns (uint256) {
        bytes memory tokenCount = Address.functionCall(tokenContract, abi.encodeWithSelector(bytes4(keccak256("balanceOf(address)")), owner));
        return abi.decode(tokenCount, (uint256));
    }

    function registerEncryptedKey(uint256 tokenId, bytes32 encryptedKeyID) public payable override {
        require(getTokenCount(msg.sender) > 0, "no register permission");
        require(msg.sender == ERC721.ownerOf(tokenId), "not token owner");
        EVTEncryption.registerEncryptedKey(tokenId, encryptedKeyID);
    }

    function addPermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) public payable override {
        require(msg.sender == ERC721.ownerOf(tokenId), "not token owner");
        EVTEncryption.addPermission(tokenId, encryptedKeyID, owner);
    }

    function removePermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) public override {
        require(msg.sender == ERC721.ownerOf(tokenId), "not token owner");
        EVTEncryption.removePermission(tokenId, encryptedKeyID, owner);
    }

    function supportsInterface(bytes4 interfaceId) public view override(EVT, EVTEncryption) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
