#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

AFLAGS="--target none"

${BASE}/bin/6502-cpp -E ${INCLUDES} -o ${ofile/.o/.i.s} ${ifile} \
&& ${BASE}/../cc65/bin/ca65 ${AFLAGS} ${INCLUDES} -o ${ofile} ${ofile/.o/.i.s}
