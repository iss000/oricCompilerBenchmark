/*               _
 **  ___ ___ _ _|_|___ ___
 ** |  _| .'|_'_| |_ -|_ -|
 ** |_| |__,|_,_|_|___|___|
 **     iss@raxiss (c) 2022
 */

/* ================================================================== *
 * MOS 6502 (simpe) virtual machine                                   *
 * ================================================================== */

// =====================================================================
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

// ---------------------------------------------------------------------
#include "mos6502vm.h"

// =====================================================================
// clang-format off
// ---------------------------------------------------------------------


/* defines the cycles of cpu 6502 opcodes */
static const int opcycles[0x0100] =
{
    7, 6, 2, 2, 5, 3, 5, 2, 3, 2, 2, 2, 6, 4, 6, 2,
    2, 5, 5, 2, 5, 4, 6, 2, 2, 4, 2, 2, 6, 4, 7, 2,
    6, 6, 2, 2, 3, 3, 5, 2, 4, 2, 2, 2, 4, 4, 6, 2,
    2, 5, 5, 2, 4, 4, 6, 2, 2, 4, 2, 2, 4, 4, 7, 2,
    6, 6, 2, 2, 2, 3, 5, 2, 3, 2, 2, 2, 3, 4, 6, 2,
    2, 5, 5, 2, 2, 4, 6, 2, 2, 4, 3, 2, 2, 4, 7, 2,
    6, 6, 2, 2, 3, 3, 5, 2, 4, 2, 2, 2, 5, 4, 6, 2,
    2, 5, 5, 2, 4, 4, 6, 2, 2, 4, 4, 2, 6, 4, 7, 2,
    2, 6, 2, 2, 3, 3, 3, 2, 2, 2, 2, 2, 4, 4, 4, 2,
    2, 6, 5, 2, 4, 4, 4, 2, 2, 5, 2, 2, 4, 5, 5, 2,
    2, 6, 2, 2, 3, 3, 3, 2, 2, 2, 2, 2, 4, 4, 4, 2,
    2, 5, 5, 2, 4, 4, 4, 2, 2, 4, 2, 2, 4, 4, 4, 2,
    2, 6, 2, 2, 3, 3, 5, 2, 2, 2, 2, 2, 4, 4, 6, 2,
    2, 5, 5, 2, 2, 4, 6, 2, 2, 4, 3, 2, 2, 4, 7, 2,
    2, 6, 2, 2, 3, 3, 5, 2, 2, 2, 2, 2, 4, 4, 6, 2,
    2, 5, 5, 2, 2, 4, 6, 2, 2, 4, 4, 2, 2, 4, 7, 2
};

/* defines the size of cpu 6502 opcodes */
static const int opsizes[0x0100] =
{
    1, 2, 1, 1, 1, 2, 2, 1, 1, 2, 1, 1, 1, 3, 3, 1,
    2, 2, 1, 1, 1, 2, 2, 1, 1, 3, 1, 1, 1, 3, 3, 1,
    3, 2, 1, 1, 2, 2, 2, 1, 1, 2, 1, 1, 3, 3, 3, 1,
    2, 2, 1, 1, 1, 2, 2, 1, 1, 3, 1, 1, 1, 3, 3, 1,
    1, 2, 1, 1, 1, 2, 2, 1, 1, 2, 1, 1, 3, 3, 3, 1,
    2, 2, 1, 1, 1, 2, 2, 1, 1, 3, 1, 1, 1, 3, 3, 1,
    1, 2, 1, 1, 1, 2, 2, 1, 1, 2, 1, 1, 3, 3, 3, 1,
    2, 2, 1, 1, 1, 2, 2, 1, 1, 3, 1, 1, 1, 3, 3, 1,
    1, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 3, 3, 3, 1,
    2, 2, 1, 1, 2, 2, 2, 1, 1, 3, 1, 1, 1, 3, 1, 1,
    2, 2, 2, 1, 2, 2, 2, 1, 1, 2, 1, 1, 3, 3, 3, 1,
    2, 2, 1, 1, 2, 2, 2, 1, 1, 3, 1, 1, 3, 3, 3, 1,
    2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 1, 1, 3, 3, 3, 1,
    2, 2, 1, 1, 1, 2, 2, 1, 1, 3, 1, 1, 1, 3, 3, 1,
    2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 1, 1, 3, 3, 3, 1,
    2, 2, 1, 1, 1, 2, 2, 1, 1, 3, 1, 1, 1, 3, 3, 1,
};

/* defines the mnemonic of cpu 6502 opcodes */
static const char* opnames[0x0100] =
{
    "BRK", "ORA", "???", "???", "???", "ORA", "ASL", "???", "PHP", "ORA", "ASL", "???", "???", "ORA", "ASL", "???",
    "BPL", "ORA", "???", "???", "???", "ORA", "ASL", "???", "CLC", "ORA", "???", "???", "???", "ORA", "ASL", "???",
    "JSR", "AND", "???", "???", "BIT", "AND", "ROL", "???", "PLP", "AND", "ROL", "???", "BIT", "AND", "ROL", "???",
    "BMI", "AND", "???", "???", "???", "AND", "ROL", "???", "SEC", "AND", "???", "???", "???", "AND", "ROL", "???",
    "RTI", "EOR", "???", "???", "???", "EOR", "LSR", "???", "PHA", "EOR", "LSR", "???", "JMP", "EOR", "LSR", "???",
    "BVC", "EOR", "???", "???", "???", "EOR", "LSR", "???", "CLI", "EOR", "???", "???", "???", "EOR", "LSR", "???",
    "RTS", "ADC", "???", "???", "???", "ADC", "ROR", "???", "PLA", "ADC", "ROR", "???", "JMP", "ADC", "ROR", "???",
    "BVS", "ADC", "???", "???", "???", "ADC", "ROR", "???", "SEI", "ADC", "???", "???", "???", "ADC", "ROR", "???",
    "???", "STA", "???", "???", "STY", "STA", "STX", "???", "DEY", "???", "TXA", "???", "STY", "STA", "STX", "???",
    "BCC", "STA", "???", "???", "STY", "STA", "STX", "???", "TYA", "STA", "TXS", "???", "???", "STA", "???", "???",
    "LDY", "LDA", "LDX", "???", "LDY", "LDA", "LDX", "???", "TAY", "LDA", "TAX", "???", "LDY", "LDA", "LDX", "???",
    "BCS", "LDA", "???", "???", "LDY", "LDA", "LDX", "???", "CLV", "LDA", "TSX", "???", "LDY", "LDA", "LDX", "???",
    "CPY", "CMP", "???", "???", "CPY", "CMP", "DEC", "???", "INY", "CMP", "DEX", "???", "CPY", "CMP", "DEC", "???",
    "BNE", "CMP", "???", "???", "???", "CMP", "DEC", "???", "CLD", "CMP", "???", "???", "???", "CMP", "DEC", "???",
    "CPX", "SBC", "???", "???", "CPX", "SBC", "INC", "???", "INX", "SBC", "NOP", "???", "CPX", "SBC", "INC", "???",
    "BEQ", "SBC", "???", "???", "???", "SBC", "INC", "???", "SED", "SBC", "???", "???", "???", "SBC", "INC", "???",
};

/* defines the mnemonic of cpu 6502 opcodes */
typedef
enum address_mode_s
{
    IMP = 0,
    IMM = 1,
    ABS = 2,
    ZPG = 3,
    REL = 4,
    ABX = 5,
    ABY = 6,
    ZPX = 7,
    ZPY = 8,
    IDX = 9,
    IDY = 10,
    IND = 11,
    ADDRESS_MODES
} address_mode_t, *address_mode_p;

/* defines the addressing mode of cpu 6502 opcodes */
static const int opmodes[0x0100] =
{
    IMP, IDX, IMP, IMP, IMP, ZPG, ZPG, IMP, IMP, IMM, IMP, IMP, IMP, ABS, ABS, IMP,
    REL, IDY, IMP, IMP, IMP, ZPX, ZPX, IMP, IMP, ABY, IMP, IMP, IMP, ABX, ABX, IMP,
    ABS, IDX, IMP, IMP, ZPG, ZPG, ZPG, IMP, IMP, IMM, IMP, IMP, ABS, ABS, ABS, IMP,
    REL, IDY, IMP, IMP, IMP, ZPX, ZPX, IMP, IMP, ABY, IMP, IMP, IMP, ABX, ABX, IMP,
    IMP, IDX, IMP, IMP, IMP, ZPG, ZPG, IMP, IMP, IMM, IMP, IMP, ABS, ABS, ABS, IMP,
    REL, IDY, IMP, IMP, IMP, ZPX, ZPX, IMP, IMP, ABY, IMP, IMP, IMP, ABX, ABX, IMP,
    IMP, IDX, IMP, IMP, IMP, ZPG, ZPG, IMP, IMP, IMM, IMP, IMP, IND, ABS, ABS, IMP,
    REL, IDY, IMP, IMP, IMP, ZPX, ZPX, IMP, IMP, ABY, IMP, IMP, IMP, ABX, ABX, IMP,
    IMP, IDX, IMP, IMP, ZPG, ZPG, ZPG, IMP, IMP, IMP, IMP, IMP, ABS, ABS, ABS, IMP,
    REL, IDY, IMP, IMP, ZPX, ZPX, ZPY, IMP, IMP, ABY, IMP, IMP, IMP, ABX, IMP, IMP,
    IMM, IDX, IMM, IMP, ZPG, ZPG, ZPG, IMP, IMP, IMM, IMP, IMP, ABS, ABS, ABS, IMP,
    REL, IDY, IMP, IMP, ZPX, ZPX, ZPY, IMP, IMP, ABY, IMP, IMP, ABX, ABX, ABY, IMP,
    IMM, IDX, IMP, IMP, ZPG, ZPG, ZPG, IMP, IMP, IMM, IMP, IMP, ABS, ABS, ABS, IMP,
    REL, IDY, IMP, IMP, IMP, ZPX, ZPX, IMP, IMP, ABY, IMP, IMP, IMP, ABX, ABX, IMP,
    IMM, IDX, IMP, IMP, ZPG, ZPG, ZPG, IMP, IMP, IMM, IMP, IMP, ABS, ABS, ABS, IMP,
    REL, IDY, IMP, IMP, IMP, ZPX, ZPX, IMP, IMP, ABY, IMP, IMP, IMP, ABX, ABX, IMP,
};

/* defines the addressing mode disassebler tokens */
static const char* opmodesdasm[ADDRESS_MODES] =
{
    "%s",
    "%s #$%.02X",
    "%s $%.04X",
    "%s $%.02X",
    "%s $%.04X",
    "%s $%.04X,X",
    "%s $%.04X,Y",
    "%s $%.02X,X",
    "%s $%.02X,Y",
    "%s ($%.02X,X)",
    "%s ($%.02X),Y",
    "%s ($%.04X)",
};

// =====================================================================
// clang-format on
// ---------------------------------------------------------------------

#define RDBUS(addr) read6502(addr)

/* defines various macroses */
#define OP(addr) \
  (RDBUS(addr))

#define OP8(addr) \
  (RDBUS(addr + 1))

#define OP16(addr) \
  (((uint16_t)(RDBUS(addr + 2)) << 8) | (RDBUS(addr + 1)))

#define OP8X(addr) \
  ((((uint16_t)OP8(addr)) + addr.x) & 0x00FF)

#define OP8Y(addr) \
  ((((uint16_t)OP8(addr)) + addr.y) & 0x00FF)

#define OP16X(addr) \
  (((uint16_t)OP16(addr)) + addr.x)

#define OP16Y(addr) \
  (((uint16_t)OP16(addr)) + addr.y)

#define OPSIZE(addr) \
  (opsizes[RDBUS(addr)])

static char buffer[1024];

static void mos6502_trace_1(void)
{
  switch (OPSIZE(cpu.pc))
  {
  case 3:
  {
    sprintf(buffer, opmodesdasm[opmodes[OP(cpu.pc)]], opnames[OP(cpu.pc)], OP16(cpu.pc));
    if (0x20 == OP(cpu.pc))
      printf("%.4X: %.2X %.2X %.2X   %s\n",
             cpu.pc,
             OP(cpu.pc),
             OP(cpu.pc + 1),
             OP(cpu.pc + 2),
             buffer);
    else
      printf("%.4X: %.2X %.2X %.2X   %s\n",
             cpu.pc,
             OP(cpu.pc),
             OP(cpu.pc + 1),
             OP(cpu.pc + 2),
             buffer);
  }
  break;
  case 2:
  {
    if (REL == opmodes[OP(cpu.pc)])
      sprintf(buffer, opmodesdasm[opmodes[OP(cpu.pc)]], opnames[OP(cpu.pc)], cpu.pc + OPSIZE(cpu.pc) + (int8_t)OP8(cpu.pc));
    else
      sprintf(buffer, opmodesdasm[opmodes[OP(cpu.pc)]], opnames[OP(cpu.pc)], OP8(cpu.pc));
    printf("%.4X: %.2X %.2X      %s\n",
           cpu.pc,
           OP(cpu.pc),
           OP(cpu.pc + 1),
           buffer);
  }
  break;
  case 1:
  {
    sprintf(buffer, opmodesdasm[opmodes[OP(cpu.pc)]], opnames[OP(cpu.pc)]);
    printf("%.4X: %.2X         %s\n",
           cpu.pc,
           OP(cpu.pc),
           buffer);
  }
  break;
  default:
    break;
  }
}

#define FLAG_CARRY 0x01
#define FLAG_ZERO 0x02
#define FLAG_INTERRUPT 0x04
#define FLAG_DECIMAL 0x08
#define FLAG_BREAK 0x10
#define FLAG_CONSTANT 0x20
#define FLAG_OVERFLOW 0x40
#define FLAG_SIGN 0x80

static void mos6502_trace_2(void)
{
  sprintf(buffer,
          "| %.2X | %.2X | %.2X | %.2X | %c%c%c%c%c%c%c%c | ",
          cpu.a,
          cpu.x,
          cpu.y,
          cpu.sp & 0xFF,
          cpu.status & FLAG_SIGN ? 'N' : '.',
          cpu.status & FLAG_OVERFLOW ? 'V' : '.',
          '-',
          cpu.status & FLAG_BREAK ? 'B' : '.',
          cpu.status & FLAG_DECIMAL ? 'D' : '.',
          cpu.status & FLAG_INTERRUPT ? 'I' : '.',
          cpu.status & FLAG_ZERO ? 'Z' : '.',
          cpu.status & FLAG_CARRY ? 'C' : '.');

  switch (OPSIZE(cpu.pc))
  {
  case 3:
  {
    sprintf(buffer + strlen(buffer), opmodesdasm[opmodes[OP(cpu.pc)]], opnames[OP(cpu.pc)], OP16(cpu.pc));
    if (0x20 == OP(cpu.pc))
      printf("%2X | %.4X: %.2X %.2X %.2X %s\n",
             cpu.status & FLAG_INTERRUPT ? 1 : 0,
             cpu.pc,
             OP(cpu.pc),
             OP(cpu.pc + 1),
             OP(cpu.pc + 2),
             buffer);
    else
      printf("%2X | %.4X: %.2X %.2X %.2X %s\n",
             cpu.status & FLAG_INTERRUPT ? 1 : 0,
             cpu.pc,
             OP(cpu.pc),
             OP(cpu.pc + 1),
             OP(cpu.pc + 2),
             buffer);
  }
  break;
  case 2:
  {
    if (REL == opmodes[OP(cpu.pc)])
      sprintf(buffer + strlen(buffer), opmodesdasm[opmodes[OP(cpu.pc)]], opnames[OP(cpu.pc)], cpu.pc + OPSIZE(cpu.pc) + (int8_t)OP8(cpu.pc));
    else
      sprintf(buffer + strlen(buffer), opmodesdasm[opmodes[OP(cpu.pc)]], opnames[OP(cpu.pc)], OP8(cpu.pc));
    printf("%2X | %.4X: %.2X %.2X    %s\n",
           cpu.status & FLAG_INTERRUPT ? 1 : 0,
           cpu.pc,
           OP(cpu.pc),
           OP(cpu.pc + 1),
           buffer);
  }
  break;
  case 1:
  {
    sprintf(buffer + strlen(buffer), opmodesdasm[opmodes[OP(cpu.pc)]], opnames[OP(cpu.pc)]);
    printf("%2X | %.4X: %.2X       %s\n",
           cpu.status & FLAG_INTERRUPT ? 1 : 0,
           cpu.pc,
           OP(cpu.pc),
           buffer);
  }
  break;
  default:
    break;
  }
}

void mos6502_trace(void)
{
  switch (verbosity())
  {
  case 0:
    return;

  case 1:
    mos6502_trace_1();
    break;

  case 2:
  default:
    mos6502_trace_2();
    break;
  }
}

void setup6502(void)
{
  hookexternal(mos6502_trace);
}
