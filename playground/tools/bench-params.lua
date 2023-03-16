--              _
--  ___ ___ _ _|_|___ ___
-- |  _| .'|_'_| |_ -|_ -|
-- |_| |__,|_,_|_|___|___|
--  iss@raxiss(c)2020,2023


local verbose = false         -- verbose compile and run

local debug_compile = 0       -- verbose compilation level (0,1,2,3)
local debug_run_info = 0      -- mos6502vm shows some info (0,1)
local debug_run_dump = 0      -- dumps mos6502vm memory to file (0,1)
local debug_run_trace = 0     -- 6502 step-by-step disassembler (0,1,2)

local compilers = {
  'cc65',
  'gcc-6502',
  'kickc',
  'llvm-mos',
  'osdk-lcc65',
  'sdcc',
  'vbcc',
--   '6502-c++',
  }


--
-- see share/*/x-cc.sh for more compiler flags
--
compilers_make_param_size = {
  ['cc65']        = '-O',
  ['gcc-6502']    = '-O2',
  ['kickc']       = '',
  ['llvm-mos']    = '-O2',
  ['osdk-lcc65']  = '-O2',
  ['sdcc']        = '--opt-code-size',
  ['vbcc']        = '-O=991',
--   ['6502-c++']    = '-O2',
  }

compilers_make_param_speed = {
  ['cc65']        = '-Oirs',
  ['gcc-6502']    = '-O3',
  ['kickc']       = '',                 -- -Ocoalesce -Oliverangecallpath -Oloophead',
  ['llvm-mos']    = '-O3',
  ['osdk-lcc65']  = '-O2',
  ['sdcc']        = '--opt-code-speed', -- --peep-asm --peep-return
  ['vbcc']        = '-O=1023',
--   ['6502-c++']    = '-O3',
  }

--
-- some extra defines per compiler
--
compilers_make_param = {
  ['cc65']        = '-D__CC65__',
  ['gcc-6502']    = '-D__GCC_6502__',
  ['kickc']       = '-D__KICKC__',
  ['llvm-mos']    = '-D__LLVM_MOS__ -Wno-shift-negative-value -Wno-incompatible-pointer-types',
  ['osdk-lcc65']  = '',
  ['sdcc']        = '-D__SDCC__',
--   ['6502-c++']    = '-D__6502_CPP__',
  }
