#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

# [ -z "${OPT}" ] && OPT="-O2"

CFLAGS="${CFLAGS} ${OPT}"

$(dirname ${BASE})/6502-c++ ${ifile} # > ${ofile/.o/.s}
# && $(dirname $0)/x-ca.sh ${ofile} ${ofile/.o/.s}
exit 1
