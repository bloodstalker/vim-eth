pragma solidity^0.4.0;

contract Salsa8 {
    uint constant m0 = 0x100000000000000000000000000000000000000000000000000000000;
    uint constant m1 = 0x1000000000000000000000000000000000000000000000000;
    uint constant m2 = 0x010000000000000000000000000000000000000000;
    uint constant m3 = 0x100000000000000000000000000000000;
    uint constant m4 = 0x1000000000000000000000000;
    uint constant m5 = 0x10000000000000000;
    uint constant m6 = 0x100000000;
    uint constant m7 = 0x1;

    uint32 constant fm7 = 0x61707865;
    uint32 constant fm6 = 0x04030201;
    uint32 constant fm5 = 0x08070605;
    uint32 constant fm4 = 0x0c0b0a09;
    uint32 constant fm3 = 0x100f0e0d;
    uint32 constant fm2 = 0x3320646e;
    uint32 constant fm1 = 0x01040103;
    uint32 constant fm0 = 0x06020905;
    uint32 constant sm7 = 0x00000007;
    uint32 constant sm6 = 0x00000000;
    uint32 constant sm5 = 0x79622d32;
    uint32 constant sm4 = 0x14131211;
    uint32 constant sm3 = 0x18171615;
    uint32 constant sm2 = 0x1c1b1a19;
    uint32 constant sm1 = 0x201f1e1d;
    uint32 constant sm0 = 0x6b206574;

    function getsm0() constant returns(uint32) {
      return sm0;
    }

    function quarter(uint32 y0, uint32 y1, uint32 y2, uint32 y3)
       constant returns (uint32, uint32, uint32, uint32)
    {
        uint32 t;
        t = y0 + y3;
        y1 = y1 ^ ((t * 2**7) | (t / 2**(32-7)));
        t = y1 + y0;
        y2 = y2 ^ ((t * 2**9) | (t / 2**(32-9)));
        t = y2 + y1;
        y3 = y3 ^ ((t * 2**13) | (t / 2**(32-13)));
        t = y3 + y2;
        y0 = y0 ^ ((t * 2**18) | (t / 2**(32-18)));
        return (y0, y1, y2, y3);        
    }

    function get(uint data, uint word) constant returns (uint32 x)
    {
        return uint32(data / 2**(256 - word * 32 - 32));
    }

    function put(uint x, uint word) constant returns (uint) {
        return x * 2**(256 - word * 32 - 32);
    }

    function rowround(uint first, uint second) constant returns (uint f, uint s)
    {
        var (a,b,c,d) = quarter(uint32(first / m0), uint32(first / m1), uint32(first / m2), uint32(first / m3));
        f = (((((uint(a) * 2**32) | uint(b)) * 2 ** 32) | uint(c)) * 2**32) | uint(d);
        (b,c,d,a) = quarter(uint32(first / m5), uint32(first / m6), uint32(first / m7), uint32(first / m4));
        f = (((((((f * 2**32) | uint(a)) * 2**32) | uint(b)) * 2 ** 32) | uint(c)) * 2**32) | uint(d);
        (c,d,a,b) = quarter(uint32(second / m2), uint32(second / m3), uint32(second / m0), uint32(second / m1));
        s = (((((uint(a) * 2**32) | uint(b)) * 2 ** 32) | uint(c)) * 2**32) | uint(d);
        (d,a,b,c) = quarter(uint32(second / m7), uint32(second / m4), uint32(second / m5), uint32(second / m6));
        s = (((((((s * 2**32) | uint(a)) * 2**32) | uint(b)) * 2 ** 32) | uint(c)) * 2**32) | uint(d);
    }

    function columnround(uint first, uint second) constant returns (uint f, uint s)
    {
        var (a,b,c,d) = quarter(uint32(first / m0), uint32(first / m4), uint32(second / m0), uint32(second / m4));
        f = (uint(a) * m0) | (uint(b) * m4);
        s = (uint(c) * m0) | (uint(d) * m4);
        (a,b,c,d) = quarter(uint32(first / m5), uint32(second / m1), uint32(second / m5), uint32(first / m1));
        f |= (uint(a) * m5) | (uint(d) * m1);
        s |= (uint(b) * m1) | (uint(c) * m5);
        (a,b,c,d) = quarter(uint32(second / m2), uint32(second / m6), uint32(first / m2), uint32(first / m6));
        f |= (uint(c) * m2) | (uint(d) * m6);
        s |= (uint(a) * m2) | (uint(b) * m6);
        (a,b,c,d) = quarter(uint32(second / m7), uint32(first / m3), uint32(first / m7), uint32(second / m3));
        f |= (uint(b) * m3) | (uint(c) * m7);
        s |= (uint(a) * m7) | (uint(d) * m3);
    }

    function salsa20_20(uint _first, uint _second) constant returns (uint rfirst, uint rsecond) {
        uint first = _first;
        uint second = _second;
        for (uint i = 0; i < 8; i += 2)
        {
            (first, second) = columnround(first, second);
            (first, second) = rowround(first, second);
        }
        for (i = 0; i < 8; i++)
        {
            rfirst |= put(get(_first, i) + get(first, i), i);
            rsecond |= put(get(_second, i) + get(second, i), i);
        }
    }

}
