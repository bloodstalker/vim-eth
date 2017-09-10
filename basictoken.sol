pragma solidity^0.4.0;

import './safeMath.sol';

contract base {
  function Transfer(address __ad1, address __ad2, uint256 _value) {
  }

}

contract basicToken is base {
  using SafeMath for uint256;
  mapping(address => uint256) balances;

  function Transfer(address _to, uint256 _value) returns (bool) {
    require(_to != address(0));
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function balanceOf(address _owner) returns(uint256 balance) {
    return balances[_owner];
  }
}
