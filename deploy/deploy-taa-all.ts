import { Wallet, utils, Provider } from "zksync-web3";
import * as zksync from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";

// load env file
import dotenv from "dotenv";
dotenv.config();

// load wallet private key from env file
const PRIVATE_KEY = process.env.TAA_PRIVATE_KEY || "";

if (!PRIVATE_KEY)
    throw "⛔️ Private key not detected! Add it to the .env file!";

// An example of a deploy script that will deploy and call a simple contract.
export default async function (hre: HardhatRuntimeEnvironment) {
    console.log(`✨ Running deploy script for the TAA 1155 contracts`);

    const wallet = new Wallet(PRIVATE_KEY);
    const deployer = new Deployer(hre, wallet);

    const provider = new Provider("https://zksync2-testnet.zksync.dev");
    // const provider = new Provider("https://mainnet.era.zksync.io");

    const signer = new ethers.Wallet(PRIVATE_KEY, provider);
    const getBalance = await signer.getBalance();
    const deployBeforeBalanceL2 = ethers.utils.formatEther(getBalance.toString());

    console.log(`👨‍🔬 Account : ${wallet.address}`);
    console.log(`💰 Deploy Before Balance L2: ${deployBeforeBalanceL2}`);

    //============ NFT1155 ==============
    const artifactTAAK = await deployer.loadArtifact("TAAK");
    const baseUriTAAK = "https://api.theanimalage.com/api/taak/";
    const TAAK = await deployer.deploy(artifactTAAK, [baseUriTAAK]);
    // Show the contract info.
    console.log(`✅ ${artifactTAAK.contractName} was deployed to ${TAAK.address}`);

    //============ NFT1155 ==============
    const artifactTAAP = await deployer.loadArtifact("TAAP");
    const baseUriTAAP = "https://api.theanimalage.com/api/taap/";
    const TAAP = await deployer.deploy(artifactTAAP, [baseUriTAAP]);
    // Show the contract info.
    console.log(`✅ ${artifactTAAP.contractName} was deployed to ${TAAP.address}`);

    //============ MARKET ==============
    // const artifactMarket = await deployer.loadArtifact("MarketPlaceTAA");
    // const marketContract = await deployer.deploy(artifactMarket);
    // // Show the contract info.
    // console.log(`✅ ${artifactMarket.contractName} was deployed to ${marketContract.address}`);

    const getBalance2 = await signer.getBalance();
    const afterBeforeBalanceL2 = ethers.utils.formatEther(getBalance2.toString());

    console.log(`💰 Deploy After Balance L2: ${afterBeforeBalanceL2}`);

    console.log(`👨‍🔬 ========== FINISHED =========`);

}
