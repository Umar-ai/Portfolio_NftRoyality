//SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
//Implement ERC-2981 first check this is implemented good or not;

contract UmerNft is ERC721,Ownable {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error UmerNft__MaxLimitReached();

    /*//////////////////////////////////////////////////////////////
                               STATE VARIABLES
       //////////////////////////////////////////////////////////////*/
    string[] public tokenURIs;
    uint256 public tokenCounter = 0;
    uint256 public constant MAX_SUPPLY = 3;

    mapping(uint256 tokenId => string tokenUri) tokenIdToTokenUri;
    // mapping(uint256 tokenId => address) tokenIdToOwner;

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    constructor(string[] memory uris) ERC721("UmarNft", "UN") Ownable(msg.sender) {
        tokenURIs = uris;
    }

    function mintNft() public {
        if (tokenCounter >= MAX_SUPPLY) {
            revert UmerNft__MaxLimitReached();
        }
        uint256 tokenId = tokenCounter + 1;
        tokenIdToTokenUri[tokenId] = tokenURIs[tokenCounter];
        _safeMint(msg.sender, tokenId);
        tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return tokenIdToTokenUri[tokenId];
    }

   
}
