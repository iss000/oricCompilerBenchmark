#!/bin/bash
ofile=${1}; shift
ifile=${1}; shift

# [ -z "${OPT}" ] && OPT="-O2"

CFLAGS="${CFLAGS} -mcpu=6502"
CFLAGS="${CFLAGS} ${OPT}"

# Language standards:
# c89, c99, c11, c17
# c++98, c++11, c++14, c++17, c++2a
# std <= c90 = error: C++ style comments are not allowed in ISO C90
CFLAGS="${CFLAGS} --std=c99"

CFLAGS="${CFLAGS} -xc"
CFLAGS="${CFLAGS} -g"
CFLAGS="${CFLAGS} -fverbose-asm"
# CFLAGS="${CFLAGS} -fleading-underscore"
# CFLAGS="${CFLAGS} --leading-underscore"

${BASE}/bin/6502-gcc -S ${CFLAGS} ${INCLUDES} -o ${ofile/.o/.s} ${ifile} \
&& $(dirname $0)/x-ca.sh ${ofile} ${ofile/.o/.s}
