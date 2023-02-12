### Hacking the benchmarks

All test are coded in `tools/bench.lua` file.

##### Usage (`playground/` is current directory):
```
  $ ./tools/bench.lua <size|speed> [compiler|bench|<compiler bench>]
```

##### Examples:

Call all tests with optimizations for size:
```
  $ ./tools/bench.lua size
```

Call all tests with optimizations for speed:
```
  $ ./tools/bench.lua speed
```

Run all tests with `cc65` only:
```
  $ ./tools/bench.lua size cc65
```

Run only `dummy` speed test with all compilers:
```
  $ ./tools/bench.lua speed dummy
```

##### Some details (see `tools/bench.lua`):

 * The Lua table `compilers_make_param_size` contains options per compiler used by size tests.
 * The Lua table `compilers_make_param_speed` contains options per compiler used by speed tests.

Useful variables to control the output from compilation and run phases:

  `verbose = false`  verbose compile and run
  `debug_compile = 0`  verbose compilation level (0,1,2,3)
  `debug_run_info = 1` mos6502vm shows some info (0,1)
  `debug_run_dump = 0` dumps mos6502vm memory to file (0,1)
  `debug_run_trace = 0` 6502 step-by-step disassembler (0,1,2)
