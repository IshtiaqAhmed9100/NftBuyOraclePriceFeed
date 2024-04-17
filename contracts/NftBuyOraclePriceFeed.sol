// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract NftBuyOraclePriceFeed is ERC721 {
    IERC20 usdtContract; //usdtContract

    AggregatorV3Interface public priceFeed; // chainlinkPriceFeed

    uint256 public nftPrice; //price of 1 nft

    using Counters for Counters.Counter; //openzeppling library or counting
    Counters.Counter private _nftIdCounter; //creatig instance

    uint256 private startTime; //start time
    uint256 private endTime; //end time

    address payable public fundingwallet; //fudning wallett to recieve payment

    constructor(
        address _priceFeed,
        address _fundingwallet,
        address _usdtContract
    ) ERC721("NFTBuyPriceFeed", "NftOracle") {
        priceFeed = AggregatorV3Interface(_priceFeed); //eth/usd sepolia chainlink price feed address
        nftPrice = 1000 * (10 ** 6); // setting the nft price
        startTime = block.timestamp; // setting start time
        endTime = block.timestamp + 7 days; // settting end times
        fundingwallet = payable(_fundingwallet); //ssetting funding wallet
        _nftIdCounter.increment(); //counter increment
        usdtContract = IERC20(_usdtContract); // ssetting usdt ccontract
    }

    //function for geting the live eth/usd price chainlink
    function getLatestPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData(); //gettting only price

        return uint256(price); //return the eth/usd pricce
    }

    //function for buying nft with eth
    function BuyNftWithETH(uint256 no) public payable {
        require(_nftIdCounter._value < 500); //only 500 nfts are allowed to mint
        require(
            startTime > block.timestamp || block.timestamp < endTime //1 week timee
        );
        uint256 p = (no * nftPrice * 1e20) / getLatestPrice(); //calculating eth price
        require(msg.value > p); //user should have enough amouunt
        payable(fundingwallet).transfer(p); //eth transfer
        for (uint256 i = 0; i < no; i++) {
            //for loop for user to buy nfts

            uint256 tokenId = _nftIdCounter.current();

            _mint(msg.sender, tokenId); // mintng the nft to tthe usser

            _nftIdCounter.increment(); //increemeting tthe no. of nfts being minted
        }
    }

    //function for buying nft with usdt
    function BuyNftWithUsdt(uint256 no) public payable {
        require(_nftIdCounter._value < 500); //only 500 nfts are allowed to mint
        require(
            startTime > block.timestamp || block.timestamp < endTime //1 week timee
        );
        uint256 p = no * nftPrice; //calculating the usdt price
        require(IERC20(usdtContract).balanceOf(msg.sender) > p); //user should have enough amouunt
        IERC20(usdtContract).transferFrom(msg.sender, fundingwallet, p); // transferrring the usdt to the funding waller
        for (uint256 i = 0; i < no; i++) {
            //for loop for user to buy nfts

            uint256 tokenId = _nftIdCounter.current();

            _mint(msg.sender, tokenId); // mintng the nft to tthe usser

            _nftIdCounter.increment(); //increemeting tthe no. of nfts being minted
        }
    }

    //function for gettting the no. of nfts being minted
    function getNftCounter() public view returns (uint256) {
        return _nftIdCounter._value - 1;
    }

    //funcction for gettig the balancce of usddt
    function getBalance(address _add) public view returns (uint256) {
        return IERC20(usdtContract).balanceOf(_add);
    }

    function getEthBalance() public view returns (uint256) {
        return balanceOf(fundingwallet);
    }
}
