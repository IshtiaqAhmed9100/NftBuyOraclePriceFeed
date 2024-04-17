const { time } = require("console");
const { setServers } = require("dns");
const { ethers } = require("hardhat");
const { run } = require("hardhat");
async function verify(address, constructorArguments) {
  console.log(
    `verify  ${address} with arguments ${constructorArguments.join(",")}`
  );
  await run("verify:verify", {
    address,
    constructorArguments,
  });
}
async function main() {
  let priceFeed = "0x694AA1769357215DE4FAC081bf1f309aDC325306";
  let fundingwallet = "0x395bFD879A3AE7eC4E469e26c8C1d7BB2F9d77B9";
  let usdtContract = "0xDb592b20B4d83D41f9E09a933966e0AC02E7421B";

//   const NftBuyOraclePriceFeed = await ethers.deployContract(
//     "NftBuyOraclePriceFeed",
//     [priceFeed, fundingwallet, usdtContract]
//   );

//   console.log("Deploying NftBuyOraclePriceFeed...");
//   await NftBuyOraclePriceFeed.waitForDeployment();

//   console.log(
//     "NftBuyOraclePriceFeed deployed to:",
//     NftBuyOraclePriceFeed.target
//   );

//   await new Promise((resolve) => setTimeout(resolve, 10000));
  verify("0x3fc4197A3Cc2364FAa27117707398a76C494BCD9", [
    priceFeed,
    fundingwallet,
    usdtContract,
  ]);
}
main();
