// Library Implementation of the Seriously Fast Multiplication
// See http://codebase64.org/doku.php?id=base:seriously_fast_multiplication
// Utilizes the fact that a*b = ((a+b)/2)^2 - ((a-b)/2)^2

#include <fastmultiply.h>

// mulf_sqr tables will contain f(x)=int(x*x/4) and g(x) = f(x-255).
// <f(x) = <(( x * x )/4)
char __align(0x100) mulf_sqr1_lo[512];
// >f(x) = >(( x * x )/4)
char __align(0x100) mulf_sqr1_hi[512];
// <g(x) =  <((( x - 255) * ( x - 255 ))/4)
char __align(0x100) mulf_sqr2_lo[512];
// >g(x) = >((( x - 255) * ( x - 255 ))/4)
char __align(0x100) mulf_sqr2_hi[512];

// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
void mulf_init() {
  // Fill mulf_sqr1 = f(x) = int(x*x/4): If f(x) = x*x/4 then f(x+1) = f(x) + x/2 + 1/4
  unsigned int sqr = 0; // sqr = (x*x)/4
  char x_2 = 0; // x/2
  char c = 0;   // Counter used for determining x%2==0
  char* sqr1_hi = mulf_sqr1_hi+1;
  for(char* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++) {
    if((++c&1)==0) {
        x_2++; // increase i/2 on even numbers
        sqr++; // sqr++ on even numbers because 1 = 2*1/4 (from the two previous numbers) + 1/2 (half of the previous uneven number)
    }
    *sqr1_lo = BYTE0(sqr);
    *sqr1_hi++ = BYTE1(sqr);
    sqr = sqr + x_2; // sqr = sqr + i/2 (when uneven the 1/2 is not added here - see above)
  }
  // Fill mulf_sqr2 = g(x) = f(x-255) : If x-255<0 then g(x)=f(255-x) (because x*x = -x*-x)
  // g(0) = f(255), g(1) = f(254), ..., g(254) = f(1), g(255) = f(0), g(256) = f(1), ..., g(510) = f(255), g(511) = f(256)
  char x_255 = (char)-1; //Start with g(0)=f(255)
  char dir = 0xff;  // Decrease or increase x_255 - initially we decrease
  char* sqr2_hi = mulf_sqr2_hi;
  for(char* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++) {
    *sqr2_lo = mulf_sqr1_lo[x_255];
    *sqr2_hi++ = mulf_sqr1_hi[x_255];
    x_255 = x_255 + dir;
    if(x_255==0) {
      dir = 1; // when x_255=0 then start counting up
    }
  }
  // Set the very last value g(511) = f(256)
  *(mulf_sqr2_lo+511) = *(mulf_sqr1_lo+256);
  *(mulf_sqr2_hi+511) = *(mulf_sqr1_hi+256);
}

// Prepare for fast multiply with an unsigned char to a unsigned int result
void mulf8u_prepare(char a) {
    char* const memA = (char*)0xfd;
    *memA = a;
    asm {
        lda memA
        sta mulf8u_prepared.sm1+1
        sta mulf8u_prepared.sm3+1
        eor #$ff
        sta mulf8u_prepared.sm2+1
        sta mulf8u_prepared.sm4+1
    }
}

// Calculate fast multiply with a prepared unsigned char to a unsigned int result
// The prepared number is set by calling mulf8u_prepare(char a)
unsigned int mulf8u_prepared(char b) {
    char* const resL = (char*)0xfe;
    char* const memB = (char*)0xff;
    *memB = b;
    asm {
        ldx memB
        sec
    sm1:
        lda mulf_sqr1_lo,x
    sm2:
        sbc mulf_sqr2_lo,x
        sta resL
    sm3:
        lda mulf_sqr1_hi,x
    sm4:
        sbc mulf_sqr2_hi,x
        sta memB
    }
    return MAKEWORD( *memB, *resL );
}

// Fast multiply two unsigned chars to a unsigned int result
unsigned int mulf8u(char a, char b) {
    mulf8u_prepare(a);
    return mulf8u_prepared(b);
}

// Prepare for fast multiply with an signed char to a unsigned int result
inline void mulf8s_prepare(signed char a) {
    mulf8u_prepare((char)a);
}

// Calculate fast multiply with a prepared unsigned char to a unsigned int result
// The prepared number is set by calling mulf8s_prepare(char a)
signed int mulf8s_prepared(signed char b) {
    signed char* const memA = (signed char*)0xfd;
    unsigned int m = mulf8u_prepared((char) b);
    if(*memA<0) {
        BYTE1(m) = BYTE1(m)-(char)b;
    }
    if(b<0) {
        BYTE1(m) = BYTE1(m)-(char)*memA;
    }
    return (signed int)m;
}

// Fast multiply two signed chars to a unsigned int result
signed int mulf8s(signed char a, signed char b) {
    mulf8s_prepare(a);
    return mulf8s_prepared(b);
}

// Fast multiply two unsigned ints to a double unsigned int result
// Done in assembler to utilize fast addition A+X
unsigned long mulf16u(unsigned int a, unsigned int b) {
    unsigned int* const memA = (unsigned int*)0xf8;
    unsigned int* const memB = (unsigned int*)0xfa;
    unsigned long* const memR = (unsigned long*)0xfc;
    *memA = a;
    *memB = b;
    asm {
        lda memA
        sta sm1a+1
        sta sm3a+1
        sta sm5a+1
        sta sm7a+1
        eor #$ff
        sta sm2a+1
        sta sm4a+1
        sta sm6a+1
        sta sm8a+1
        lda memA+1
        sta sm1b+1
        sta sm3b+1
        sta sm5b+1
        sta sm7b+1
        eor #$ff
        sta sm2b+1
        sta sm4b+1
        sta sm6b+1
        sta sm8b+1
        ldx memB
        sec
sm1a:   lda mulf_sqr1_lo,x
sm2a:   sbc mulf_sqr2_lo,x
        sta memR+0
sm3a:   lda mulf_sqr1_hi,x
sm4a:   sbc mulf_sqr2_hi,x
        sta _AA+1
        sec
sm1b:   lda mulf_sqr1_lo,x
sm2b:   sbc mulf_sqr2_lo,x
        sta _cc+1
sm3b:   lda mulf_sqr1_hi,x
sm4b:   sbc mulf_sqr2_hi,x
        sta _CC+1
        ldx memB+1
        sec
sm5a:   lda mulf_sqr1_lo,x
sm6a:   sbc mulf_sqr2_lo,x
        sta _bb+1
sm7a:   lda mulf_sqr1_hi,x
sm8a:   sbc mulf_sqr2_hi,x
        sta _BB+1
        sec
sm5b:   lda mulf_sqr1_lo,x
sm6b:   sbc mulf_sqr2_lo,x
        sta _dd+1
sm7b:   lda mulf_sqr1_hi,x
sm8b:   sbc mulf_sqr2_hi,x
        sta memR+3
        clc
_AA:    lda #0
_bb:    adc #0
        sta memR+1
_BB:    lda #0
_CC:    adc #0
        sta memR+2
        bcc !+
        inc memR+3
        clc
!:
_cc:    lda #0
        adc memR+1
        sta memR+1
_dd:    lda #0
        adc memR+2
        sta memR+2
        bcc !+
        inc memR+3
!:
    }
    return *memR;
}

// Fast multiply two signed ints to a signed double unsigned int result
// Fixes offsets introduced by using unsigned multiplication
signed long mulf16s(signed int a, signed int b) {
    unsigned long m = mulf16u((unsigned int)a, (unsigned int)b);
    if(a<0) {
        WORD1(m) = WORD1(m)-(unsigned int)b;
    }
    if(b<0) {
        WORD1(m) = WORD1(m)-(unsigned int)a;
    }
    return (signed long)m;
}
