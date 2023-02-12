/// @file
/// Simple binary division implementation
///
/// Follows the C99 standard by truncating toward zero on negative results.
/// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5

/// Remainder after signed 8 bit division
extern char rem8u;

/// Performs division on two 8 bit unsigned chars
/// Returns dividend/divisor.
/// The remainder will be set into the global variable rem8u
/// Implemented using simple binary division
char div8u(char dividend, char divisor);

/// Performs division on two 8 bit unsigned chars and an initial remainder
/// Returns dividend/divisor.
/// The final remainder will be set into the global variable rem8u
/// Implemented using simple binary division
char divr8u(char dividend, char divisor, char rem);

/// Divide unsigned 16-bit unsigned long dividend with a 8-bit unsigned char divisor
/// The 8-bit unsigned char remainder can be found in rem8u after the division
unsigned int div16u8u(unsigned int dividend, unsigned char divisor);

/// Remainder after unsigned 16-bit division
extern unsigned int rem16u;

/// Performs division on two 16 bit unsigned ints and an initial remainder
/// Returns the quotient dividend/divisor.
/// The final remainder will be set into the global variable rem16u
/// Implemented using simple binary division
unsigned int divr16u(unsigned int dividend, unsigned int divisor, unsigned int rem);

/// Performs modulo on two 16 bit unsigned ints and an initial remainder
/// Returns the remainder.
/// Implemented using simple binary division
unsigned int modr16u(unsigned int dividend, unsigned int divisor, unsigned int rem);

/// Performs division on two 16 bit unsigned ints
/// Returns the quotient dividend/divisor.
/// The remainder will be set into the global variable rem16u
/// Implemented using simple binary division
unsigned int div16u(unsigned int dividend, unsigned int divisor);

/// Divide unsigned 32-bit unsigned long dividend with a 16-bit unsigned int divisor
/// The 16-bit unsigned int remainder can be found in rem16u after the division
unsigned long div32u16u(unsigned long dividend, unsigned int divisor);

/// Remainder after signed 8 bit division
extern signed char rem8s;

/// Perform division on two signed 8-bit numbers
/// Returns dividend/divisor.
/// The remainder will be set into the global variable rem8s.
/// Implemented using simple binary division
/// Follows the C99 standard by truncating toward zero on negative results.
/// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
signed char div8s(signed char dividend, signed char divisor);

/// Remainder after signed 16 bit division
extern int rem16s;

/// Perform division on two signed 16-bit numbers with an initial remainder.
/// Returns dividend/divisor. The remainder will be set into the global variable rem16s.
/// Implemented using simple binary division
/// Follows the C99 standard by truncating toward zero on negative results.
/// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
int divr16s(int dividend, int divisor, int rem);

/// Perform division on two signed 16-bit numbers
/// Returns dividend/divisor.
/// The remainder will be set into the global variable rem16s.
/// Implemented using simple binary division
/// Follows the C99 standard by truncating toward zero on negative results.
/// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
int div16s(int dividend, int divisor);
