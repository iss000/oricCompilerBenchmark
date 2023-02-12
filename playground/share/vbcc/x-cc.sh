#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

export VBCC="${BASE}/bin"

# [ -z "${OPT}" ] && OPT="-O=-1"

# -c89, -c99
CFLAGS="${CFLAGS} -c99"

# 1023                                 000001111111111
# 991                                  000001111011111
# -1                                   111111111111111
#                                      432109876543210
# CFLAGS="${CFLAGS} -O=$(echo "ibase=2;000000100010011"| bc)"
CFLAGS="${CFLAGS} ${OPT}"

# CFLAGS="${CFLAGS} -speed"
# CFLAGS="${CFLAGS} -size"
# CFLAGS="${CFLAGS} -maxoptpasses=8"
# CFLAGS="${CFLAGS} -unroll-all"
# CFLAGS="${CFLAGS} -unsigned-char"

CFLAGS="${CFLAGS} -quiet"

${BASE}/bin/vbcc6502 ${INCLUDES} ${CFLAGS} -o=${ofile/.o/.s} ${ifile} \
&& $(dirname $0)/x-ca.sh ${ofile} ${ofile/.o/.s}
