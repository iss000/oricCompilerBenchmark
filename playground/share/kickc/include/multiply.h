/// @file
/// Simple binary multiplication implementation

/// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
unsigned int mul8u(char a, char b);

/// Multiply of two signed chars to a signed int
/// Fixes offsets introduced by using unsigned multiplication
int mul8s(signed char a, signed char b);

/// Multiply a signed char and an unsigned char (into a signed int)
/// Fixes offsets introduced by using unsigned multiplication
int mul8su(signed char a, char b);

/// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned double unsigned int
unsigned long mul16u(unsigned int a, unsigned int b);

/// Multiply of two signed ints to a signed double unsigned int
/// Fixes offsets introduced by using unsigned multiplication
signed long mul16s(int a, int b);