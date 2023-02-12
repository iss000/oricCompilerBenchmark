#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

AFLAGS="--target none"

${BASE}/bin/ca65 ${AFLAGS} ${INCLUDES} -o ${ofile} ${ifile}

# # for ccxa
# # 65816 = -w | 6502 = -W
# CPU_OPTION=${CPU_OPTION:--W}
