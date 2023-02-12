#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

# ${BASE}/bin/llvm-strip ${ifile}

cp -f ${ifile} ${ofile}
