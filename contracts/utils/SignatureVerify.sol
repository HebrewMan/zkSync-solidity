// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
pragma solidity ^0.8.9;

contract Signature {
    function getMessageHash(
        address _account,
        uint256 _amount
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_account, _amount));
    }

    function getETHMessageHash(bytes32 _msgHash) public pure returns (bytes32) {
        return ECDSA.toEthSignedMessageHash(_msgHash);
    }

    function verify(
        bytes32 _msgHash,
        bytes memory _signature
    ) public pure returns (address) {
        return ECDSA.recover(_msgHash, _signature);
    }
}
