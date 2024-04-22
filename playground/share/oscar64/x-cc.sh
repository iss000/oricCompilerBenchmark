#!/bin/bash
ofile=${1}; shift
ifile=${1}; shift

CRTDIR=${SYSROOT}/liboscar64-src
CRT=${CRTDIR}/crt.c

INCLUDES="$(echo $INCLUDES| sed 's/-I/-i=/g') -i=${CRTDIR}"
CFLAGS="${CFLAGS} ${OPT}"

${BASE}/bin/oscar64 ${CFLAGS} ${INCLUDES} -v2 -g -rt=${CRT} -tf=prg -o=${ofile/.o/.s} ${ifile}

# \
# && $(dirname $0)/x-ca.sh ${ofile} ${ofile/.o/.s}
