import { HardhatUserConfig } from "hardhat/config";

import "@matterlabs/hardhat-zksync-deploy";
import "@matterlabs/hardhat-zksync-solc";
import "@matterlabs/hardhat-zksync-verify";

const config: HardhatUserConfig = {
  zksolc: {
    version: "latest",
  },
  defaultNetwork: 'zkSyncTestnet',
  networks: {
    hardhat: {
      zksync: false,
    },
    arbitrum: {
      url: `https://arbitrum-one.public.blastapi.io`,
      chainId: 42161,
      // accounts: '',
    },
    zkSyncTestnet:{
      url: "https://zksync2-testnet.zksync.dev",
      ethNetwork: "goerli",
      zksync: true,
      verifyURL: "https://zksync2-testnet-explorer.zksync.dev/contract_verification",
    },
    zkSyncMainnet:{
      url: 'https://zksync2-mainnet.zksync.io',
      ethNetwork: 'https://eth-mainnet.public.blastapi.io', // Can also be the RPC URL of the Ethereum network (e.g. `https://goerli.infura.io/v3/<API_KEY>`)
      zksync: true,
      verifyURL: 'https://zksync2-mainnet-explorer.zksync.io/contract_verification'
    },
  },
  solidity: {
    version: "0.8.17",
  },
};

export default config;
