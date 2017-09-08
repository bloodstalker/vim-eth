pragma solidity ^0.4.0;

contract SimpleStorage {
  uint StoreData;
  address public minter;
  mapping (address => uint) public balances;

  event Sent(address from, address to, uint amount);

  function SimpleStorage(address minter, uint data) {
    StoreData = data;
    minter = msg.sender;
  }

  function mint(address receiver, uint amount) {
    if (msg.sender != minter) return;
    balances[receiver]+= amount;
  }

  function getBalance(address add) returns (uint) {
    return balances[add];
  }

  function send(address receiver, uint amount) {
    if (balances[msg.sender] < amount) return;
    balances[msg.sender] -= amount;
    balances[receiver] += amount;
    Sent(msg.sender, receiver, amount);
  }

  function set(uint x) {
    StoreData = x;
  }

  function get() constant returns (uint) {
    return StoreData;
  }
}
