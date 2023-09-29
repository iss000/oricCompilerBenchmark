#!/bin/sh
ofile=${1}; shift
test -z "${START}" && { echo "START undefined."; exit 1; }

# VERBOSE="-v"
# LDCOPTS="--target=mos"
# LDCOPTS="${LDCOPTS} ${VERBOSE}"
# LDCOPTS="${LDCOPTS} -Ttext $(printf "0x%.4X" ${START})"
# LDCOPTS="${LDCOPTS} -Wl,-T,share/llvm-mos/none.cfg"
#
# LDCOPTS="${LDCOPTS} -nostartfiles"
# LDCOPTS="${LDCOPTS} -nolibc"
# LDCOPTS="${LDCOPTS} -nostdlib"
# # LDCOPTS="${LDCOPTS} -nostdlibinc"
# LDCOPTS="${LDCOPTS} -Wl,--gc-sections,--defsym=_start=${START}"
#
# LDCPPOPTS="${LDCPPOPTS} -nostdlib++"
#
# ${BASE}/bin/mos-clang ${LDCOPTS} -o ${ofile} $* ${LDFLAGS} ${LIBS}

# VERBOSE="-v"
LDCOPTS="${VERBOSE} --gc-sections"
LDCOPTS="${LDCOPTS} --defsym=_start=${START}"
LDCOPTS="${LDCOPTS} -Tshare/llvm-mos/none.cfg"
LDCOPTS="${LDCOPTS} -Ttext $(printf "0x%.4X" ${START})"

LDCOPTS="${LDCOPTS} -mllvm -force-precise-rotation-cost"
LDCOPTS="${LDCOPTS} -mllvm -jump-inst-cost=6"
LDCOPTS="${LDCOPTS} -mllvm -force-loop-cold-block"
LDCOPTS="${LDCOPTS} -mllvm -phi-node-folding-threshold=0"
LDCOPTS="${LDCOPTS} -mllvm -two-entry-phi-node-folding-threshold=0"
LDCOPTS="${LDCOPTS} -mllvm -align-large-globals=false"
LDCOPTS="${LDCOPTS} -mllvm -disable-spill-hoist"
LDCOPTS="${LDCOPTS} -mllvm -zp-avail=224"
LDCOPTS="${LDCOPTS} --oformat=binary"
LDCOPTS="${LDCOPTS} --strip-debug"
LDCOPTS="${LDCOPTS} "
LDCOPTS="${LDCOPTS} "

echo ">>> ${BASE}/bin/ld.lld ${LDCOPTS} -o ${ofile} $* ${LDFLAGS} ${LIBS}"
${BASE}/bin/ld.lld ${LDCOPTS} -o ${ofile} $* ${LDFLAGS} ${LIBS}

# # # https://www.skenz.it/compilers/llvm
# # # Producing LLVM IR target machine assembly, object files and executables
# # clang -S -emit-llvm <filename>.c
# # opt -print-function < hello_world.ll
# # llc hello_world.ll -march=x86-64 -o hello_world.s
# # llc <filename>.bc –o <filename>.s
# # llc -filetype=obj <filename>.ll
# # gcc <filename>.o or clang <filename>.o

# ../bin/llvm-6502/bin/llc --version
# ../bin/llvm-6502/bin/llc -march=mos6502 -mattr=help

#######################################################
# Using a custom built libc++
#
# $ clang++ -nostdinc++ -nostdlib++           \
#           -isystem <install>/include/c++/v1 \
#           -L <install>/lib                  \
#           -Wl,-rpath,<install>/lib          \
#           -lc++                             \
#           test.cpp
#
# GCC does not support the -nostdlib++ flag,
# so one must use -nodefaultlibs instead.
#
# $ g++ -nostdinc++ -nodefaultlibs           \
#       -isystem <install>/include/c++/v1    \
#       -L <install>/lib                     \
#       -Wl,-rpath,<install>/lib             \
#       -lc++ -lc++abi -lm -lc -lgcc_s -lgcc \
#       test.cpp
