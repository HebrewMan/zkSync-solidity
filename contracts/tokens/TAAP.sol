// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract TAAP is Ownable,Pausable ,ERC1155Burnable{
    string public constant name = "The Animal Age Props";
    string public constant symbol = "TAAP";
    string public baseURI;
    uint256 public startTs;
    uint256 public endTs;
    address public signerAddr;

    mapping(address => mapping(uint256 => uint256)) public minted; // user => tokenId => amount
    mapping(address => uint256[]) public userIds;    

    constructor(string memory _newURI) ERC1155("") {
        baseURI = _newURI;
        startTs = 0;
        endTs = 100000000000000000;
        signerAddr = 0xc90D1CD75231BcD454bB24Adf5dF4EDfF9A43716;
    }

    function uri(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI,Strings.toString(_tokenId)));
    }

    function setsignerAddr(address _signerAddr) external onlyOwner  {
        require(_signerAddr != address(0), "_signerAddr is the zero address");
        signerAddr = _signerAddr;
    }

    function setStartTs(uint256 _startTs) external onlyOwner  {
        startTs = _startTs;
    }

    function setEndTs(uint256 _endTs) external onlyOwner  {
        endTs = _endTs;
    }

    function setBaseURI(
        string memory _newUri
    ) external onlyOwner {
        baseURI = _newUri;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(
        uint256 _tokenId,
        uint256 amount,
        bytes memory _signature
    ) external whenNotPaused  {
        // bytes32 _msgHash = getMessageHash(msg.sender, _tokenId, amount);
        // bytes32 _ethSignedMessageHash = ECDSA.toEthSignedMessageHash(_msgHash);
        // require(verify(_ethSignedMessageHash, _signature), "Error signture.");
        require(block.timestamp >= startTs && block.timestamp <= endTs, "Error time");
        require(minted[msg.sender][_tokenId] < amount, "Error amount");

        _mint(msg.sender, _tokenId, 1, "");

        minted[msg.sender][_tokenId] += 1;
        userIds[msg.sender].push(_tokenId);
    }

    //第一次传10 第二次传10
    function batchMint(
        uint256 _tokenId,
        uint256 amount,
        bytes memory _signature
    ) external whenNotPaused  {
        bytes32 _msgHash = getMessageHash(msg.sender, _tokenId, amount);
        bytes32 _ethSignedMessageHash = ECDSA.toEthSignedMessageHash(_msgHash);
        require(verify(_ethSignedMessageHash, _signature), "Error signture.");

        require(block.timestamp >= startTs && block.timestamp <= endTs, "Error time");
        require(minted[msg.sender][_tokenId] < amount, "Error amount");

        uint256 _amount = amount - minted[msg.sender][_tokenId];

        _mint(msg.sender, _tokenId, _amount, "");

        minted[msg.sender][_tokenId] += _amount;
        userIds[msg.sender].push(_tokenId);
    }

     function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );
        _safeTransferFrom(from, to, id, amount, data);
        userIds[to].push(id);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
        for(uint i;i<ids.length;i++){
            userIds[to].push(ids[i]);
        }
    }

    function getUserIds(address _addr)public view returns(uint[] memory){
        return userIds[_addr];
    }

    function getMessageHash(
        address _account,
        uint256 _tokenId,
        uint256 _amount
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_account, _tokenId, _amount));
    }

    function verify(
        bytes32 _msgHash,
        bytes memory _signature
    ) public view returns (bool) {
        return ECDSA.recover(_msgHash, _signature) == signerAddr;
    }
}
