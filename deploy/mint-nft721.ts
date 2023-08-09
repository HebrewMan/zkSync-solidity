import { Wallet, utils, Provider } from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import { abi } from '../artifacts-zk/contracts/tokens/ERC721.sol/NFT721.json';
// load env file
import dotenv from "dotenv";
dotenv.config();

// load wallet private key from env file
const PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY || "";

if (!PRIVATE_KEY)
    throw "⛔️ Private key not detected! Add it to the .env file!";

// An example of a deploy script that will deploy and call a simple contract.
export default async function (hre: HardhatRuntimeEnvironment) {
    console.log(`✨ Mint EFAS NFT`);
    
    const provider = new Provider("https://zksync2-testnet.zksync.dev");
    const signer = new ethers.Wallet(PRIVATE_KEY, provider);
    const getBalance = await signer.getBalance();
    const beforeBalanceL2 = ethers.utils.formatEther(getBalance.toString());


    console.log("Mint before balance is " + beforeBalanceL2);

    const contractAddress = "0xF57B37F68190D9023b6aed874Db860525298ef27";
    const contract = new ethers.Contract(contractAddress, abi, provider);
    const contractWithSigner = contract.connect(signer);  // if you plan to make non-view calls

    const tx = await contractWithSigner.mint(signer.address);

    console.log("=========HASH=======>",tx.hash);

    let nfts = await contract.getUserNFTs(signer.address) 

    nfts = nfts.map(item=>item*1);

    console.log("=========AMOUNT=======>",nfts);


}
