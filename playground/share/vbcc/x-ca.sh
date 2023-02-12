#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

export VBCC="${BASE}/bin"

QUIET="-quiet"
AFLAGS="-nowarn=62 -opt-branch -Fvobj ${QUIET}"

${BASE}/bin/vasm6502_oldstyle ${AFLAGS} ${INCLUDES} -o ${ofile} ${ifile}
