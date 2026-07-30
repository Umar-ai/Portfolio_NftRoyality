// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC2981 } from "@openzeppelin/contracts/token/common/ERC2981.sol";

//Implement ERC-2981 first check this is implemented good or not;

contract UmerNft is ERC721, Ownable, ERC2981 {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error UmerNft__MaxLimitReached();
    error UmerNft__NotEnoughUris();

    /*//////////////////////////////////////////////////////////////
                               STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    string[] public tokenURIs;
    uint256 public tokenCounter = 0;
    uint256 public constant MAX_SUPPLY = 3;
    address public immutable i_royaltyReceiver;
    uint256 public immutable i_royaltyFraction;

    mapping(uint256 tokenId => string tokenUri) public tokenIdToTokenUri;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event NftMinted(address receiver);
    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    constructor(
        string[] memory uris,
        address royalityReceiver,
        uint256 royalityFraction
    )
        ERC721("UmerNft", "UN")
        Ownable(msg.sender)
    {
        if (uris.length < MAX_SUPPLY) {
            revert UmerNft__NotEnoughUris();
        }
        tokenURIs = uris;
        i_royaltyReceiver = royalityReceiver;
        i_royaltyFraction = royalityFraction;
    }

    function mintNft() public {
        if (tokenCounter >= MAX_SUPPLY) {
            revert UmerNft__MaxLimitReached();
        }
        uint256 tokenId = tokenCounter + 1;
        tokenIdToTokenUri[tokenId] = tokenURIs[tokenCounter];
        emit NftMinted(msg.sender);
        _safeMint(msg.sender, tokenId);
        tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return tokenIdToTokenUri[tokenId];
    }

    function royaltyInfo(
        uint256,
        uint256 salePrice
    )
        public
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        royaltyAmount = (salePrice * i_royaltyFraction) / _feeDenominator();
        return (i_royaltyReceiver, royaltyAmount);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
