--              _
--  ___ ___ _ _|_|___ ___
-- |  _| .'|_'_| |_ -|_ -|
-- |_| |__,|_,_|_|___|___|
--  iss@raxiss(c)2020,2023

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
  }

compilers_make_param_speed = {
  ['cc65']        = '-Oirs',
  ['gcc-6502']    = '-O3',
  ['kickc']       = '',                 -- -Ocoalesce -Oliverangecallpath -Oloophead',
  ['llvm-mos']    = '-O3',
  ['osdk-lcc65']  = '-O2',
  ['sdcc']        = '--opt-code-speed', -- --peep-asm --peep-return
  ['vbcc']        = '-O=1023',
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
  ['vbcc']        = '-D__VBCC__',
  }
