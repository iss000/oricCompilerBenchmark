// Sine Generator functions using only multiplication, addition and bit shifting
// Uses a single division for converting the wavelength to a reciprocal.
// Generates sine using the series sin(x) = x - x^/3! + x^-5! - x^7/7! ...
// Uses the approximation sin(x) = x - x^/6 + x^/128
// Optimization possibility: Use symmetries when generating sine tables. wavelength%2==0 -> mirror symmetry over PI, wavelength%4==0 -> mirror symmetry over PI/2.

#include <sine.h>
#include <division.h>
#include <multiply.h>

// PI*2 in u[4.28] format
const unsigned long PI2_u4f28 = $6487ed51;
// PI in u[4.28] format
const unsigned long PI_u4f28 = $3243f6a9;
// PI/2 in u[4.28] format
const unsigned long PI_HALF_u4f28 = $1921FB54;

// PI*2 in u[4.12] format
const unsigned int PI2_u4f12 = $6488;
// PI in u[4.12] format
const unsigned int PI_u4f12 = $3244;
// PI/2 in u[4.12] format
const unsigned int PI_HALF_u4f12 = $1922;

// Generate signed (large) unsigned int sine table - on the full -$7fff - $7fff range
// sintab - the table to generate into
// wavelength - the number of sine points in a total sine wavelength (the size of the table)
void sin16s_gen(signed int* sintab, unsigned int wavelength) {
    // u[4.28] step = PI*2/wavelength
    unsigned long step = div32u16u(PI2_u4f28, wavelength); // u[4.28]
    // Iterate over the table
    unsigned long x = 0; // u[4.28]
    for( unsigned int i=0; i<wavelength; i++) {
        *sintab++ = sin16s(x);
        x = x + step;
    }
}

// Generate signed int sine table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sine points in a total sine wavelength (the size of the table)
void sin16s_gen2(signed int* sintab, unsigned int wavelength, signed int min, signed int max) {
    signed int ampl = max-min;
    signed int offs = min + ampl>>1; // ampl is always positive so shifting left does not alter the sign
    // u[4.28] step = PI*2/wavelength
    unsigned long step = div32u16u(PI2_u4f28, wavelength); // u[4.28]
    // Iterate over the table
    unsigned long x = 0; // u[4.28]
    for( unsigned int i=0; i<wavelength; i++) {
        *sintab++ = offs + (signed int)WORD1(mul16s(sin16s(x), ampl)); // The signed sin() has values [-7fff;7fff] = [-1/2 ; 1/2], so ampl*sin has the right amplitude
        x = x + step;
    }
}

// Generate signed char sine table - on the full -$7f - $7f range
// sintab - the table to generate into
// wavelength - the number of sine points in a total sine wavelength (the size of the table)
void sin8s_gen(signed char* sintab, unsigned int wavelength) {
    // u[4.28] step = PI*2/wavelength
    unsigned int step = div16u(PI2_u4f12, wavelength); // u[4.12]
    // Iterate over the table
    unsigned int x = 0; // u[4.12]
    for( unsigned int i=0; i<wavelength; i++) {
        *sintab++ = sin8s(x);
        x = x + step;
    }
}

// Calculate signed int sine sin(x)
// x: unsigned long input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed int sin(x) s[0.15] - using the full range  -$7fff - $7fff
signed int sin16s(unsigned long x) {
    // Move x1 into the range 0-PI/2 using sine mirror symmetries
    char isUpper = 0;
    if(x >= PI_u4f28 ) {
        x = x - PI_u4f28;
        isUpper = 1;
    }
    if(x >= PI_HALF_u4f28 ) {
        x = PI_u4f28 - x;
    }
    // sinx = x - x^3/6 + x5/128;
    unsigned int x1 = WORD1(x<<3); // u[1.15]
    unsigned int x2 = mulu16_sel(x1, x1, 0); // u[2.14] x^2
    unsigned int x3 = mulu16_sel(x2, x1, 1); // u[2.14] x^3
    unsigned int x3_6 = mulu16_sel(x3, $10000/6, 1);  // u[1.15] x^3/6;
    unsigned int usinx = x1 - x3_6; // u[1.15] x - x^3/6
    unsigned int x4 = mulu16_sel(x3, x1, 0); // u[3.13] x^4
    unsigned int x5 = mulu16_sel(x4, x1, 0); // u[4.12] x^5
    unsigned int x5_128 = x5>>4; // // u[1.15] x^5/128 -- much more efficient than mul_u16_sel(x5, $10000/128, 3);
    usinx = usinx + x5_128; // u[1.15] (first bit is always zero)
    signed int sinx = (signed int)usinx; // s[0.15]
    if(isUpper!=0) {
        sinx = -(signed int)usinx; // s[0.15];
     }
     return sinx;
}

// Calculate signed char sine sin(x)
// x: unsigned int input u[4.12] in the interval $0000 - PI2_u4f12
// result: signed char sin(x) s[0.7] - using the full range  -$7f - $7f
signed char sin8s(unsigned int x) {
    // Move x1 into the range 0-PI/2 using sine mirror symmetries
    char isUpper = 0;
    if(x >= PI_u4f12 ) {
        x = x - PI_u4f12;
        isUpper = 1;
    }
    if(x >= PI_HALF_u4f12 ) {
        x = PI_u4f12 - x;
    }
    // sinx = x - x^3/6 + x5/128;
    char x1 = BYTE1(x<<3); // u[1.7]
    char x2 = mulu8_sel(x1, x1, 0); // u[2.6] x^2
    char x3 = mulu8_sel(x2, x1, 1); // u[2.6] x^3
    const char DIV_6 = $2b; // u[0.7] - $2a.aa rounded to $2b
    char x3_6 = mulu8_sel(x3, DIV_6, 1);  // u[1.7] x^3/6;
    char usinx = x1 - x3_6; // u[1.7] x - x^3/6
    char x4 = mulu8_sel(x3, x1, 0); // u[3.5] x^4
    char x5 = mulu8_sel(x4, x1, 0); // u[4.4] x^5
    char x5_128 = x5>>4; // // u[1.7] x^5/128 -- much more efficient than mul_u16_sel(x5, $10000/128, 3);
    usinx = usinx + x5_128; // u[1.7] (first bit is always zero)
    if(usinx>=128) { usinx--; } // rounding may occasionally result in $80 - lower into range ($00-$7f)
    signed char sinx = (signed char)usinx; // s[0.7]
    if(isUpper!=0) {
        sinx = -(signed char)usinx; // s[0.7];
    }
    return sinx;
}

// Calculate val*val for two unsigned int values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
unsigned int mulu16_sel(unsigned int v1, unsigned int v2, char select) {
    return WORD1(mul16u(v1, v2)<<select);
}

// Calculate val*val for two unsigned char values - the result is 8 selected bits of the 16-bit result.
// The select parameter indicates how many of the highest bits of the 16-bit result to skip
char mulu8_sel(char v1, char v2, char select) {
    return BYTE1(mul8u(v1, v2)<<select);
}
