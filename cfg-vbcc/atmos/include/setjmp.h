/* setjmp.h - 6502 */

#ifndef __SETJMP_H
#define __SETJMP_H 1

typedef unsigned char jmp_buf[5];

int setjmp (jmp_buf);
void longjmp (jmp_buf, int);

#endif

