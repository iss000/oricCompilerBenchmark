/// @file
/// Find atan2(x, y) using the CORDIC method
///
/// See http://bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf

/// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
/// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
/// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
unsigned int atan2_16(signed int x, signed int y);

/// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
/// Finding the angle requires a binary search using CORDIC_ITERATIONS_8
/// Returns the angle in hex-degrees (0=0, 0x80=PI, 0x100=2*PI)
char atan2_8(signed char x, signed char y);