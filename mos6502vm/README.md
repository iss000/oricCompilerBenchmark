```
              _
  ___ ___ _ _|_|___ ___
 |  _| .'|_'_| |_ -|_ -|
 |_| |__,|_,_|_|___|___|
  iss@raxiss(c)2020-2023

```

# MOS6502vm 6502 virtual machine

Fast and handy MOS6502 emulator.

#### Usage
```
 mos6502vm ver.1.0.0

 Usage:
        mos6502vm [options] [hexaddr:]image [[hexaddr:]image ...]

 Options are:
         -a XXXX   start address in hex     [default $1000]
         -n N      limit run to N cycles    [default 60'000'000]
         -s S      limit run to S seconds   [default 60]
         -d file   dump 64k memory to file
         -q        be quiet (disble client's `putchar`)
         -v[v]     run-time disassembly to stderr off/brief/detailed
         -h        this help
```

---

##### Credits
  * Mike Chambers for [Fake6502 CPU emulator core v1.1](https://github.com/omarandlorraine/fake6502)
