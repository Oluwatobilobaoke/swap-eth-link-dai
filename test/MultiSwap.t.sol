// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "../src/MultiSwap.sol";
import "../src/IERC20.sol";

contract MultiSwapTest is Test {
    MultiSwap public multiSwap;

    address DAIContract = 0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6;
    address LINKContract = 0x779877A7B0D9E8603169DdbD7836e478b4624789;

    address ethUsd = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address diaUsd = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;
    address linkUsd = 0xc59E3633BAAC79493d908e63626716e204A45EdF;

    address DAIWHALE = 0xFE95E892D250322a65d87b1D5B3BcB78c8c8EF7F;
    address LINKWHALE = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;

    function setUp() public {
        multiSwap = new MultiSwap();
        fundContract();
    }

    // function testGetDATAPRICE() public view {
    //     int ethUSDPrice = multiSwap.LatestETHprice();
    //     int DAIUSDPrice = multiSwap.LatestDAIprice();
    //     int LINKUSDPrice = multiSwap.LatestLinkprice();

    //     // console.log("ETH price: ", price);
    //     console2.log("ethUSD price: ", ethUSDPrice );
    //     console2.log("DAIUSD price: ", DAIUSDPrice);
    //     console2.log("LINKUSD price: ", LINKUSDPrice );
    //     assertTrue(ethUSDPrice > 0);
    //     assertTrue(DAIUSDPrice > 0);
    //     assertTrue(LINKUSDPrice > 0);
    // }

    // function testGetDerivedPrice() public view {
    //     int rate = multiSwap.getDerivedPrice(ethUsd, diaUsd, 8);

    //     console2.log("rate==>", rate);
    // }

    function testSwapEthForDAI() public {
        vm.startPrank(LINKWHALE);
        fundUserEth(LINKWHALE);

        (uint ethBalBefore, uint tokenBalBefore) = getBeforeBalance(
            LINKWHALE,
            DAIContract,
            "DAI"
        );

        multiSwap.swapEThForTokens{value: 0.05 ether}(address(0), DAIContract);
        (uint ethBalAfter, uint tokenBalAfter) = getAfterBalance(
            LINKWHALE,
            DAIContract,
            "DAI"
        );

        assertLt(ethBalAfter, ethBalBefore);
    }

    function testSwapEthForLINK() public {
        vm.startPrank(DAIWHALE);
        fundUserEth(DAIWHALE);

        (uint ethBalBefore, uint tokenBalBefore) = getBeforeBalance(
            DAIWHALE,
            LINKContract,
            "LINK"
        );

        multiSwap.swapEThForTokens{value: 0.05 ether}(address(0), DAIContract);
        (uint ethBalAfter, uint tokenBalAfter) = getAfterBalance(
            DAIWHALE,
            LINKContract,
            "LINK"
        );

        assertLt(ethBalAfter, ethBalBefore);
    }

    function testSwapDAIforETH() public {
        fundContract();
        vm.startPrank(DAIWHALE);
        // vm.deal(address(DAIWHALE), 0.02 ether);
        fundUserEth(DAIWHALE);
        fundUserToken(DAIWHALE, DAIContract);

        (uint ethBalBefore, uint tokenBalBefore) = getBeforeBalance(
            DAIWHALE,
            DAIContract,
            "DAI"
        );

        // approve multiswap to remove money
        IERC20(DAIContract).approve(address(multiSwap), 20 ether);

        multiSwap.swapTokens(DAIContract, address(0), 20 ether);

        (uint ethBalAfter, uint tokenBalAfter) = getAfterBalance(
            DAIWHALE,
            DAIContract,
            "DAI"
        );
        vm.stopPrank();

        assertLt(tokenBalAfter, tokenBalBefore);
        assertGt(ethBalAfter, ethBalBefore);
    }

    // function testSwapLINKforETH() public {
    //     fundContract();
    //     vm.startPrank(LINKWHALE);
    //     // vm.deal(address(DAIWHALE), 0.02 ether);
    //     fundUserEth(LINKWHALE);
    //     fundUserToken(LINKWHALE, LINKContract);

    //     uint256 _amount = 10;

    //     getBeforeBalance(LINKWHALE, LINKContract, "LINK");

    //     // approve multiswap to remove money
    //     IERC20(LINKContract).approve(address(multiSwap), _amount);

    //     multiSwap.swapTokens(LINKContract, address(0), _amount);

    //     getAfterBalance(LINKWHALE, LINKContract, "DAI");
    // }

    function fundContract() public {
        vm.deal(address(multiSwap), 100 ether);
        deal(address(DAIContract), address(multiSwap), 100000 ether);
        deal(address(LINKContract), address(multiSwap), 100000 ether);
        // transfer link to contract
        // vm.startPrank(LINKWHALE);
        // IERC20(LINKContract).transfer(address(multiSwap), 100 ether);
        // vm.stopPrank();

        // // transfer dai to contract
        // vm.startPrank(DAIWHALE);
        // IERC20(DAIContract).transfer(address(multiSwap), 100 ether);
        // vm.stopPrank();
        console.log("ETHERS in Contract:  ", address(multiSwap).balance);
        console.log(
            "DAI in Contract:  ",
            IERC20(DAIContract).balanceOf(address(multiSwap))
        );
        console.log(
            "LINK in Contract:  ",
            IERC20(LINKContract).balanceOf(address(multiSwap))
        );
    }

    function getBeforeBalance(
        address userAddress,
        address _tokenContract,
        string memory tokenNAME
    ) public view returns (uint, uint) {
        uint256 ethBalBefore = address(userAddress).balance;
        uint256 tokenBalBefore = IERC20(_tokenContract).balanceOf(DAIWHALE);
        console.log("ETH BALANCE BEFORE ===>", ethBalBefore);
        console.log("TOKEN BALANCE BEFORE ===>", tokenBalBefore, tokenNAME);

        return (ethBalBefore, tokenBalBefore);
    }

    function getAfterBalance(
        address userAddress,
        address _tokenContract,
        string memory tokenNAME
    ) public view returns (uint, uint) {
        uint256 ethBalAfter = address(userAddress).balance;
        uint256 tokenBalAfter = IERC20(_tokenContract).balanceOf(DAIWHALE);
        console.log("ETH BALANCE AFTER ===>", ethBalAfter);
        console.log("TOKEN BALANCE AFTER ===>", tokenBalAfter, tokenNAME);

        return (ethBalAfter, tokenBalAfter);
    }

    function fundUserEth(address userAdress) public {
        vm.deal(address(userAdress), 0.5 ether);
    }

    function fundUserToken(address userAddress, address tokenAddress) public {
        deal(address(tokenAddress), address(userAddress), 100 ether);
    }
}
