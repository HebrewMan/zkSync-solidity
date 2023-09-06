// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract NFT1155 is ERC1155, Ownable, ERC1155Supply {

    string public name;
    string public baseURI;
    address public signerAddr;
    mapping(uint256 => string) private uris;
    mapping(address=>uint) public userNonce;
    constructor(
        string memory _name,
        string memory _baseURI
    ) ERC1155("") {
        name = _name;
        baseURI = _baseURI;
        _mint(msg.sender, 0, 1, "");
        _mint(msg.sender, 1, 100, "");
        _mint(msg.sender, 2, 1, "");
        _mint(msg.sender, 3, 1000000, "");
    }

    function uri(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI,Strings.toString(_tokenId),".json"));
    }

    function setSigner(address _addr) external onlyOwner {
        signerAddr = _addr;
    }

    function setURI(string memory newuri) public onlyOwner {
        baseURI = newuri;
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount
    ) public {
        _mint(account, id, amount, "0x");
    }

    function mint(
        uint256 _id,
        uint256 _amount,
        uint256 _nonce,
        bytes memory _signature
    ) public {
        require(_nonce == userNonce[msg.sender],"Nonce error");
        bytes32 _msgHash = getMessageHash(msg.sender,_id,_amount,_nonce);
        require(verify(_msgHash, _signature), "Error signture.");
        _mint(msg.sender, _id, _amount, _signature);

    }

    function mintBatch(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    ) public onlyOwner {
        _mintBatch(_to, _ids, _amounts, _data);
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

    function getUserNonce(address _addr)external view returns(uint){
        return userNonce[_addr];
    }

    function getMessageHash(address _account, uint256 _id,uint _amount,uint _nonce) public pure returns (bytes32){
        return keccak256(abi.encodePacked(_account,_id,_amount,_nonce));
    }

    function verify(bytes32 _msgHash, bytes memory _signature) public view returns (bool){
        bytes32 _ethSignedMessageHash = ECDSA.toEthSignedMessageHash(_msgHash);
        return ECDSA.recover(_ethSignedMessageHash, _signature) == signerAddr;
    }
}
