import { providers } from 'ethers'
import {
  HardhatNetworkAccountsUserConfig,
  HardhatUserConfig,
  HttpNetworkAccountsUserConfig,
} from 'hardhat/types'
import { isNil } from 'lodash'
import { alchemyNetworks } from './alchemy-networks'

type AccountsConfig =
  | HardhatNetworkAccountsUserConfig
  | HttpNetworkAccountsUserConfig
type NetworkConfig = HardhatUserConfig['networks']

export function getAlchemyNetworkConfig(
  apiKey: string,
  accounts: AccountsConfig,
  networkConfig?: NetworkConfig
) {
  const config: NetworkConfig = {}

  for (const networkName of alchemyNetworks) {
    const network = providers.getNetwork(networkName)
    if (isNil(network) || network.name === 'unknown') {
      continue
    }

    const url = providers.AlchemyProvider.getUrl(network, apiKey).url

    config[networkName] = {
      ...networkConfig,
      chainId: network.chainId,
      url,
      // @ts-ignore
      accounts,
    }
  }

  return config
}
