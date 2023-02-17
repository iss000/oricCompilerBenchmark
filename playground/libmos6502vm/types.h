/*               _
 **  ___ ___ _ _|_|___ ___
 ** |  _| .'|_'_| |_ -|_ -|
 ** |_| |__,|_,_|_|___|___|
 **         raxiss (c) 2022
 */

/* ================================================================== *
 * MOS6502vm simple stdio library                                     *
 * ================================================================== */

// =====================================================================
// ---------------------------------------------------------------------

// =====================================================================
#ifndef __TYPES_H__
#define __TYPES_H__
// ---------------------------------------------------------------------

// =====================================================================
#ifdef NO_TYPEDEF
#define int8_t    char
#define int16_t   int
#define int32_t   long
#define uint8_t   unsigned char
#define uint16_t  unsigned int
#define uint32_t  unsigned long
#else
typedef char int8_t;
typedef int int16_t;
typedef long int32_t;
typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long uint32_t;
#endif

#ifdef NO_CONST
#define const
#endif

#ifdef NO_BYTE
#define byte uint8_t
#endif

#ifdef NO_WORD
#define word uint16_t
#endif

#ifdef NO_DWORD
#define dword uint32_t
#endif

// ---------------------------------------------------------------------
#ifndef __HOST_C__
#define MEMPTR(address)       ((uint8_t*)(address))
#define peek(address)         (MEMPTR(address)[0])
#define poke(address,value)   (MEMPTR(address)[0]=((uint8_t)(value)))
#else
#define MEMPTR(address)       ((uint8_t*)(&MOS6502vm_mem[(address)]))
#define peek(address)         (MOS6502vm_mem[address])
#define poke(address,value)   (MOS6502vm_mem[address]=((uint8_t)(value)))
static uint8_t MOS6502vm_mem[0x10000];
#endif

// ---------------------------------------------------------------------
#endif /* __TYPES_H__ */
