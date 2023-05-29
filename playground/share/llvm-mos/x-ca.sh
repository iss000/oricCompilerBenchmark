#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

AFLAGS=""
AFLAGS="${AFLAGS} --target=mos"

# MOS_CLANG=$MOS_CLANG
MOS_CLANG=clang

${BASE}/bin/$MOS_CLANG -c ${AFLAGS} ${INCLUDES} -o ${ofile} ${ifile}
