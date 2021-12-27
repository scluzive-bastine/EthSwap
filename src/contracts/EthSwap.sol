pragma solidity ^0.5.0;

import "./Token.sol";

contract EthSwap {
    string public name = "EthSwap Instant Exchange";
    Token public token;
    uint256 public rate = 100;

    event TokensPurchased(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );
    event TokensSold(
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
        emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
    }

    function sellTokens(uint256 _amount) public {
        // User can't sell more tokens than they have
        require(token.balanceOf(msg.sender) >= _amount);

        // calculate the amount of ether to redeem
        uint256 etherAmount = _amount / rate;

        // Require that ethSwap has enough ether
        require(address(this).balance >= etherAmount);
        // Perform sale
        token.transferFrom(msg.sender, address(this), _amount);
        msg.sender.transfer(etherAmount);

        // Emit Tokens sold
        emit TokensSold(msg.sender, address(token), _amount, rate);
    }
}
