// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;


contract NftAuction {
    struct Auction {
        //卖家
        address seller;
        //拍卖时长
        uint256 duration;
        //起拍价
        uint256 startPrice;
          uint256 startTime;
        //是否结束
        bool ended;
       
        //最高出价者
        address highestBidder;
         //最高价格        
        uint256 highestBid;
        // uint256 endTime;
       
    }

    //状态变量
    mapping(uint256 => Auction) public auctions;
    //下一个拍卖ID
    uint256 public nextAuctionId;
    //管理员地址
    address public admin;
    constructor() {
        admin = msg.sender;
    }
    //创建拍卖
    function createAuction(uint256 _duration, uint256 _startPrice) public {
        //只有管理员才能创建拍卖
        require(msg.sender == admin, "Only admin can create auction");
        //检查参数
        // _validateAuctionParameters(_duration, _startPrice);
        require(_duration > 1000 * 60, "Duration must be greater than 0");
        require(_startPrice > 0, "Start price must be greater than 0");
        auctions[nextAuctionId] = Auction({
            seller: msg.sender,
            duration: _duration,
            startPrice: _startPrice,
            ended: false,
            highestBidder: address(0),
            highestBid: 0,
            startTime: block.timestamp
        });
        nextAuctionId++;

    } 
    //买家参与买单
    function placeBid(uint256 _auctionId) public payable {
        Auction storage auction = auctions[_auctionId];
        require(!auction.ended && block.timestamp < auction.startTime + auction.duration, "Auction has ended");
        require(msg.value > auction.highestBid && msg.value > auction.startPrice, "Bid must be higher than current highest bid");

        // Refund the previous highest bidder
        if (auction.highestBidder != address(0)) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }

        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
    }
    
}