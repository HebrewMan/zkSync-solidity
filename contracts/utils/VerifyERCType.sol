// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "hardhat/console.sol";

contract VerifyERCType {
    function verifyByAddress(
        address _address
    ) public returns (uint contractType) {
        bytes memory ownerOfData = abi.encodeWithSignature(
            "ownerOf(uint256)",
            0
        );
        (bool success, bytes memory returnOwnerOfData) = _address.call{
            value: 0
        }(ownerOfData);
        console.log("returnOwnerOfData", success);
        if (returnOwnerOfData.length > 0) {
            return 721;
        } else {
            bytes memory totalSupplyData = abi.encodeWithSignature(
                "totalSupply()"
            );
            (bool success2, bytes memory returnTotalSupplyData) = _address.call{
                value: 0
            }(totalSupplyData);
            console.log("returnTotalSupplyData", success2);
            if (returnTotalSupplyData.length > 0) {
                return 20;
            } else {
                return 1155;
            }
        }
    }
}
