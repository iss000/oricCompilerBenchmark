// Simple binary division implementation
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5

#include <division.h>

// Remainder after signed 8 bit division
char rem8u =0;

// Performs division on two 8 bit unsigned chars
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8u
// Implemented using simple binary division
char div8u(char dividend, char divisor) {
    return divr8u(dividend, divisor, 0);
}

// Performs division on two 8 bit unsigned chars and an initial remainder
// Returns dividend/divisor.
// The final remainder will be set into the global variable rem8u
// Implemented using simple binary division
char divr8u(char dividend, char divisor, char rem) {
    char quotient = 0;
    for( char i : 0..7) {
        rem = rem << 1;
        if( (dividend & $80) != 0 ) {
            rem = rem | 1;
        }
        dividend = dividend << 1;
        quotient = quotient << 1;
        if(rem>=divisor) {
            quotient++;
            rem = rem - divisor;
        }
    }
    rem8u = rem;
    return quotient;
}

// Divide unsigned 16-bit unsigned long dividend with a 8-bit unsigned char divisor
// The 8-bit unsigned char remainder can be found in rem8u after the division
unsigned int div16u8u(unsigned int dividend, unsigned char divisor) {
  unsigned char quotient_hi = divr8u(BYTE1(dividend), divisor, 0);
  unsigned char quotient_lo = divr8u(BYTE0(dividend), divisor, rem8u);
  unsigned int quotient = MAKEWORD( quotient_hi, quotient_lo );
  return quotient;
}

// Remainder after unsigned 16-bit division
unsigned int rem16u = 0;

// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
unsigned int divr16u(unsigned int dividend, unsigned int divisor, unsigned int rem) {
    unsigned int quotient = 0;
    for( char i : 0..15) {
        rem = rem << 1;
        if( (BYTE1(dividend) & $80) != 0 ) {
            rem = rem | 1;
        }
        dividend = dividend << 1;
        quotient = quotient << 1;
        if(rem>=divisor) {
            quotient++;
            rem = rem - divisor;
        }
    }
    rem16u = rem;
    return quotient;
}

// Performs modulo on two 16 bit unsigned ints and an initial remainder
// Returns the remainder.
// Implemented using simple binary division
unsigned int modr16u(unsigned int dividend, unsigned int divisor, unsigned int rem) {
    divr16u(dividend, divisor, rem);
    return rem16u;
}

// Performs division on two 16 bit unsigned ints
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
unsigned int div16u(unsigned int dividend, unsigned int divisor) {
    return divr16u(dividend, divisor, 0);
}

// Divide unsigned 32-bit unsigned long dividend with a 16-bit unsigned int divisor
// The 16-bit unsigned int remainder can be found in rem16u after the division
unsigned long div32u16u(unsigned long dividend, unsigned int divisor) {
  unsigned int quotient_hi = divr16u(WORD1(dividend), divisor, 0);
  unsigned int quotient_lo = divr16u(WORD0(dividend), divisor, rem16u);
  unsigned long quotient = MAKELONG( quotient_hi, quotient_lo );
  return quotient;
}

// Remainder after signed 8 bit division
signed char rem8s = 0;

// Perform division on two signed 8-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
signed char div8s(signed char dividend, signed char divisor) {
    char neg = 0;
    char dividendu = 0;
    if(dividend<0) {
      dividendu = (char)-dividend;
      neg = 1;
    } else {
      dividendu = (char)dividend;
    }
    char divisoru = 0;
    if(divisor<0) {
        divisoru = (char)-divisor;
        neg = neg ^ 1;
    } else {
        divisoru = (char)divisor;
    }
    char resultu = div8u(dividendu, divisoru);
    if(neg==0) {
        rem8s = (signed char)rem8u;
        return (signed char)resultu;
    } else {
        rem8s = -(signed char)rem8u;
        return -(signed char)resultu;
    }
}

// Remainder after signed 16 bit division
signed int rem16s = 0;

// Perform division on two signed 16-bit numbers with an initial remainder.
// Returns dividend/divisor. The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
signed int divr16s(signed int dividend, signed int divisor, signed int rem) {
    char neg = 0;
    unsigned int dividendu = 0;
    unsigned int remu = 0;
    if(dividend<0 || rem<0) {
      dividendu = (unsigned int)-dividend;
      remu = (unsigned int)-rem;
      neg = 1;
    } else {
      dividendu = (unsigned int)dividend;
      remu = (unsigned int)rem;
    }
    unsigned int divisoru = 0;
    if(divisor<0) {
        divisoru = (unsigned int)-divisor;
        neg = neg ^ 1;
    } else {
        divisoru = (unsigned int)divisor;
    }
    unsigned int resultu = divr16u(dividendu, divisoru, remu);
    if(neg==0) {
        rem16s = (signed int)rem16u;
        return (signed int)resultu;
    } else {
        rem16s = -(signed int)rem16u;
        return -(signed int)resultu;
    }
}

// Perform division on two signed 16-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
signed int div16s(signed int dividend, signed int divisor) {
    return divr16s(dividend, divisor, 0);
}
