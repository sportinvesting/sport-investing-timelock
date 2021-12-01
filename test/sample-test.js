// const { expect } = require('chai')

const { ethers, upgrades } = require('hardhat')

describe('Timelock test', function () {
  it('deploys', async function () {
    let accounts = await hre.ethers.getSigners()
    let deployer = accounts[0].address

    const Timelock = await ethers.getContractFactory('Timelock')
    let timelock = await Timelock.deploy()
    console.log('timelock: ', timelock.address)

    let name = await token.name()
    console.log('name: ', name)

    let balance = await token.balanceOf(deployer)
    console.log('balance: ', balance.toString())

    const MyTokenV2 = await ethers.getContractFactory('MyToken')

    let upgradedToken = await upgrades.upgradeProxy(token.address, MyTokenV2)
    console.log('upgradedToken: ', upgradedToken.address) // the same address
    let nameAfterUpgrade = await upgradedToken.name()
    console.log('nameAfterUpgrade: ', nameAfterUpgrade)

    let balanceAfterUpgrade = await token.balanceOf(deployer)
    console.log('balanceAfterUpgrade: ', balanceAfterUpgrade.toString())

    let stringOne = await upgradedToken.stringOne()
    console.log('stringOne: ', stringOne)

    let stringTwo = await upgradedToken.stringTwo()
    console.log('stringTwo: ', stringTwo)

    await upgradedToken.setStringTwo('String Two')
    stringTwo = await upgradedToken.stringTwo()
    console.log('stringTwo: ', stringTwo)
  })
})
