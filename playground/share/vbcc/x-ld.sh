#!/bin/sh
ofile=${1}; shift

export VBCC="${BASE}/bin"

LDFLAGS="${LDFLAGS} -w"
LDFLAGS="${LDFLAGS} -b rawbin1"
LDFLAGS="${LDFLAGS} -C vbcc"
LDFLAGS="${LDFLAGS} -T share/vbcc/none.cfg"
LDFLAGS="${LDFLAGS} -nostdlib"
LDFLAGS="${LDFLAGS} -s -sc -sd"
LDFLAGS="${LDFLAGS} -gc-empty"
# LDFLAGS="${LDFLAGS} -lmieee"
# LDFLAGS="${LDFLAGS} -lm "
LDFLAGS="${LDFLAGS} -lvc"

${BASE}/bin/vlink ${LDFLAGS} -o ${ofile} $* ${LIBS}
