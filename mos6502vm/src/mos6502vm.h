/*               _
 **  ___ ___ _ _|_|___ ___
 ** |  _| .'|_'_| |_ -|_ -|
 ** |_| |__,|_,_|_|___|___|
 **     iss@raxiss (c) 2022
 */

/* ================================================================== *
 * MOS 6502 (simpe) virtual machine                                   *
 * ================================================================== */
#ifndef __MOS6502VM_H__
#define __MOS6502VM_H__

#define CPORT ((uint16_t)0xffff)

// =====================================================================
typedef struct cpu_s
{
  uint16_t pc;
  uint8_t a;
  uint8_t x;
  uint8_t y;
  uint8_t sp;
  uint8_t status;
  uint32_t instructions;
  uint32_t clockticks6502;
} cpu_t, *cpu_p;

// ---------------------------------------------------------------------
extern cpu_t cpu;

// =====================================================================
// Interface to Fake6502 CPU emulator core v1.1
// ---------------------------------------------------------------------

// Call this once before you begin execution.
void reset6502(void);
// Execute a single instrution.
void step6502(void);
// Trigger a hardware IRQ in the 6502 core.
void irq6502(void);
// Trigger an NMI in the 6502 core.
void nmi6502(void);
//
void hookexternal(void *funcptr);

// ---------------------------------------------------------------------
void setup6502(void);

// ---------------------------------------------------------------------
uint8_t read6502(uint16_t address);
void write6502(uint16_t address, uint8_t value);
char verbosity(void);

// ---------------------------------------------------------------------
#endif /* __MOS6502VM_H__ */
