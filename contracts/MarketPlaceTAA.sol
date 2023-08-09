// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";
import "./interfaces/IMarketPlace.sol";
import "./utils/VerifyERCType.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MarketPlaceTAA is
    IMarketPlace,
    ReentrancyGuard,
    ERC721Holder,
    ERC1155Holder,
    Ownable,
    VerifyERCType
{
    uint public crrentOrderId;
    uint public denominator = 1000;
    uint public fee;
    uint[] public ids;

    mapping(uint => OrderInfo) public orders;


    function _transferFrom(address _nftAddr,address _from,address _to,uint _tokenId)private {
        if (verifyByAddress(_nftAddr) == 1155) {
            IERC1155(_nftAddr).safeTransferFrom( _from,_to,_tokenId,1,"0x");
        } else {
            IERC721(_nftAddr).safeTransferFrom(_from,_to,_tokenId,"0x");
        }
    }

    function createOrder(
        address _nftAddr,
        address _payment,
        uint _tokenId,
        uint _price
    ) external {
        crrentOrderId++;
        orders[crrentOrderId] = OrderInfo(msg.sender,_nftAddr,_payment,_tokenId,_price);
        _transferFrom(_nftAddr,msg.sender,address(this),_tokenId);
        ids.push(crrentOrderId);

        emit CreatedOrder(msg.sender,_nftAddr,_payment,crrentOrderId,_tokenId,_price);
    }

    function buyOrder(uint _orderId) external payable nonReentrant {
        OrderInfo memory _Order = orders[_orderId];
        uint _fee = getFeeUserNeedToPay(_Order.price);

        if(_Order.payment == address(0)){
            require(msg.value >= _Order.price,"Insufficient balance in ether.");
            (bool success1, ) = _Order.seller.call{value: _Order.price-_fee}(new bytes(0));
            require(success1,"Fail Withdraw 1");
            (bool success2, ) = address(this).call{value: _fee}(new bytes(0));
            require(success2,"Fail Withdraw 2");
        }else{
            IERC20(_Order.payment).transferFrom(msg.sender,_Order.seller,_Order.price-_fee);
            IERC20(_Order.payment).transferFrom(msg.sender,address(this),_fee);//market transaction fees.
        }

        _transferFrom(_Order.nftAddr,address(this),msg.sender,_Order.tokenId);
        
        emit BoughtOrder(_Order.seller,msg.sender,_Order.payment,_Order.nftAddr,crrentOrderId,_Order.tokenId,_Order.price);

        delete orders[_orderId];
    }

    function cancelOrder(uint _orderId) external {
        require(msg.sender == orders[_orderId].seller, "Market: not seller.");
        _transferFrom(orders[_orderId].nftAddr,address(this),msg.sender,orders[_orderId].tokenId);
        emit CanceledOrder(_orderId);
        delete orders[_orderId];
    }

    function getFeeUserNeedToPay(uint _price)public view returns(uint feeToMarket){
       feeToMarket = _price*fee/denominator;
    }


    function getMarketIds()public view returns(uint[] memory){
        return ids;
    }
    //====================CONFIG==================
    function setFee(uint _fee) external onlyOwner {
        fee = _fee;
    }

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
