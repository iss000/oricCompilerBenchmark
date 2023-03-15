#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

# [ -z "${OPT}" ] && OPT="-Os"

BINDIR="$(dirname ${BASE})"

AVRCC=avr-gcc

AVRCFLAGS="${CFLAGS}"
AVRCFLAGS="${AVRCFLAGS} ${OPT}"
AVRCFLAGS="${AVRCFLAGS} -fverbose-asm"
AVRCFLAGS="${AVRCFLAGS} -fleading-underscore"
AVRCFLAGS="${AVRCFLAGS} -mmcu=avr3"
AVRCFLAGS="${AVRCFLAGS} --std=c99"
AVRCFLAGS="${AVRCFLAGS} -xc"
AVRCFLAGS="${AVRCFLAGS} -mtiny-stack"
AVRCFLAGS="${AVRCFLAGS} -Wall -Wextra -Wconversion"
# AVRCFLAGS="${AVRCFLAGS} -Wno-unused-variable"

AVRCXXFLAGS="${AVRCXXFLAGS} -std=c++20"
AVRCXXFLAGS="${AVRCXXFLAGS} -fconstexpr-ops-limit=333554432"

XAFLAGS="-DXA -D__XA__ -C -W -M -R -p~ -cc -O ASCII"

${AVRCC} ${AVRCFLAGS} ${INCLUDES} -c -S -o ${ofile/.o/.avr.s} ${ifile} \
&& ${BINDIR}/6502-c++ -i ${ofile/.o/.avr.s} -o ${ofile/.o/.6502.s} -v6 \
&& ${BINDIR}/xa65 ${XAFLAGS} -o ${ofile/.o/.oxa} ${ofile/.o/.6502.s} \
&& ${BINDIR}/cc65/bin/co65 -g -o ${ofile/.o/.oxa.s} ${ofile/.o/.oxa} \
&& ${BINDIR}/cc65/bin/ca65 -U -l ${ofile/.o/.lst} -o ${ofile} ${ofile/.o/.oxa.s}

# && $(dirname $0)/x-ca.sh ${ofile} ${ofile/.o/.oxa.s}
