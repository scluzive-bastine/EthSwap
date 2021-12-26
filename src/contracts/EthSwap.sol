pragma solidity ^0.5.0;

import "./Token.sol";

contract EthSwap {
    string public name = "EthSwap Instant Exchange";
    Token public token;
    uint256 public rate = 100;

    event TokenPurchased(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    constructor(Token _token) public {
        token = _token;
    }

    function buyTokens() public payable {
        // Calculate the number of tokens to buy
        uint256 tokenAmount = msg.value * rate;

        // Ensure that EthSwap has enough tokens for the trancaction to be completed
        require(token.balanceOf(address(this)) >= tokenAmount);

        // Transfer tokens to user
        token.transfer(msg.sender, tokenAmount);

        //Emit an event
        emit TokenPurchased(msg.sender, address(token), tokenAmount, rate);
    }
}
