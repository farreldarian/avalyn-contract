import { DeployFunction } from 'hardhat-deploy/types'
import { HardhatRuntimeEnvironment } from 'hardhat/types'

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { ethers, deployments } = hre

  const [signer] = await ethers.getSigners()
  const result = await deployments.deploy('AvalynCompounder', {
    from: signer.address,
    log: true,
    args: [[]],
  })

  console.log('Compounder deployed to:', result.address)
}
export default func
func.tags = ['Compounder']
