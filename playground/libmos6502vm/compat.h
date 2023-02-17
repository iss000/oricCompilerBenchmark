/*               _
 **  ___ ___ _ _|_|___ ___
 ** |  _| .'|_'_| |_ -|_ -|
 ** |_| |__,|_,_|_|___|___|
 **         raxiss (c) 2023
 */

/* ================================================================== *
 * MOS6502vm simple stdio library                                     *
 * ================================================================== */

// =====================================================================
// ---------------------------------------------------------------------

// =====================================================================
#ifndef __COMPART_H__
#define __COMPART_H__
// ---------------------------------------------------------------------

// =====================================================================
#ifdef __KICKC__
#include <division.h>
#define _modr16u(dividend,divisor,rem)\
  modr16u((unsigned int)dividend,(unsigned int)divisor,(unsigned int)rem)
#define _div16u(dividend,divisor)\
  div16u((unsigned int)dividend,(unsigned int)divisor)
#else
#define _modr16u(dividend,divisor,rem)(dividend%divisor)
#define _div16u(dividend,divisor)(dividend/divisor)
#endif

// ---------------------------------------------------------------------
#endif /* __COMPART_H__ */
