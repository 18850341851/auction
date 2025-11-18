const { ethers } = require("hardhat")

describe("Starting",  function () {
    it("Should deploy the contract", async function () {
        const Contract = await ethers.getContractFactory("NftAuction");
        const contract = await Contract.deploy();
        await contract.waitForDeployment();
        // console.log("NftAuction deployed to:", contract.address);
        await contract.createAuction(
            100*100000000000, 
            ethers.parseEther("0.00000000001"),
            ethers.ZeroAddress, 
            1
        );

        const auction = await contract.auctions(0);
        console.log(auction);
    });
});