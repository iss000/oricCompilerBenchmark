```
              _
  ___ ___ _ _|_|___ ___
 |  _| .'|_'_| |_ -|_ -|
 |_| |__,|_,_|_|___|___|
  iss@raxiss(c)2020-2023
```

# MOS6502-compiler-benchmark

---

MOS6502 compiler benchmark (WIP).

All feedback, bug reporting and opinions are highly appreciated!

---

#### Goal:
  Simple and fair benchmark for cross compilers targeting MOS6502 processor.

### C Compilers:
  * ` cc65             `
  * ` gcc-6502-bits    `
  * ` kickc            `
  * ` lcc65            `
  * ` llvm-mos         `
  * ` osdk             `
  * ` sdcc-m6502       `
  * ` vbcc             `

---
#### Requirements:
  * Host: Linux
  * Tools: gcc, make, cmake, lua, bash/sh
  * Compilers: open source only, so they can be build under host

#### Restrictions for included samples:
  * Standard C code
  * Free open source

#### Installation

###### Build and install included 6502 emulator mos6502vm:
```
  mkdir build
  cd build
  cmake ..
  make all install
```

###### Copy or symlink compiler toolschains in `bin/` directory:
```
  bin/
  ├── cc65
  │   ├── bin
  │   │   ├── cc65 ...
  ...
  ├── gcc-6502
  │   ├── bin
  │   │   ├── 6502-gcc ...
  ...
  ├── kickc
  │   ├── bin
  │   │   └── kickc.sh
  ...
  ├── llvm-mos
  │   ├── bin
  │   │   ├── clang ...
  │   │   ├── llvm-as ...
  │   │   ├── mos-clang -> clang ...
  ...
  ├── osdk-lcc65
  │   ├── bin
  │   │   ├── compiler
  │   │   ├── cpp ...
  ...
  ├── sdcc
  │   ├── bin
  │   │   ├── sdcc ...
  ...
  ├── vbcc
  │   ├── bin
  │   │   ├── vasm6502_oldstyle
  │   │   ├── vbcc6502
  │   │   ├── vc
  │   │   ├── vcpr6502
  │   │   ├── vlink ...
  ...
  └── mos6502vm (built as described above)
```

##### Run benchmarks
```
  $ cd playground
  $ ./run-all-benchmarks.sh
```
  Results are stored in `playground/www/` directory as JS files.
  Load `bench.html` in browser.

##### Credits
  * Mike Chambers for [Fake6502 CPU emulator core v1.1](https://github.com/omarandlorraine/fake6502)
