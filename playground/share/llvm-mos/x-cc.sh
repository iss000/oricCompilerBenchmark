#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

# TODO: determine c/cc/cpp

# VERBOSE="-v"

# [ -z "${OPT}" ] && OPT="-O2"

CFLAGS="${CFLAGS} --target=mos -D__LLVM_MOS__"
CFLAGS="${CFLAGS} ${VERBOSE}"
CFLAGS="${CFLAGS} ${OPT}"
CFLAGS="${CFLAGS} -xc"
CFLAGS="${CFLAGS} --std=c99 -Wno-incompatible-library-redeclaration"
CFLAGS="${CFLAGS} -funsigned-char"
CFLAGS="${CFLAGS} -nostdinc"

CPPFLAGS="${CPPFLAGS} -nostdinc++"

AFLAGS=""

${BASE}/bin/mos-clang -c ${CFLAGS} ${INCLUDES} -o ${ofile} ${ifile}

# ${BASE}/bin/mos-clang -S ${CFLAGS} ${INCLUDES} -o ${ofile/.o/.s} ${ifile}
# ${BASE}/bin/mos-clang -c ${AFLAGS} ${INCLUDES} -o ${ofile} ${ofile/.o/.s}
