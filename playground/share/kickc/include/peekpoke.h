/// @file
/// PEEK and POKE macros for those who want to write BASIC code in C
///
/// Based on https://github.com/cc65/cc65/blob/master/include/peekpoke.h

/// Read the absolute memory given by addr and return the value read.
#define PEEK(addr)          (*(unsigned char*) (addr))

/// Read the absolute memory given by addr and return the value read.
/// The byte read from the higher address is the high byte of the return value.
#define PEEKW(addr)         (*(unsigned int*) (addr))

/// Writes the value val to the absolute memory address given by addr.
#define POKE(addr,val)      (*(unsigned char*) (addr) = (val))

/// Writes the value val to the absolute memory address given by addr.
/// The low byte of val is written to the addr, the high byte is written to addr+1.
#define POKEW(addr,val)     (*(unsigned int*) (addr) = (val))
