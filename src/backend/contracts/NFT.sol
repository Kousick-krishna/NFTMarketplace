//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage{
    uint public tokencount;

    constructor() ERC721("SGAK","KK"){}
    function mint(string memory _tokenURI) external returns(uint) {
        tokencount++;
        _safeMint(msg.sender,tokencount);
        _setTokenURI(tokencount,_tokenURI);
        return(tokencount);

    }
}