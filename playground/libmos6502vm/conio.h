/*               _
 **  ___ ___ _ _|_|___ ___
 ** |  _| .'|_'_| |_ -|_ -|
 ** |_| |__,|_,_|_|___|___|
 **         raxiss (c) 2021
 */

/* ================================================================== *
 * MOS6502vm simple stdio library                                     *
 * ================================================================== */

// =====================================================================
// ---------------------------------------------------------------------

// =====================================================================
#ifndef __CONIO_H__
#define __CONIO_H__
// ---------------------------------------------------------------------
#include "types.h"

// =====================================================================
// mos6502vm virtual standard io
// ---------------------------------------------------------------------
// NOTE: keep it in synch with the mos6502vm code
#define CPORT ((uint16_t)0xffff)

// NOTE: workaround for kickc
#define LF    '\x0a'
#define CR    '\x0d'

// ---------------------------------------------------------------------
// output single char to CPORT
#ifndef __HOST_C__
void _putc(const char c);
#endif

// ---------------------------------------------------------------------
// output string to CPORT
void _puts(const char* s);

// ---------------------------------------------------------------------
#endif /* __CONIO_H__ */
