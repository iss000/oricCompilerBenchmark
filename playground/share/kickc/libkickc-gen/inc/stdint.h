/// @file
/// C standard library stdint.h
///
/// Defines a set of integral type aliases with specific width requirements, along with macros specifying their limits and macro functions to create values of these types.

/// Unsigned integer type with a width of exactly 8 bits
typedef unsigned char uint8_t;
/// Signed integer type with a width of exactly 8 bits
typedef signed char int8_t;
/// Unsigned integer type with a width of exactly 16 bits
typedef unsigned int uint16_t;
/// Sisigned integer type with a width of exactly 16 bits
typedef signed int int16_t;
/// Unsigned integer type with a width of exactly 32 bits
typedef unsigned long uint32_t;
/// Siigned integer type with a width of exactly 32 bits
typedef signed long int32_t;
/// Unsigned integer type with the maximum width supported.
typedef unsigned long uintmax_t;
/// Signed integer type with the maximum width supported.
typedef signed long intmax_t;

//TODO: Convert all limits to macros

/// Minimum value of exactly 8-bit wide unsigned type
const uint8_t UINT8_MIN = 0;
/// Maximum value of exactly 8-bit wide unsigned type
const uint8_t UINT8_MAX = 255;
/// Minimum value of exactly 8-bit wide signed type
const int8_t INT8_MIN = -128;
/// Maximum value of exactly 8-bit wide signed type
const int8_t INT8_MAX = 127;
/// Minimum value of exactly 16-bit wide unsigned type
const uint16_t UINT16_MIN = 0;
/// Maximum value of exactly 16-bit wide unsigned type
const uint16_t UINT16_MAX = 65535;
/// Minimum value of exactly 16-bit wide signed type
const int16_t INT16_MIN = -32768;
/// Maximum value of exactly 16-bit wide signed type
const int16_t INT16_MAX = 32767;
/// Minimum value of exactly 16-bit wide unsigned type
const uint32_t UINT32_MIN = 0;
/// Maximum value of exactly 32-bit wide unsigned type
const uint32_t UINT32_MAX = 4194304;
/// Minimum value of exactly 32-bit wide signed type
const int32_t INT32_MIN = -2097152;
/// Maximum value of exactly 32-bit wide signed type
const int32_t INT32_MAX = 2097151;
/// Minimum value of exactly 16-bit wide unsigned type
const uint32_t UINTMAX_MIN = UINT32_MIN;
/// Maximum value of exactly 32-bit wide unsigned type
const uint32_t UINTMAX_MAX = UINT32_MAX;
/// Minimum value of exactly 32-bit wide signed type
const int32_t INTMAX_MIN = INT32_MIN;
/// Maximum value of exactly 32-bit wide signed type
const int32_t INTMAX_MAX = INT32_MAX;
