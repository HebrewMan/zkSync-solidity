import { Wallet, utils, Provider } from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import { abi } from '../artifacts-zk/contracts/tokens/ERC1155.sol/NFT1155.json';
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

    const contractAddress = "0x2DAE230e224D467A35d56E9093D24A98E9917d70";
    const contract = new ethers.Contract(contractAddress, abi, provider);
    const contractWithSigner = contract.connect(signer);  // if you plan to make non-view calls

    const tx = await contract.baseURI();

    console.log("=========HASH=======>",tx);

    // let nfts = await contract.getUserNFTs(signer.address) 

    // nfts = nfts.map(item=>item*1);

    // console.log("=========AMOUNT=======>",nfts);


}
