// Table-based implementation of integer square sqr() and square root sqrt()

#include <sqr.h>
#include <stdlib.h>

// The number of squares to pre-calculate. Limits what values sqr() can calculate and the result of sqrt()
char NUM_SQUARES = 0xff;

// Squares for each char value SQUARES[i] = i*i
// Initialized by init_squares()
unsigned int* SQUARES;

// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
void init_squares() {
    SQUARES = malloc(NUM_SQUARES*sizeof(unsigned int));
    unsigned int* squares = SQUARES;
    unsigned int sqr = 0;
    for(char i=0;i<NUM_SQUARES;i++) {
        *squares++ = sqr;
        sqr += i*2+1;
    }
}

// Find the square of a char value
// Uses a table of squares that must be initialized by calling init_squares()
unsigned int sqr(char val) {
    return SQUARES[val];
}

// Find the (integer) square root of a unsigned int value
// If the square is not an integer then it returns the largest integer N where N*N <= val
// Uses a table of squares that must be initialized by calling init_squares()
char sqrt(unsigned int val) {
    unsigned int* found = bsearch16u(val, SQUARES, NUM_SQUARES);
    char sq = (char)(found-SQUARES);
    return sq;
}
