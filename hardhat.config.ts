import '@nomiclabs/hardhat-etherscan'
import '@nomiclabs/hardhat-waffle'
import '@typechain/hardhat'
import 'dotenv/config'
import 'hardhat-deploy'
import 'hardhat-gas-reporter'
import { HardhatUserConfig } from 'hardhat/config'
import 'solidity-coverage'
import { getAlchemyNetworkConfig } from './helpers/get-alchemy-network-config/get-alchemy-network-config'

const config: HardhatUserConfig = {
  solidity: '0.8.11',
  networks: getAlchemyNetworkConfig(process.env.ALCHEMY_API_KEY ?? '', [
    process.env.PRIVATE_KEY ?? '',
  ]),
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: 'USD',
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  typechain: {
    outDir: 'types/typechain',
  },
}

export default config
