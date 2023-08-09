// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

interface IMarketPlace {
    event CreatedOrder(
        address indexed _seller,
        address indexed _nft,
        address indexed _payment,
        uint _orderId,
        uint _tokenId,
        uint _price
    );

    event BoughtOrder(
        address indexed _seller,
        address indexed _buyer,
        address indexed _payment,
        address _nft,
        uint _orderId,
        uint _tokenId,
        uint _price
    );

    event CanceledOrder(uint orderId);

    struct OrderInfo {
        address seller;
        address nftAddr;
        address payment;
        uint tokenId;
        uint price;
    }

    function createOrder(
        address nftAddr,
        address payment,
        uint tokenId,
        uint price
    ) external;

    function buyOrder(uint orderId) external payable;

    function cancelOrder(uint orderId) external;

}
