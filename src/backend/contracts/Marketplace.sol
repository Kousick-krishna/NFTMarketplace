//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Marketplace is ReentrancyGuard{
    address payable  public feeAccount;
    uint public feepercent;
    uint public itemCount;

    struct Item{
        uint itemId;
        IERC721 nft;
        uint tokenId;
        uint amount;
        address payable seller;
        bool sold;

    }

    event offered(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint amount,
        address indexed seller
    );

    event Bought(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint amount,
        address indexed seller,
        address indexed buyer
    );

    mapping(uint => Item) public items;

    constructor(uint _feepercent){
        feeAccount = payable(msg.sender);
        feepercent = _feepercent;
    }

    function makeItem(IERC721 _nft,uint _tokenId, uint _amount) external nonReentrant{
        require( _amount > 0,"Amount should be greater than zero");
        itemCount++;
        _nft.transferFrom(msg.sender,address(this), _tokenId);
        items[itemCount] = Item(
            itemCount,
            _nft,
            _tokenId,
            _amount,
            payable(msg.sender),
            false
        );

        emit offered(
            itemCount, 
            address(_nft), 
            _tokenId, 
            _amount, 
            msg.sender
            );
    }

    function purchaseItem(uint _itemId) external payable nonReentrant{
        uint _totalprice = grandtotal(_itemId);
        Item storage item = items[_itemId];
        require(_itemId > 0,"No item to purchase");
        require(msg.value >= _totalprice,"Not enough to purchase");
        require(!item.sold,"Item already sold");
        item.seller.transfer(_totalprice);
        feeAccount.transfer(_totalprice - item.amount);
        item.sold = true;
        item.nft.transferFrom(address(this),msg.sender,item.tokenId);
        emit Bought(
            itemCount,
            address(item.nft), 
            item.tokenId, 
            item.amount, 
            item.seller, 
            msg.sender
        );



    }

    function grandtotal(uint _itemId) view public returns(uint){
        return((items[_itemId].amount *(100+feepercent)/100));
    }
}