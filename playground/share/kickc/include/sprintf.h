#include <printf.h>

/// Composes a string with the same text that would be printed if format was used on printf(),
/// but instead of being printed, the content is stored as a C string in the buffer pointed by s
/// (taking n as the maximum buffer capacity to fill).
/// @param s Pointer to a buffer where the resulting C-string is stored. The buffer should have a size of at least n characters.
/// @param n Maximum number of bytes to be used in the buffer. The generated string has a length of at most n-1, leaving space for the additional terminating null character.
/// @param format C string that contains a format string that follows the same specifications as format in printf (see printf for details).
/// @param ...  Depending on the format string, the function may expect a sequence of additional arguments, each containing a value to be used to replace a format specifier in the format string (or a pointer to a storage location, for n).
/// There should be at least as many of these arguments as the number of values specified in the format specifiers. Additional arguments are ignored by the function.
/// @return The number of characters that would have been written if n had been sufficiently large, not counting the terminating null character.
/// Notice that only when this returned value is non-negative and less than n, the string has been completely written.
int snprintf ( char * s, size_t n, const char * format, ... );

/// Composes a string with the same text that would be printed if format was used on printf(),
/// but instead of being printed, the content is stored as a C string in the buffer pointed by s
/// @param s Pointer to a buffer where the resulting C-string is stored. The buffer should have a size of at least n characters.
/// @param format C string that contains a format string that follows the same specifications as format in printf (see printf for details).
/// @param ...  Depending on the format string, the function may expect a sequence of additional arguments, each containing a value to be used to replace a format specifier in the format string (or a pointer to a storage location, for n).
/// There should be at least as many of these arguments as the number of values specified in the format specifiers. Additional arguments are ignored by the function.
/// @return The number of characters written not counting the terminating null character.
int sprintf( char * s, const char * format, ... );

/// Initialize the snprintf() state
/// @param s Pointer to a buffer where the resulting C-string is stored. The buffer should have a size of at least n characters.
/// @param n Maximum number of bytes to be used in the buffer. The generated string has a length of at most n-1, leaving space for the additional terminating null character.
void snprintf_init(char * s, size_t n);

/// Print a character into snprintf buffer
/// Used by snprintf()
/// @param c The character to print
void snputc(char c);

