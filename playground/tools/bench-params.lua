--              _
--  ___ ___ _ _|_|___ ___
-- |  _| .'|_'_| |_ -|_ -|
-- |_| |__,|_,_|_|___|___|
--  iss@raxiss(c)2020,2023

verbose = false         -- verbose compile and run

debug_compile = 0       -- verbose compilation level (0,1,2,3)
debug_run_info = 0      -- mos6502vm shows some info (0,1)
debug_run_dump = 0      -- dumps mos6502vm memory to file (0,1)
debug_run_trace = 0     -- 6502 step-by-step disassembler (0,1,2)

compilers = {
  'cc65',
  'gcc-6502',
  'kickc',
  'llvm-mos',
  'osdk-lcc65',
  'sdcc',
  'vbcc',
--   'oscar64',
--   '6502-c++',
  }


--
-- see share/*/x-cc.sh for more compiler flags
--
compilers_make_param_size = {
  ['cc65']        = '-O',
  ['gcc-6502']    = '-O2',
  ['kickc']       = '',
  ['llvm-mos']    = '-Oz',
  ['osdk-lcc65']  = '-O2',
  ['sdcc']        = '--opt-code-size',
  ['vbcc']        = '-O=991',
  ['oscar64']     = '-Os',
--   ['6502-c++']    = '-O2',
  }

compilers_make_param_speed = {
  ['cc65']        = '-Oirs',
  ['gcc-6502']    = '-O3',
  ['kickc']       = '',                 -- -Ocoalesce -Oliverangecallpath -Oloophead',
  ['llvm-mos']    = '-Os',
  ['osdk-lcc65']  = '-O2',
  ['sdcc']        = '--opt-code-speed', -- --peep-asm --peep-return
  ['vbcc']        = '-O=1023',
  ['oscar64']     = '-O3',
--   ['6502-c++']    = '-O3',
  }

--
-- some extra defines per compiler
--
compilers_make_param = {
  ['cc65']        = '-D__CC65__         -DHAVE_VOLATILE',
  ['gcc-6502']    = '-D__GCC_6502__     -DHAVE_VOLATILE',
  ['kickc']       = '-D__KICKC__        ',
  ['llvm-mos']    = '-D__LLVM_MOS__     -DHAVE_VOLATILE -Wno-shift-negative-value -Wno-incompatible-pointer-types',
  ['osdk-lcc65']  = '',
  ['sdcc']        = '-D__SDCC__         -DHAVE_VOLATILE',
  ['vbcc']        = '-D__VBCC__         -DHAVE_VOLATILE',
  ['oscar64']     = '-d__OSCAR64__      ',
--   ['6502-c++']    = '-D__6502_CPP__',
  }
