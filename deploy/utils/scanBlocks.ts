import  { Wallet, utils,Provider } from "zksync-web3";
const ethers = require('ethers');
const provider = new Provider("https://zksync2-testnet.zksync.dev");

// 设置你的合约地址和ABI
let contractAddress = "your_contract_address";
let abi = ["Your ABI"];
// 创建合约实例
let contract = new ethers.Contract(contractAddress, abi, provider);

// 设置开始和结束区块的高度
let startBlock = 0;
let endBlock = "latest";  // 你也可以设置一个具体的区块高度

// 扫描区块
async function scanBlocks(start, end) {
  for(let i = start; i <= end; i++) {
    let events = await contract.queryFilter("ListingForSale", i, i);
    for(let j = 0; j < events.length; j++) {
        let event = events[j];
        let args = event.args;

        console.log(`Block: ${i}, Seller: ${args.seller}, Token ID: ${args.tokenId.toString()}, Price: ${args.price.toString()}`);
        
        // 在这里，你可以把事件的信息存储到你的数据库
    }
  }
}

// 执行扫描
scanBlocks(startBlock, endBlock);
