//SPDX-License-Identifier:MIT
pragma solidity ^0.8.34;

import { DeployUmerNft } from "../script/DeployUmerNft.s.sol";
import { UmerNft } from "../src/UmerNft.sol";
import { Test } from "forge-std/Test.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract TestUmerNft is Test {
    UmerNft umerNft;
    address userOne;
    string[] tokenUris;
    uint256 public constant SALE_PRICE = 2 ether;

    function setUp() external {
        DeployUmerNft deployUmerNft = new DeployUmerNft();
        (umerNft, tokenUris) = deployUmerNft.run();
        userOne = makeAddr("userOne");
    }

    function testMintHappenSuccessfully() public {
        vm.prank(userOne);
        umerNft.mintNft();
    }

    function testTokenCounterUpdatedSuccessfully() public {
        uint256 tokenCounterBeforeMint = umerNft.tokenCounter();
        assertEq(tokenCounterBeforeMint, 0);
        vm.prank(userOne);
        umerNft.mintNft();
        uint256 tokenCounterAfterMint = umerNft.tokenCounter();
        assertEq(tokenCounterAfterMint, 1);
    }

    function testRevertWhenMintExccedsMaxCount() public actorOne {
        umerNft.mintNft();
        umerNft.mintNft();
        umerNft.mintNft();
        vm.expectRevert(UmerNft.UmerNft__MaxLimitReached.selector);
        umerNft.mintNft();
    }

    function testTokenIdToTokenUriIsValid() public actorOne {
        string memory expectedFirstTokenUri = tokenUris[0];
        umerNft.mintNft();
        string memory actualFirstTokenUri = umerNft.tokenIdToTokenUri(1);
        assertEq(expectedFirstTokenUri, actualFirstTokenUri);
    }

    function testTokenOwnerSetSuccessfully() public actorOne {
        uint256 tokenId = umerNft.tokenCounter() + 1;
        umerNft.mintNft();
        address ownerOfThisTokenId = IERC721(umerNft).ownerOf(tokenId);
        assertEq(ownerOfThisTokenId, userOne);
    }

    function testTokenUriReturnsCorrectTokenUri() public actorOne {
        umerNft.mintNft();
        umerNft.mintNft();
        umerNft.mintNft();
        for (uint256 i; i < tokenUris.length; i++) {
            tokenUris[0] = umerNft.tokenIdToTokenUri(i + 1);
        }
    }

    function testRoyalyFunctionWorksFine() public actorOne {
        //First argument doesn't matter its just a random number;
        (, uint256 actualRoyalty) = umerNft.royaltyInfo(1, SALE_PRICE);
        uint256 royalty = umerNft.i_royaltyFraction();
        uint256 expectedRoyalty = (royalty * SALE_PRICE) / 10_000;
        assertEq(actualRoyalty, expectedRoyalty);
    }

    modifier actorOne() {
        vm.startPrank(userOne);
        _;
        vm.stopPrank();
    }
}
