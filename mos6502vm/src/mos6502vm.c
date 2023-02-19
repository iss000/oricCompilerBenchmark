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
cpu_t cpu;
// ---------------------------------------------------------------------

// =====================================================================
#define bytes(x) ((uint32_t)(x))
#define kilobytes(x) (bytes(x) * 1024)
#define megabytes(x) (kilobytes(x) * 1024)

#define useconds(x) ((uint32_t)(x))
#define mseconds(x) (useconds(x) * 1000)
#define seconds(x) (mseconds(x) * 1000)
#define minutes(x) (seconds(x) * 60)

// ---------------------------------------------------------------------
// The memory
static uint8_t mem[kilobytes(64)];

// ---------------------------------------------------------------------
int parse_command(int argc, char **argv);
const char *basename(const char *str);
void banner(const char *argv0);
int strtoint(const char *s);

// ---------------------------------------------------------------------
static char quit = 0;
static char s_ret = 0;
static char s_quiet = 0;
static char s_verbosity = 0;
static void *s_dump = 0;
static char *s_error = "Pass";
static size_t s_length = 0;
static uint32_t s_size = 0;
static uint16_t s_address = 0x0800;
static uint32_t s_clockticks = minutes(1);

// ---------------------------------------------------------------------
int main(int argc, char **argv)
{
  memset(&mem[0x0000], 0, sizeof(mem));
  memset(&mem[0x0100], 0xaa, 0x0100);

  if (parse_command(argc, argv))
    return 1;

  setup6502();

  // short loader ;)
  mem[0xfff0] = 0x20;                    // jsr
  mem[0xfff1] = 0xff & (s_address);      // address lo
  mem[0xfff2] = 0xff & (s_address >> 8); // address hi
  mem[0xfff3] = 0xea;                    // nop - back from program

  mem[0xfff4] = 0xea;
  mem[0xfff5] = 0xea;
  mem[0xfff6] = 0xea;
  mem[0xfff7] = 0xea;
  mem[0xfff8] = 0xea;
  mem[0xfff9] = 0xea;

  // NMI vector can be overloaded by image
  mem[0xfffa] = 0xff & (0xfff3); // NMI vector points to program exit (0xfff3)
  mem[0xfffb] = 0xff & (0xfff3 >> 8);
  // RESET vector can be overloaded by image
  mem[0xfffc] = 0xff & (0xfff0); // RESET vector points to program start (0xfff0)
  mem[0xfffd] = 0xff & (0xfff0 >> 8);
  // IRQ vector can be overloaded by image
  mem[0xfffe] = 0xff & (0xfff3);  // IRQ vector points to program exit (0xfff3)
  mem[0xffff] = 0xff & (0xfff3 >> 8);

  reset6502();

  while (!quit && cpu.clockticks6502 < s_clockticks)
  {
    step6502();
    quit = 0xfff3 == cpu.pc ? 1 : 0;
  }

  if (s_verbosity)
    fprintf(stdout, "\n\n");

  if (!(cpu.clockticks6502 < s_clockticks))
    s_error = "Time-out";

  fprintf(stdout, "\n");

  if (!s_quiet)
  {
    fprintf(stdout, "[%14d] instructions\n", cpu.instructions);
    fprintf(stdout, "[%14d] cycles - %s\n", cpu.clockticks6502, s_error);
  }

  fprintf(stdout, "[exit:%u,%u,%u,\"%s\"]\n",
          s_size,
          cpu.instructions,
          cpu.clockticks6502,
          s_error);

  if (s_dump)
  {
    fwrite(mem, sizeof(mem), 1, s_dump);
    fflush(s_dump);
    fclose(s_dump);
    s_dump = 0;
  }

  return s_ret;
}

// =====================================================================
uint8_t read6502(uint16_t address)
{
  return mem[address];
}
// ---------------------------------------------------------------------
void write6502(uint16_t address, uint8_t value)
{
  if (CPORT == address)
    putchar(0x00ff & (int)value);
  else
    mem[address] = value;

  // TODO: detect Stack overflow ...
  // if(what?)
  // {
  //   s_error = "Stack overflow";
  //   s_ret = -1;
  //   quit = 1;
  // }
}
// ---------------------------------------------------------------------
char verbosity(void)
{
  return s_verbosity;
}

// =====================================================================
const char *basename(const char *str)
{
  const char *p = strrchr(str, '/');
  return p ? ++p : str;
}

void banner(const char *argv0)
{
  fprintf(stdout,
          ""
          "              _           \n"
          "  ___ ___ _ _|_|___ ___   \n"
          " |  _| .'|_'_| |_ -|_ -|  \n"
          " |_| |__,|_,_|_|___|___|  \n"
          "     iss@raxiss (c) 2022  \n"
          " =========================\n"
          " %s ver.1.0.0             \n\n",
          basename(argv0));
}

void usage(const char *argv0)
{
  fprintf(stdout, " Usage:\n\t%s [options] [hexaddr:]image [[hexaddr:]image ...] \n\n", basename(argv0));
  fprintf(stdout, " Options are:\n");
  fprintf(stdout, " \t -a        %s\n", "start address in hex     [default $1000]");
  fprintf(stdout, " \t -n N      %s\n", "limit run to N cycles    [default 60'000'000]");
  fprintf(stdout, " \t -s S      %s\n", "limit run to S seconds   [default 60]");
  fprintf(stdout, " \t -d file   %s\n", "dump memory to file");
  fprintf(stdout, " \t -q        %s\n", "be quiet (disble client's `putchar`)");
  fprintf(stdout, " \t -v[v]     %s\n", "run-time disassembly to stderr off/brief/detailed");
  fprintf(stdout, " \t -h        %s\n", "this help");
  fprintf(stdout, " \n");
}

int parse_command(int argc, char **argv)
{
  uint16_t addr, size;
  int i;

  opterr = 0;
  while ((i = getopt(argc, argv, "hqva:n:s:d:")) != -1)
  {
    switch (i)
    {
    case 'h':
      banner(argv[0]);
      usage(argv[0]);
      exit(0);
      break;
    case 'q':
      s_quiet = 1;
      break;
    case 'v':
      ++s_verbosity;
      break;
    case 'a':
      s_address = strtoul(optarg, 0, 0x10);
      break;
    case 'n':
      s_clockticks = strtoul(optarg, 0, 10);
      break;
    case 's':
      s_clockticks = seconds(strtoul(optarg, 0, 10));
      break;
    case 'd':
      s_dump = optarg;
      break;
      // case ':':
      //     fprintf(stderr, "Option needs a value\n");
      //     fprintf(stderr, "Option -%i requires an argument.\n", optopt);
      //     return 1;
    case '?':
      if ('?' == optopt)
      {
        usage(argv[0]);
        return 1;
      }
      if (isprint(optopt))
        fprintf(stderr, "Unknown option `-%c'.\n", optopt);
      else
        fprintf(stderr, "Unknown option character `\\x%x'.\n", optopt);
      return 1;
    default:
      abort();
    }
  }

  if (s_dump)
  {
    s_dump = fopen(s_dump, "wb");
    if (!s_dump)
    {
      fprintf(stderr, "Can`t create dump file.\n");
      return 1;
    }
  }

  if (optind < argc)
  {
    for (addr = 0, i = optind; i < argc; i++)
    {
      FILE *fi;
      char *p;

      p = argv[i];
      if (strchr(p, ':'))
      {
        addr = strtoul(p, &p, 0x10);
        ++p;
      }
      else
        addr = 0 == addr ? s_address : addr;

      if (!p || !p[0])
      {
        fprintf(stderr, "Bad image argument: '%s'.\n", argv[i]);
        return 1;
      }

      fi = fopen(p, "rb");
      if (!fi)
      {
        fprintf(stderr, "Can`t read '%s' [$%.4x].\n", p, addr);
        return 1;
      }

      size = fread(&mem[addr], 1, sizeof(mem) - addr, fi);
      fclose(fi);

      if (!s_quiet)
      {
        fprintf(stdout, "[$%.4x .. $%.4x] %s\n", addr, addr + size - 1, p);
        fprintf(stdout, "[%14d] %s\n", size, "bytes");
      }

      addr += size;
      s_size += size;
    }
  }
  else
  {
    fprintf(stderr, "No image(s) specified.\n");
    return 1;
  }

  if (s_verbosity)
    fprintf(stdout, "\n\n");
  else
  {
    if (!s_quiet)
      fprintf(stdout, "[         $%.4x] start pc\n", s_address);
  }

  return 0;
}

// ---------------------------------------------------------------------
