import  { Wallet, utils,Provider } from "zksync-web3";
const ethers = require('ethers');
const provider = new Provider("https://zksync2-testnet.zksync.dev");

// 设置你的合约地址和ABI
let contractAddress = "your_contract_address";
let abi = ["Your ABI"];

// 创建合约实例
let contract = new ethers.Contract(contractAddress, abi, provider);

// 实时监听"ListingForSale"事件
contract.on("ListingForSale", (seller, tokenId, price, event) => {
    console.log(`Block: ${event.blockNumber}, Seller: ${seller}, Token ID: ${tokenId.toString()}, Price: ${price.toString()}`);
    // 在这里，你可以把事件的信息存储到你的数据库
});
