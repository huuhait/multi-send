import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("MultiSend", function () {
  async function deployMultiSend() {
    const [owner] = await hre.ethers.getSigners();
    const MultiSend = await hre.ethers.getContractFactory("MultiSend");
    const multiSend = await MultiSend.deploy(owner.address);

    return multiSend;
  }

  async function deployMockUSDT() {
    const [owner] = await hre.ethers.getSigners();
    const MockUSDT = await hre.ethers.getContractFactory("MockUSDT");
    const mockUSDT = await MockUSDT.deploy();

    mockUSDT.mint(owner.address, 1000);

    return mockUSDT;
  }

  async function deployMockUSDC() {
    const [owner] = await hre.ethers.getSigners();
    const MockUSDC = await hre.ethers.getContractFactory("MockUSDC");
    const mockUSDC = await MockUSDC.deploy();

    mockUSDC.mint(owner.address, 1000);

    return mockUSDC;
  }

  describe("Deployment", function () {
    // it("Should deploy MultiSend", async function () {
    //   const [owner] = await hre.ethers.getSigners();
    //   const multiSend = await deployMultiSend();

    //   expect(await multiSend.owner()).to.equal(owner.address);
    // });

    // it("Should deploy MockUSDT", async function () {
    //   const [owner] = await hre.ethers.getSigners();
    //   const mockUSDT = await deployMockUSDT();

    //   expect(await mockUSDT.owner()).to.equal(owner.address);
    // });

    // it("Should deploy MockUSDC", async function () {
    //   const [owner] = await hre.ethers.getSigners();
    //   const mockUSDC = await deployMockUSDC();

    //   mockUSDC.

    //   expect(await mockUSDC.owner()).to.equal(owner.address);
    // });

    it("Should send tokens to others addresses", async function () {
      const [owner] = await hre.ethers.getSigners();
      const multiSend = await deployMultiSend();
      const mockUSDT = await deployMockUSDT();
      const mockUSDC = await deployMockUSDC();

      const res = await multiSend.multiSendTokens(
        [await mockUSDT.getAddress(), await mockUSDC.getAddress()],
        ["0x176488c158c5edd6b24be9b1aa2deaaf63f66173", "0xf2cfefd1a6a396b06daec25df491e0819571ad85"],
        [100, 100],
      );

      console.log(res.data)
      expect(await mockUSDC.owner()).to.equal(owner.address);
    });
  });
});
