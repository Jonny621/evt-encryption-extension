// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EncryptionToken is ERC721, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public price;

    constructor(uint256 price_) ERC721("EncryptionToken", "NET") {
        price = price_;
    }

    function safeMint(address to) public payable {
        require(msg.value >= price, "purchase price error");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function updatePirce(uint256 price_) public onlyOwner {
        price = price_;
    }

    function withdraw() public {
        Address.sendValue(payable(owner()), address(this).balance);
    }

}