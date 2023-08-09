// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
contract NFT1155 is ERC1155, Ownable, ERC1155Supply {
    string public name;
    string public baseURI;
    mapping(uint256 => string) private uris;

    constructor(
        string memory _name,
        string memory _baseURI
    ) ERC1155("ipfs://hash/{id}.json") {
        name = _name;
        baseURI = _baseURI;
        _mint(msg.sender, 0, 1, "");
        _mint(msg.sender, 1, 100, "");
        _mint(msg.sender, 2, 1, "");
        _mint(msg.sender, 3, 1000000, "");
        _mint(msg.sender, 4, 1000000, "");
    }

    function uri(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI,Strings.toString(_tokenId),".json"));
    }

    function setURI(string memory newuri) public onlyOwner {
        baseURI = newuri;
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
