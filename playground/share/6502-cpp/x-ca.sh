#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

AFLAGS="--target none"

BASE=$(dirname ${BASE})

${BASE}/cc65/bin/ca65 ${AFLAGS} ${INCLUDES} -o ${ofile} ${ifile}
