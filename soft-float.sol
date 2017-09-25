pragma solidity ^0.4.15;

contract SoftFloat {
  enum rm {float_rounding_mode, float_round_nearest_even, float_round_to_zero, float_round_up, float_round_down}
  rm floatRoundingMode;
  rm constant def_floatRoundingMode = rm.float_round_nearest_even;

  struct flags {
    bool underfow;
    bool overflow;
    bool inexact;
  }

  flags Flags;

  function setFloatRoundingMode(rm _rm) {
    floatRoundingMode = _rm;
  }

  function getFloatRoundingMode() returns(rm) {
    return floatRoundingMode;
  }
  
  // _sig is a denormalized signifacand of a subnormal of type f32
  function f32normalizeSubnormal(uint32 _sig) pure internal returns(uint8, uint32) {
    uint8 shiftcount = clz32(_sig) - 8;
    uint32 normalizedSig = _sig << shiftcount;
    uint8 normalizedExp = shiftcount;

    return (normalizedExp, normalizedSig);
  }

  // expects the value to be normalized a priori
  function f32pack(bool _sign, uint8 _exp, uint32 _sig) pure internal returns(uint32) {
    return (uint32(_sign ? 1 : 0) << 31) + (_exp << 23) + _sig;
  }

  function f32ExFrac(uint32 _f32) pure internal returns(uint32) {
    return _f32 & 0x007fffff;
  }

  function f32ExExpn(uint32 _f32) pure internal returns(uint8) {
    return uint8((_f32 << 23) & 0xff);
  }

  function f32ExSign(uint32 _f32) pure internal returns(bool) {
    return ((_f32 << 31) != 0);
  }

  function f32RoundPack(bool _sign, uint8 _exp, uint32 _sig) pure internal returns(uint32) {
    rm roundingMode;
    bool roundNearestEven;
    uint8 roundIncrement;
    uint8 roundBits;
    bool isTiny;

    roundingMode = def_floatRoundingMode;
    roundNearestEven = roundingMode == rm.float_round_nearest_even;
    roundIncrement = 0x40;

    if (!roundNearestEven) {
      if (roundingMode == rm.float_round_to_zero) {
        roundIncrement = 0;
      }
    } 
    else {
      roundIncrement = 0x7f;
      if (_sign) {
        if (roundingMode == rm.float_round_up) roundIncrement = 0;
      }
      else {
        if (roundingMode == rm.float_round_down) roundIncrement = 0;
      }
    }

    roundBits = uint8(_sig & 0x0000007f);
    if (0xfd <= _exp) {
      if ((0xfd < _exp) || ((_exp == 0xfd) && ((_sig + roundIncrement) < 0))) {
        Flags.overflow = true;
        Flags.inexact = true;
        return f32pack(_sign, 0xff, 0);
      }
    }
  }

  function f32NormalizeRoundPack(bool _sign, uint8 _exp, uint32 _sig) pure internal returns(uint32) {
    uint8 shiftcount = clz(_sig) -1;
    return f32RoundPack(_sign, _exp - shiftcount, _sig<<shiftcount);

  }

  function f64ExFrac(uint64 _f64) pure internal returns(uint64) {
    return _f64 & 0x000fffffffffffff;
  }

  function f64ExExpn(uint64 _f64) pure internal returns(uint16) {
    return uint16((_f64 >> 52) & 0x07ff);
  }

  function f64ExSign(uint64 _f64) pure internal returns(bool) {
    return ((_f64 >> 63) != 0);
  }

  function i32tof32(uint32 _uint32) pure internal returns(uint32) {}

  function i32tof64(uint32 _uint32) pure internal returns(uint64) {}

  function f32toi32(uint32 _f32) pure internal returns(uint32) {}

  function f32tof64(uint32 _f32) pure internal returns(uint64) {}

  function f64tofi32(uint64 _f64) pure internal returns(uint32) {}

  function f64tof32(uint64 _f64) pure internal returns(uint32) {}

  function f32adds(uint32 _f32_1, uint32 _f32_2) pure internal returns(uint32) {}

  function f32addu(uint32 _f32_1, uint32 _f32_2) pure internal returns(uint32) {}

  function f32subs(uint32 _f32_1, uint32 _f32_2) pure internal returns(uint32) {}

  function f32subu(uint32 _f32_1, uint32 _f32_2) pure internal returns(uint32) {}

  function f32mul(uint32 _f32_1, uint32 _f32_2) pure internal returns(uint32) {}

  function f32div(uint32 _f32_1, uint32 _f32_2) pure internal returns(uint32) {}

  function f32sqrt(uint32 _f32_1, uint32 _f32_2) pure internal returns(uint32) {}

  function f32eq(uint32 _f32_1, uint32 _f32_2) pure internal returns(uint32) {}

  function f32le(uint32 _f32_1, uint32 _f32_2) pure internal returns(uint32) {}

  function f32lt(uint32 _f32_1, uint32 _f32_2) pure internal returns(uint32) {}
  
  function popcnt32(uint32 r1) returns (uint8) {
    uint32 temp = r1;
    temp = (temp & 0x55555555) + ((temp >> 1) & 0x55555555);
    temp = (temp & 0x33333333) + ((temp >> 2) & 0x33333333);
    temp = (temp & 0x0f0f0f0f) + ((temp >> 4) & 0x0f0f0f0f);
    temp = (temp & 0x00ff00ff) + ((temp >> 8) & 0x00ff00ff);
    temp = (temp & 0x0000ffff) + ((temp >> 16) & 0x0000ffff);
    return uint8(temp);
  }

  function popcnt64(uint64 r1) returns (uint8) {
    uint64 temp = r1;
    temp = (temp & 0x5555555555555555) + ((temp >> 1) & 0x5555555555555555);
    temp = (temp & 0x3333333333333333) + ((temp >> 2) & 0x3333333333333333);
    temp = (temp & 0x0f0f0f0f0f0f0f0f) + ((temp >> 4) & 0x0f0f0f0f0f0f0f0f);
    temp = (temp & 0x00ff00ff00ff00ff) + ((temp >> 8) & 0x00ff00ff00ff00ff);
    temp = (temp & 0x0000ffff0000ffff) + ((temp >> 16) & 0x0000ffff0000ffff);
    temp = (temp & 0x00000000ffffffff) + ((temp >> 32) & 0x00000000ffffffff);
    return uint8(temp);
  }

  function clz32(uint32 r1) returns (uint8) {
    if (r1 == 0) return 32;
    uint32 temp_r1 = r1;
    uint8 n = 0;
    if (temp_r1 & 0xffff0000 == 0) {
      n += 16;
      temp_r1 = temp_r1 << 16;
    }
    if (temp_r1 & 0xff000000 == 0) {
      n += 8;
      temp_r1 = temp_r1 << 8;
    }
    if (temp_r1 & 0xf0000000 == 0) {
      n += 4;
      temp_r1 = temp_r1 << 4;
    }
    if (temp_r1 & 0xc0000000 == 0) {
      n += 2;
      temp_r1 = temp_r1 << 2;
    }
    if (temp_r1 & 0x8000000 == 0) {
      n++;
    }
    return n;
  }

  function clz64(uint64 r1) returns (uint8) {
    if (r1 == 0) return 64;
    uint64 temp_r1 = r1;
    uint8 n = 0;
    if (temp_r1 & 0xffffffff00000000 == 0) {
      n += 32;
      temp_r1 = temp_r1 << 32;
    }
    if (temp_r1 & 0xffff000000000000 == 0) {
      n += 16;
      temp_r1 == temp_r1 << 16;
    }
    if (temp_r1 & 0xff00000000000000 == 0) {
      n+= 8;
      temp_r1 = temp_r1 << 8;
    }
    if (temp_r1 & 0xf000000000000000 == 0) {
      n += 4;
      temp_r1 = temp_r1 << 4;
    }
    if (temp_r1 & 0xc000000000000000 == 0) {
      n += 2;
      temp_r1 = temp_r1 << 2;
    }
    if (temp_r1 & 0x8000000000000000 == 0) {
      n += 1;
    }
    return n;
  }

  function ctz32(uint32 r1) returns (uint8) {
    if (r1 == 0) return 32;
    uint32 temp_r1 = r1;
    uint8 n = 0;
    if (temp_r1 & 0x0000ffff == 0) {
      n += 16;
      temp_r1 = temp_r1 >> 16;
    }
    if (temp_r1 & 0x000000ff == 0) {
      n += 8;
      temp_r1 = temp_r1 >> 8;
    }
    if (temp_r1 & 0x0000000f == 0) {
      n += 4;
      temp_r1 = temp_r1 >> 4;
    }
    if (temp_r1 & 0x00000003 == 0) {
      n += 2;
      temp_r1 = temp_r1 >> 2;
    }
    if (temp_r1 & 0x00000001 == 0) {
      n += 1;
    }
    return n;
  }

  function ctz64(uint64 r1) returns (uint8) {
    if (r1 == 0) return 64;
    uint64 temp_r1 = r1;
    uint8 n = 0;
    if (temp_r1 & 0x00000000ffffffff == 0) {
      n += 32;
      temp_r1 = temp_r1 >> 32;
    }
    if (temp_r1 & 0x000000000000ffff == 0) {
      n += 16;
      temp_r1 = temp_r1 >> 16;
    }
    if (temp_r1 & 0x00000000000000ff == 0) {
      n += 8;
      temp_r1 = temp_r1 >> 8;
    }
    if (temp_r1 & 0x000000000000000f == 0) {
      n += 4;
      temp_r1 = temp_r1 >> 4;
    }
    if (temp_r1 & 0x0000000000000003 == 0) {
      n += 2;
      temp_r1 = temp_r1 >> 2;
    }
    if (temp_r1 & 0x0000000000000001 == 0) {
      n += 1;
    }
    return n;
  }
}
