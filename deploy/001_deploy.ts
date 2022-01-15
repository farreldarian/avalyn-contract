import { DeployFunction } from 'hardhat-deploy/types'
import { HardhatRuntimeEnvironment } from 'hardhat/types'

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { ethers, deployments } = hre

  const [signer] = await ethers.getSigners()
  const result = await deployments.deploy('Greeter', {
    from: signer.address,
    args: ['Hello, Hardhat!'],
  })

  console.log('Greeter deployed to:', result.address)
}
export default func
