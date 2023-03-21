// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
// import "@openzeppelin/contracts/token/common/ERC2981.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
// import "@openzeppelin/contracts/utils/Address.sol";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// // import "./ERC1155Full.sol";
// // import "./INoyz.sol";

// contract NOYZ is ERC1155Full, ReentrancyGuard, Ownable , ERC2981 { 

//     using SafeMath for uint256;
//     using Address for address payable;
//     // admin address, the owner of the marketplace
//     address payable admin;
//     address public contract_owner;
//     //NOyz Address
//     INoyz token_;
//     // last price sold or auctioned
//     mapping(uint256 => uint256) public soldFor;
//     // Mapping from token ID to sell price in Ether or to bid price, depending if it is an auction or not
//     mapping(uint256 =>mapping(address => uint256)) public sellBidPrice;
//     // Mapping payment address for tokenId 
//     mapping(uint256 => address payable) private _wallets;
//     // Auction data
//     struct Auction {
//         // Parameters of the auction. Times are either
//         // absolute unix timestamps (seconds since 1970-01-01)
//         // or time periods in seconds.
//         address payable beneficiary;
//         uint auctionEnd;
//         // Current state of the auction.
//         address payable highestBidder;
//         address auction_owner;
//         uint highestBid;
//         // Set to true at the end, disallows any change
//         bool open;
//         // minimum reserve price in wei
//         uint256 reserve;
//         uint256 amount ;
//     }

//     //handle royalties
//     struct Royalties {
//         address payable artist;
//         uint percentage;
//         bool secondarySale;
//     }

//     //Register artist name and symbol agnaist address::
// //     struct myinfo{
// //     string name;
// //     string symbol;
// //     bool check;
// //     address artistaddress;
// // }

//     // struct info{

//     //     address _own;
//     //     uint256 _id;
//     //     uint256 _copies;
//     // }

//     struct amountcheck{
//       uint256 _Forauction;
//       uint256 _Forsell;
//       uint256 _soldamount;
//       uint256 _auctionedamount;
//     }
//     //map toke id against artist royalti
//     mapping(uint => Royalties) private royalties;
//     mapping(uint256 => address) public _Owners;
//    // mapping(uint256 => address) private _approve;
//    // mapping(address => myinfo) private _registerinfo;
//     mapping(uint256 => mapping(address => uint256)) public Forauction;
//     mapping(uint256 => mapping(address => uint256)) public Forsale;
//     mapping(uint256 => address) private _tokenApprovals;
//     // mapping auctions for each tokenId
//     mapping(uint256 => mapping (address => Auction)) public auctions;

//     // Events that will be fired on changes.
//     event Refund(address indexed bidder, uint amount);
//     event HighestBidIncreased(address indexed bidder, uint amount, uint256 tokenId);
//     event AuctionEnded(address indexed winner, uint amount);
//     event MarketSell(address indexed from,uint256 indexed tokenId, uint256 amount_ , uint256 price, address wallet);
//     event Auctionsell(address indexed from, address indexed _benificiary ,uint256 indexed tokennId,uint256 _amount,uint closing_time,uint reserve_price);
//     // event MarketBuy(address indexed from, address indexed to, uint256 amount);
//     event RoyalityFee(address indexed artist,uint amount,uint tokenId);
//     event Sale(uint256 indexed tokenId, address indexed from, address indexed to, uint256 value);

//    constructor(address _owner, address payable _admin,  bool _anyoneCanMint,address _NOYZ,string memory seturi_,string memory name_,string memory symbol_)
//             ERC1155Full(name_,symbol_,_anyoneCanMint,seturi_) {
//             admin = _admin;
//             contract_owner = _owner;
//             token_ = INoyz(_NOYZ);
//     }

//     function supportsInterface(bytes4 interfaceId)
//         public
//         view
//         override(ERC1155Full,ERC2981)
//         returns (bool)
//     {
//         return super.supportsInterface(interfaceId);
//     }
     
//     function canSell(uint256 tokenId, address _seller) public view returns (bool) {
//             return ( balanceOf(_seller, tokenId) - Forauction[tokenId][_seller] > 0);
//     }

//     // function RegisterArtistName(string memory _setname,string memory _setsymbol) public {

//     //         _registerinfo[msg.sender] = myinfo(_setname,_setsymbol,true,msg.sender);
//     //        // return _registerinfo[msg.sender].check;

//     //     }
//     // function CheckArtistInfo(address _artistaddress) public view returns(myinfo memory){

//     //         return _registerinfo[_artistaddress];
//     // }

//     mapping (uint => bool) public nft_mint;

//     function autodo_Mint(uint amount,
//                 bytes memory data,
//                 string memory uri,
//                 uint96 Royalty_percentage, uint8 check) public{

//             require(Royalty_percentage <=1000 && Royalty_percentage >=100,"percentage Should be between 100 and 10000 ");
//            // require(!_registerinfo[msg.sender].check, "First Register yourself with 'RegisterArtisName' Function");
            
//             autoMint(msg.sender,amount,data,uri);
//             if(check == 1){
//                 nft_mint[autoTokenId] = true;
//             }
//             _Owners[autoTokenId] = msg.sender;
//             _setTokenRoyalty(autoTokenId,msg.sender, Royalty_percentage);
//     }
   
//     function autodobatch_Mint(uint[] memory amount,
//                 bytes memory data,
//                 string memory uri,
//                 uint96 Royalty_percentage, uint8 check) public{


//             require(Royalty_percentage <=100 && Royalty_percentage >=1000,"percentage Should be between 100 and 1000 ");
//             autoBatchMint(msg.sender,amount,data,uri);
//             if(check == 1){
//                 nft_mint[autoTokenId] = true;
//             }
//             for(uint256 i=0; i< autoTokenId1.length;i++){
//            _setTokenRoyalty(autoTokenId1[i],msg.sender, Royalty_percentage );
//             _Owners[autoTokenId1[i]] = msg.sender;
//             }
//     }
    
//     function IsAlbum(uint _id) public view returns(bool){
//         return nft_mint[_id];
//     }

//     function sell(uint256 tokenId, uint256 amount_ , uint256 price, address payable wallet) public {

//             // onlyOwneR
//         Forsale[tokenId][msg.sender] += amount_;

//         uint256 balances = balanceOf(msg.sender, tokenId);

//         require( balances>0  && amount_ <= balances,"you don't have enough copies for sell");

//         require(balances - Forsale[tokenId][msg.sender] - Forauction[tokenId][msg.sender] >=0, "limit exceeded for selling::" );

//         // set sell price for index
//         sellBidPrice[tokenId][msg.sender] = price;

//         // If price is zero, means not for sale
//         if (price>0) {

//             // approve the Index to the current contract
//             setApprovalForAll(address(this), true);
            
//             // set wallet payment
//             _wallets[tokenId] = wallet;

//         }
//          emit MarketSell(msg.sender,tokenId,amount_,price,wallet);

//     } 

//     function getPrice(uint256 tokenId, address seller_) public view returns (uint256, uint256, uint256) {
//                     if (sellBidPrice[tokenId][seller_]>0) return (sellBidPrice[tokenId][seller_], 0, 0);
//                     if (auctions[tokenId][seller_].highestBid>0) return (0, auctions[tokenId][seller_].highestBid, 0);
//                     return (0, 0, soldFor[tokenId]);
//     }

//     function CalculateRoyalty( uint256 _tokenid, uint _price) public view  returns( address, uint256) {
//        return royaltyInfo(_tokenid,_price);
//     } 

//                       // Buy option
//     function buy(uint256 tokenId,uint256 amount, address _seller) public payable nonReentrant {

//         require(Forsale[tokenId][_seller] >= amount,"Not Enough token listed for sale");
//         // is on sale
//         require(sellBidPrice[tokenId][_seller] >0 && Forsale[tokenId][_seller] > 0, "ERC1155Matcha: The collectible is not for sale");
//         // transfer funds
//         require((msg.value == (sellBidPrice[tokenId][_seller] * amount)), "ERC1155Matcha: Not enough funds");
//         // transfer ownership
//         require(_seller != address(0), "Owner query for nonexistent token");
//         require(msg.sender!=_seller, "ERC1155Matcha: The seller cannot buy his own collectible");
//         // SET MINTER ADDRESS AND ITS ROYALTY FEE 
//         ( address admin_Royalty , uint256 get_royality) = royaltyInfo(tokenId, sellBidPrice[tokenId][_seller]);
//         // we need to call a transferFrom from this contract, which is the one with permission to sell the NFT
//         callOptionalReturn(this, abi.encodeWithSelector(this.safeTransferFrom.selector, _seller, msg.sender, tokenId,amount,"0x00"));

//         Forsale[tokenId][_seller] -= amount;
//         if(Forsale[tokenId][_seller] == 0){
//             sellBidPrice[tokenId][_seller] =0;
//         }
//         // TOTAL VALUE OF NFT BUYING
//         uint amount4owner = msg.value;

//         if(admin_Royalty == _seller)
//         {
//             (bool success, ) = _wallets[tokenId].call{value:msg.value}("");
//             require(success, "Transfer failed sending to owner.");
//         }
//         else{
//             amount4owner = msg.value - get_royality;
//             (bool success, ) = _wallets[tokenId].call{value:amount4owner}(
//                 ""
//             );
//             require(success, "Transfer failed sending to owner.");

//             (bool success1, ) = payable(admin_Royalty).call{value:get_royality}(
//             ""
//             );
//             require(success1, "Transfer failed sending to royality owner.");

//             emit RoyalityFee(admin_Royalty,get_royality,tokenId);
//         }
//         // close the sell
//         if(Forsale[tokenId][_seller] <= 0)
//         {   
//         // _checkamount[tokenId]._Forsell = 0;
//             sellBidPrice[tokenId][_seller] = 0;
//         }
//         _wallets[tokenId] = payable(address(0));
//         soldFor[tokenId] = msg.value;

//         emit Sale(tokenId, _seller, msg.sender, amount4owner);
//     }

//     function callOptionalReturn(IERC1155 token, bytes memory data) private {
      
//         require(payable(address(token)).isContract(), "SafeERC1155: call to non-contract");

//         // solhint-disable-next-line avoid-low-level-calls
//         (bool success, bytes memory returndata) = address(token).call(data);
//         require(success, "SafeERC1155: low-level call failed");

//         if (returndata.length > 0) { // Return data is optional
//             require(abi.decode(returndata, (bool)), "SafeERC1155: ERC20 operation did not succeed");
//         }
//     }

//     function buyWithToken(address _seller,address to_,uint256 tokenId,uint _amount) public nonReentrant {

//         // is on sale
//         require(sellBidPrice[tokenId][_seller]>0, "ERC1155Matcha: The collectible is not for sale");
//         // transfer funds
//         require(_amount>0,"amount should be greater than zero");
//         require(token_.balanceOf(msg.sender) >= sellBidPrice[tokenId][_seller].mul(_amount), "ERC1155Matcha: Not enough funds");
//         // transfer ownership
//             address owner = _Owners[tokenId];
//             require(owner != address(0), "Owner query for nonexistent token");
//         require(msg.sender!=owner, "ERC1155Matcha: The seller cannot buy his own collectible");
//         //transfer tokens to seller account
//         token_.transferFrom(msg.sender,to_,_amount);
//         // we need to call a transferFrom from this contract, which is the one with permission to sell the NFT
//         callOptionalReturn(this, abi.encodeWithSelector(this.safeTransferFrom.selector, owner, msg.sender, tokenId,_amount,"0x00"));
//         // close the sell
//         sellBidPrice[tokenId][_seller] = 0;
//         _wallets[tokenId] = payable(address(0));
//         soldFor[tokenId] = _amount;

//         emit Sale(tokenId, owner, msg.sender, _amount);
//     }

//     function canAuction(uint256 tokenId, address _owner) public view returns (bool) {
//        return ((_owner == msg.sender) && (!auctions[tokenId][_owner].open) && (balanceOf(_owner,tokenId) -  Forsale[tokenId][_owner] > 0));
//     }

//     function createAuction(uint256 tokenId, uint _amount, uint _closingTime, address payable _beneficiary, uint256 _reservePrice) public {

//         Forauction[tokenId][msg.sender] += _amount;
//         require(!auctions[tokenId][msg.sender].open, "Already auctioned");
//         uint256 balances = balanceOf(msg.sender, tokenId);
//         require(balances >= _amount,"you don't have much copies left");
//         require(balances - Forsale[tokenId][msg.sender] >= 0, "limit exceeded for Auctioned::" );

//         auctions[tokenId][msg.sender].beneficiary = _beneficiary;
//         auctions[tokenId][msg.sender].auctionEnd = _closingTime;
//         auctions[tokenId][msg.sender].reserve = _reservePrice;
//         auctions[tokenId][msg.sender].auction_owner = msg.sender;
//         auctions[tokenId][msg.sender].amount = _amount;
//         auctions[tokenId][msg.sender].open = true;

//         // approve the Index to the current contract
//         setApprovalForAll(address(this), auctions[tokenId][msg.sender].open);
//         emit Auctionsell(msg.sender,_beneficiary, tokenId, _amount,_closingTime,_reservePrice);
//     }
   
//     function canBid(uint256 tokenId, address _tobid) public view returns (bool) {
//         if (!payable(msg.sender).isContract() && auctions[tokenId][_tobid].open &&
//             block.timestamp <= auctions[tokenId][_tobid].auctionEnd &&
//             msg.sender != _tobid) {
//             return true;
//         } else {
//             return false;
//         }
//     }

//     function bid(uint256 tokenId,address _owner) public payable nonReentrant {
//         // Contracts cannot bid, because they can block the auction with a reentrant attack
//         require(!payable(msg.sender).isContract(), "No script kiddies");
//         require(auctions[tokenId][_owner].reserve <= msg.value, " Bid should be higher than reserve price");
//         // auction has to be opened
//         require(auctions[tokenId][_owner].open, "Not auctioned yet");
//         // approve was lost
//         require(isApprovedForAll(_owner,address(this)), "Cannot complete the auction");
//         // Revert the call if the bidding
//         // period is over.
//         require(
//             block.timestamp <= auctions[tokenId][_owner].auctionEnd,
//             "Auction already ended."
//         );
//         // If the bid is not higher, send the
//         // money back.
//         require(
//             msg.value > auctions[tokenId][_owner].highestBid,
//             "There already is a higher bid."
//         );
//         //address owner = _Owners[tokenId];
//         require(msg.sender!=_owner, "ERC1155Matcha: The owner cannot bid his own collectible");

//         // return the funds to the previous bidder, if there is one
//         if (auctions[tokenId][_owner].highestBid>0) {
//             (bool success, ) = auctions[tokenId][_owner].highestBidder.call{value: (auctions[tokenId][_owner].highestBid)}("");
//             require(success, "Transfer failed.");
//             emit Refund(auctions[tokenId][_owner].highestBidder, auctions[tokenId][_owner].highestBid);
//         }
//         // now store the bid data
//         auctions[tokenId][_owner].highestBidder = payable(msg.sender);
//         auctions[tokenId][_owner].highestBid = msg.value;

//         emit HighestBidIncreased(msg.sender, msg.value, tokenId);
//     }

//     function canWithdraw(uint256 tokenId, address seller) public {
//         if (((auctions[tokenId][seller].open== true) && 
//             (block.timestamp >= auctions[tokenId][seller].auctionEnd)) &&
//                 ( (auctions[tokenId][seller].highestBid > 0) && (auctions[tokenId][seller].highestBidder == msg.sender) )) {
//             (bool success, ) = auctions[tokenId][seller].highestBidder.call{value :(auctions[tokenId][seller].highestBid)}("");
//             require(success, "Transfer failed.");
//         }
//         // finalize the auction
//          delete auctions[tokenId][seller];
//     }

//     function canFinalize(uint256 tokenId, address seller) public view returns (bool) {

//         if (auctions[tokenId][seller].open && block.timestamp >= auctions[tokenId][seller].auctionEnd &&
//             (
//                 auctions[tokenId][seller].highestBid>=auctions[tokenId][seller].reserve || 
//                 auctions[tokenId][seller].highestBid==0
//             )){
//             return true;
//         } else {
//             return false;
//         }
//     }

//     function auctionFinalize(uint256 tokenId, address seller) public nonReentrant {

//         require(canFinalize(tokenId, seller), "Cannot finalize");

//         if (auctions[tokenId][seller].highestBid > auctions[tokenId][seller].reserve) {
//             // transfer the ownership of token to the highest bidder
//             address payable highestBidding = auctions[tokenId][seller].highestBidder;
//             // SET ADMIN ADDRESS AND ROYALTY
//             ( address admin_Royalty , uint256 get_royality) = royaltyInfo(tokenId,auctions[tokenId][seller].highestBid);
//             // we need to call a transferFrom from this contract, which is the one with permission to sell the NFT
//             // transfer the NFT to the auction's highest bidder
//             uint nftamount = auctions[tokenId][seller].amount;
//             callOptionalReturn(this, abi.encodeWithSelector(this.safeTransferFrom.selector, seller, highestBidding, tokenId,nftamount,"0x00"));
//             uint amount4owner = auctions[tokenId][seller].highestBid;

//         if(admin_Royalty == seller)
//         {

//             (bool success, ) = seller.call{value:auctions[tokenId][seller].highestBid}("");
//             require(success, "Transfer failed sending to owner.");

//         }
//         else{

//             amount4owner = auctions[tokenId][seller].highestBid - get_royality;
//             (bool success, ) = seller.call{value:amount4owner}("");
//             require(success, "Transfer failed sending to owner.");

//             (bool success1, ) = payable(admin_Royalty).call{value:get_royality}(
//             ""
//             );
//             require(success1, "Transfer failed sending to royality owner.");

//             emit RoyalityFee(admin_Royalty,get_royality,tokenId);
//         }
//             Forauction[tokenId][seller] -=  auctions[tokenId][seller].amount ;

//             soldFor[tokenId] = auctions[tokenId][seller].highestBid;
//             emit Sale(tokenId, seller, highestBidding, amount4owner);

//         }

//         emit AuctionEnded(auctions[tokenId][seller].highestBidder, auctions[tokenId][seller].highestBid);

//         // finalize the auction
//         delete auctions[tokenId][seller];
//     }

//     function highestBidder(uint256 tokenId, address seller) public view returns (address payable) {
//         return auctions[tokenId][seller].highestBidder;
//     }

//     function highestBid(uint256 tokenId, address seller) public view returns (uint256) {
//         return auctions[tokenId][seller].highestBid;
//     }

//     function updateAdmin(address payable _admin, bool _anyoneCanMint) public {
//         require(msg.sender==contract_owner, "Only contract owner can do this");
//         admin=_admin;
//         anyoneCanMint=_anyoneCanMint;
//     }

//     function updateRoyalti(uint tokenId , uint96 royalty_percentage) external returns(bool success){
//         (address owner,) = royaltyInfo(tokenId,0);
//         require(owner == msg.sender,"only Owner can update the royalty fee");
//         require(royalty_percentage >= 100 && royalty_percentage <= 1000,"Owner can get maximum 10% royalty");
//          _setTokenRoyalty(tokenId,msg.sender, royalty_percentage);
//         return true;
//     }

// }