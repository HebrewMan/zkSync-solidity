import  { Wallet, utils,Provider } from "zksync-web3";
const ethers = require('ethers');
const provider = new Provider("https://zksync2-testnet.zksync.dev");

const signer = provider.getSigner();
const transaction = {
    to: "0x接收者的以太坊地址",
    value: ethers.utils.parseEther("1.0"),
    data: ethers.utils.hexlify(123456)
};

const response = await signer.sendTransaction(transaction);
console.log('Transaction hash: ', response.hash);

let txHash = "你想要查看的交易的哈希";

async function getTransactionData() {
    let transaction = await provider.getTransaction(txHash);

    if(transaction.data){
        // 将数据从HEX格式转换为字符串
        let data = ethers.utils.toUtf8String(transaction.data);
        console.log("Data: ", data);
    }
    else{
        console.log("No data in this transaction");
    }
}

getTransactionData();