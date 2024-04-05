import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { config as dotEnvConfig } from "dotenv";

dotEnvConfig();

const { BSC_TESTNET_PRIVATE_KEY } = process.env;
const { ETHERSCAN_API_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  defaultNetwork: "bsc-testnet",
  networks: {
    'bsc-testnet': {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      accounts: [BSC_TESTNET_PRIVATE_KEY],
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
    customChains: [
      {
        chainId: 97,
        network: 'bsc-testnet',
        urls: ['https://data-seed-prebsc-1-s1.binance.org:8545'],
      }
    ]
  },
};

export default config;
