pragma solidity^0.4.0;

contract ERC223 {
  uint public totalSupply;

  function totalSupply() constant returns(uint256 _supply);

  function name() constant returns(string _name);

  function symbol() constant returns(string _symbol);

  function decimals() constant returns(uint8 _decimals);

  function balanceOf(address _owner) constant returns(uint256 balance);

  function transferTo(address _to, uint _value) returns(bool);

  function transfer(address _to, uint _value, bytes _data) returns(bool);

  function tokenFallback(address _from, uint _value, bytes _data);

  event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data);
}
