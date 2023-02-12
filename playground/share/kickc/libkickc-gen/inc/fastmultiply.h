/// @file
/// Library Implementation of the Seriously Fast Multiplication
///
/// See http://codebase64.org/doku.php?id=base:seriously_fast_multiplication
/// Utilizes the fact that a*b = ((a+b)/2)^2 - ((a-b)/2)^2

/// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
void mulf_init();

/// Prepare for fast multiply with an unsigned char to a unsigned int result
void mulf8u_prepare(char a);

/// Calculate fast multiply with a prepared unsigned char to a unsigned int result
/// The prepared number is set by calling mulf8u_prepare(char a)
unsigned int mulf8u_prepared(char b);

/// Fast multiply two unsigned chars to a unsigned int result
unsigned int mulf8u(char a, char b);

/// Prepare for fast multiply with an signed char to a unsigned int result
inline void mulf8s_prepare(signed char a);

/// Calculate fast multiply with a prepared unsigned char to a unsigned int result
/// The prepared number is set by calling mulf8s_prepare(char a)
signed int mulf8s_prepared(signed char b);

/// Fast multiply two signed chars to a unsigned int result
signed int mulf8s(signed char a, signed char b);

/// Fast multiply two unsigned ints to a double unsigned int result
/// Done in assembler to utilize fast addition A+X
unsigned long mulf16u(unsigned int a, unsigned int b);

/// Fast multiply two signed ints to a signed double unsigned int result
/// Fixes offsets introduced by using unsigned multiplication
signed long mulf16s(signed int a, signed int b);