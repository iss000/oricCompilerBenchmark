/// @file
/// Table-based implementation of integer square sqr() and square root sqrt()

/// Initialize squares table
/// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
void init_squares();

/// Find the square of a char value
/// Uses a table of squares that must be initialized by calling init_squares()
unsigned int sqr(char val);

/// Find the (integer) square root of a unsigned int value
/// If the square is not an integer then it returns the largest integer N where N*N <= val
/// Uses a table of squares that must be initialized by calling init_squares()
char sqrt(unsigned int val);
