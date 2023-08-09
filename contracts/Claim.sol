// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Claim is Ownable {

    IERC20 USDT = IERC20(0x848cb1a9770830da575DfD246dF2d4e38c1D40ed);

    address public signer = 0xD9683e57e5cB40014Df5dFE9a43408ed7c26FE18;

    event Claimed(address _user,uint _amount,uint _type);

    function setSigner (address _newSigner)external onlyOwner{
        signer = _newSigner;
    }

    function _claim(address _account,uint _amount,uint _type,bytes memory _signature) private view{
        require(_account == msg.sender,"Not msg.sender");
        bytes32 _msgHash = getMessageHash(_account,_amount,_type); // 将_account和_amount打包消息
        bytes32 _ethSignedMessageHash = ECDSA.toEthSignedMessageHash(_msgHash); // 计算以太坊签名消息
        require(verify(_ethSignedMessageHash, _signature), "Invalid signature"); // ECDSA检验通过
    }

    function claimAITD(uint _amount,bytes memory _signature)external {
        _claim(msg.sender,_amount,0,_signature);
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Failed to send Ether");
        emit Claimed(msg.sender,_amount,0);
    }
    function claimUSDT(uint _amount,bytes memory _signature)external {
        _claim(msg.sender,_amount,1,_signature);
        USDT.transfer(msg.sender,_amount);
        emit Claimed(msg.sender,_amount,1);
    }

    function getRewardPoolAITDs()external view returns(uint){
        return address(this).balance;
    }
    function getRewardPoolUSDTs()external view returns(uint){
        return USDT.balanceOf(address(this));
    }

    function getMessageHash(address _account, uint256 _amount,uint _type) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_account, _amount,_type));
    }

    function verify(bytes32 _msgHash, bytes memory _signature) internal view returns (bool) {
        return ECDSA.recover(_msgHash, _signature) == signer;
    }

    function withdrawalEther(
        address _addr,
        uint256 _amount
    ) public onlyOwner returns (bool) {
        (bool success, ) = _addr.call{value: _amount}(new bytes(0));
        return success;
    }

    function withdrawalErc20(
        address _addr,
        uint256 _amount
    ) public onlyOwner returns (bool) {
        USDT.transfer(_addr, _amount);
        return true;
    }

    
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}