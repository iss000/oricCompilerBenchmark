#!/bin/bash
ofile=${1}; shift
ifile=${1}; shift

# [ -z "${OPT}" ] && OPT="..."

C1FLAGS="-Wall -xc"

# cpp ${C1FLAGS} -Wa,-E,-MMD,${ofile/.o/.d} ${INCLUDES} ${ifile} |sed -e 's/^\#.*//g' > ${ofile}
cp -f ${ifile} ${ofile}
