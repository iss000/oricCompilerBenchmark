#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

AFLAGS=""

${BASE}/bin/mos-clang -c ${AFLAGS} ${INCLUDES} -o ${ofile} ${ifile}
