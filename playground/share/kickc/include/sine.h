/// @file
/// Sine Generator functions using only multiplication, addition and bit shifting
///
/// Uses a single division for converting the wavelength to a reciprocal.
/// Generates sine using the series sin(x) = x - x^/3! + x^-5! - x^7/7! ...
/// Uses the approximation sin(x) = x - x^/6 + x^/128
/// Optimization possibility: Use symmetries when generating sine tables. wavelength%2==0 -> mirror symmetry over PI, wavelength%4==0 -> mirror symmetry over PI/2.

/// PI*2 in u[4.28] format
extern const unsigned long PI2_u4f28;
/// PI in u[4.28] format
extern const unsigned long PI_u4f28;
/// PI/2 in u[4.28] format
extern const unsigned long PI_HALF_u4f28;

/// PI*2 in u[4.12] format
extern const unsigned int PI2_u4f12;
/// PI in u[4.12] format
extern const unsigned int PI_u4f12;
/// PI/2 in u[4.12] format
extern const unsigned int PI_HALF_u4f12;

/// Generate signed (large) unsigned int sine table - on the full -$7fff - $7fff range
/// @param sintab the table to generate into
/// @param wavelength the number of sine points in a total sine wavelength (the size of the table)
void sin16s_gen(int* sintab, unsigned int wavelength);

/// Generate signed int sine table - with values in the range min-max.
/// @param sintab the table to generate into
/// @param wavelength the number of sine points in a total sine wavelength (the size of the table)
void sin16s_gen2(int* sintab, unsigned int wavelength, int min, int max);

/// Generate signed char sine table - on the full -$7f - $7f range
/// @param sintab the table to generate into
/// @param wavelength the number of sine points in a total sine wavelength (the size of the table)
void sin8s_gen(signed char*  sintab, unsigned int wavelength);

/// Calculate signed int sine sin(x)
/// @param x unsigned long input u[4.28] in the interval $00000000 - PI2_u4f28
/// @return signed int sin(x) s[0.15] - using the full range  -$7fff - $7fff
int sin16s(unsigned long x);

/// Calculate signed char sine sin(x)
/// @param x unsigned int input u[4.12] in the interval $0000 - PI2_u4f12
/// @return signed char sin(x) s[0.7] - using the full range  -$7f - $7f
signed char sin8s(unsigned int x);

/// Calculate val*val for two unsigned int values - the result is 16 selected bits of the 32-bit result.
/// The select parameter indicates how many of the highest bits of the 32-bit result to skip
unsigned int mulu16_sel(unsigned int v1, unsigned int v2, char select);

/// Calculate val*val for two unsigned char values - the result is 8 selected bits of the 16-bit result.
/// The select parameter indicates how many of the highest bits of the 16-bit result to skip
char mulu8_sel(char v1, char v2, char select);