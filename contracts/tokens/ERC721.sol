// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFT721 is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Ownable,
    ReentrancyGuard
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    event Minted(address indexed minter, uint indexed _tokenId);
    // Base URI
    string public baseURIextended;

    constructor(
        string memory __baseURI,
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        _tokenIdCounter.increment();
        baseURIextended = string(
            abi.encodePacked(__baseURI, Strings.toHexString(address(this)), "/")
        );
    }

    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURIextended = __baseURI;
    }

    function setTokenURI(
        uint256 _tokenId,
        string memory _tokenURI
    ) external onlyOwner {
        _setTokenURI(_tokenId, _tokenURI);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURIextended;
    }

    //需要做验证签名
    function mint(address _to) public returns (uint tokenId) {
        tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(_to, tokenId);
        string memory tokenIdUri = Strings.toString(tokenId);
        _setTokenURI(tokenId, tokenIdUri);
    }

    function _mint(address _to) private returns (uint tokenId) {
        tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(_to, tokenId);
        string memory tokenIdUri = Strings.toString(tokenId);
        _setTokenURI(tokenId, tokenIdUri);
    }

    function batchMintForWhitelist(
        address[] memory _addresses
    ) public onlyOwner {
        for (uint i; i < _addresses.length; i++) {
            uint _tokenId = _mint(_addresses[i]);
            emit Minted(msg.sender, _tokenId);
        }
    }

    function getUserNFTs(address _user) public view returns (uint[] memory) {
        uint length = balanceOf(_user);
        uint[] memory ids = new uint[](length);
        for (uint i; i < ids.length; i++) {
            ids[i] = tokenOfOwnerByIndex(_user, i);
        }
        return ids;
    }

    function withdrawalEther(
        address _addr,
        uint256 _amount
    ) public onlyOwner returns (bool) {
        (bool success, ) = _addr.call{value: _amount}(new bytes(0));
        return success;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
