// Simple binary multiplication implementation

#include <multiply.h>

// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
unsigned int mul8u(char a, char b) {
    unsigned int res = 0;
    unsigned int mb = b;
    while(a!=0) {
        if( (a&1) != 0) {
            res = res + mb;
        }
        a = a>>1;
        mb = mb<<1;
    }
    return res;
}

// Multiply of two signed chars to a signed int
// Fixes offsets introduced by using unsigned multiplication
signed int mul8s(signed char a, signed char b) {
    unsigned int m = mul8u((char)a, (char) b);
    if(a<0) {
        BYTE1(m) = BYTE1(m)-(char)b;
    }
    if(b<0) {
        BYTE1(m) = BYTE1(m)-(char)a;
    }
    return (signed int)m;
}

// Multiply a signed char and an unsigned char (into a signed int)
// Fixes offsets introduced by using unsigned multiplication
signed int mul8su(signed char a, char b) {
    unsigned int m = mul8u((char)a, (char) b);
    if(a<0) {
        BYTE1(m) = BYTE1(m)-(char)b;
    }
    return (signed int)m;
}

// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
unsigned long mul16u(unsigned int a, unsigned int b) {
    unsigned long res = 0;
    unsigned long mb = b;
    while(a!=0) {
        if( (a&1) != 0) {
            res = res + mb;
        }
        a = a>>1;
        mb = mb<<1;
    }
    return res;
}

// Multiply of two signed ints to a signed long
// Fixes offsets introduced by using unsigned multiplication
signed long mul16s(signed int a, signed int b) {
    unsigned long m = mul16u((unsigned int)a, (unsigned int) b);
    if(a<0) {
        WORD1(m) = WORD1(m)-(unsigned int)b;
    }
    if(b<0) {
        WORD1(m) = WORD1(m)-(unsigned int)a;
    }
    return (signed long)m;
}
