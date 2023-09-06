import  { Wallet, utils,Provider } from "zksync-web3";
import  * as zksync from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";

// load env file
import dotenv from "dotenv";
dotenv.config();

// load wallet private key from env file
const PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY || "";

if (!PRIVATE_KEY)
  throw "⛔️ Private key not detected! Add it to the .env file!";

// An example of a deploy script that will deploy and call a simple contract.
export default async function (hre: HardhatRuntimeEnvironment) {
  console.log(`✨ Running deploy script for the EFAS contracts`);

  const wallet = new Wallet(PRIVATE_KEY);
  const deployer = new Deployer(hre, wallet);

  const provider = new Provider("https://zksync2-testnet.zksync.dev");
  const signer = new ethers.Wallet(PRIVATE_KEY, provider);
  const getBalance = await signer.getBalance();
  const deployBeforeBalanceL2 = ethers.utils.formatEther(getBalance.toString());

  console.log(`👨‍🔬 Account : ${wallet.address}`);
  console.log(`💰 Deploy Before Balance L2: ${deployBeforeBalanceL2}`);

   //============ NFT20 ==============
  //  const artifact20 = await deployer.loadArtifact("USDT");
  //  const name = "EFAS Test USDT";
  //  const symbol = "USDT";
  //  const USDT = await deployer.deploy(artifact20, [name,symbol]);
  //  // Show the contract info.
  //  console.log(`✅ ${artifact20.contractName} was deployed to ${USDT.address}`);

  // const artifact = await deployer.loadArtifact("NFT721");
  // const baseUri = "ipds://test.efas.io";
  // const nameNFT = "EFAS NFTs"
  // const symbolNFT = "EFAS721"
  // const nft721Contract = await deployer.deploy(artifact, [baseUri,nameNFT,symbolNFT]);
  // // Show the contract info.
  // const contractAddress = nft721Contract.address;
  // console.log(`✅ ${artifact.contractName} was deployed to ${contractAddress}`);

  //============ NFT1155 ==============
  const artifact1155 = await deployer.loadArtifact("NFT1155");
  const baseUri1155 = "ipds://efas.io";
  const name1155 = "EFAS 1155 NFTs"
  const nft1155Contract = await deployer.deploy(artifact1155, [baseUri1155,name1155]);
  // Show the contract info.
  // console.log(nft1155Contract);

  console.log(`✅ ${artifact1155.contractName} was deployed to ${nft1155Contract.address}`);


  //============ MARKET ==============
  // const artifactMarket = await deployer.loadArtifact("MarketPlace");
  // const marketContract = await deployer.deploy(artifactMarket);
  // // Show the contract info.d
  // console.log(`✅ ${artifactMarket.contractName} was deployed to ${marketContract.address}`);

  // const getBalance2 = await signer.getBalance();
  // const afterBeforeBalanceL2 = ethers.utils.formatEther(getBalance2.toString());

  // console.log(`💰 After Balance L2: ${afterBeforeBalanceL2}`);
  // console.log(`👨‍🔬 ========== FINISHED =========`);

}


