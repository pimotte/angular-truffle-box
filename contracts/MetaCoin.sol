pragma solidity ^0.5.0;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
	mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor() public {
		balances[tx.origin] = 10000;
	}

	function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		emit Transfer(msg.sender, receiver, amount);
		return true;
	}

  function buyCoin(address payable seller, uint amount) public payable {
    // Check that the value of the balance is covered by the ether sent
    require (getBalanceInEth(seller) * 1 ether > msg.value * 1 wei);
    // Check that the MetaCoin balance of the seller is sufficient
    require (balances[seller] > amount);
    // Check that the amount to be transferred is covered by the ether sent
    require (ConvertLib.convert(amount, 2) * 1 ether <= msg.value * 1 wei);

    balances[msg.sender] += amount;
    balances[seller] -= amount;
    seller.transfer(msg.value);
    emit Transfer(seller, msg.sender, amount);
  }

	function getBalanceInEth(address addr) public view returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}

	function getBalance(address addr) public view returns(uint) {
		return balances[addr];
	}
}
