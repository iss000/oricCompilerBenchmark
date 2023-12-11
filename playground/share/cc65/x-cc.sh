#!/bin/bash
ofile=${1}; shift
ifile=${1}; shift

# [ -z "${OPT}" ] && OPT="-Ois"

CFLAGS="${CFLAGS} --cpu 6502"
CFLAGS="${CFLAGS} ${OPT}"
CFLAGS="${CFLAGS} --target none"
# Language standard (c89, c99, cc65)
CFLAGS="${CFLAGS} --standard cc65"
# CFLAGS="${CFLAGS} -g"

${BASE}/bin/cc65 ${CFLAGS} ${INCLUDES} -o ${ofile/.o/.s} ${ifile} \
&& $(dirname $0)/x-ca.sh ${ofile} ${ofile/.o/.s}
