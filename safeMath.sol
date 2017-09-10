pragma solidity^0.4.0;

library SafeMath {
  function mul(uint256 __arg1, uint256 __arg2) returns(uint256) {
    uint256 res = __arg1 * __arg2;
    assert(__arg1 == 0 || res / __arg1 == __arg2);
    return res;
  }

  function div(uint256 __arg1, uint256 __arg2) returns(uint256) {
    uint256 res = __arg1 / __arg2;
    return res;
  }

  function sub(uint256 __arg1, uint256 __arg2) returns(uint256) {
    assert(__arg2 <= __arg1);
    return __arg1 - __arg2;
  }
  
  function add(uint256 __arg1, uint256 __arg2) returns(uint256) {
    uint256 res = __arg1 + __arg2;
    assert(res > __arg1);
    return res;
  }
}
