#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

# [ -z "${OPT}" ] && OPT="--opt-code-speed --opt-code-size --peep-asm --peep-return"

CFLAGS="${CFLAGS} -mm6502"

#  --std-c89     Use ISO C90 (aka ANSI C89) standard (slightly incomplete)
#  --std-sdcc89  Use ISO C90 (aka ANSI C89) standard with SDCC extensions
#  --std-c95     Use ISO C95 (aka ISO C94) standard (slightly incomplete)
#  --std-c99     Use ISO C99 standard (incomplete)
#  --std-sdcc99  Use ISO C99 standard with SDCC extensions
#  --std-c11     Use ISO C11 standard (incomplete)
#  --std-sdcc11  Use ISO C11 standard with SDCC extensions (default)
#  --std-c2x     Use ISO C2X standard (incomplete)
#  --std-sdcc2x  Use ISO C2X standard with SDCC extensions
CFLAGS="${CFLAGS} --std-c11"

# Special options for the m6502 port:
#  --model-small     8-bit address space for data
#  --model-large     16-bit address space for data (default)
#  --oldralloc       Use old register allocator
CFLAGS="${CFLAGS} --model-large"
CFLAGS="${CFLAGS} --oldralloc" #???

CFLAGS="${CFLAGS} --nostdinc"

CFLAGS="${CFLAGS} ${OPT}"

CFLAGS="${CFLAGS} --max-allocs-per-node 25000"
CFLAGS="${CFLAGS} --fverbose-asm"
CFLAGS="${CFLAGS} --i-code-in-asm"

CDEFS=""
CDEFS="${CDEFS} -D__SDCC_MODEL_LARGE"

${BASE}/bin/sdcc -S ${CFLAGS} ${CDEFS} ${INCLUDES} -o ${ofile/.o/.s} ${ifile} \
&& $(dirname $0)/x-ca.sh ${ofile} ${ofile/.o/.s}

# ${BASE}/bin/sdcc -c ${CFLAGS} ${INCLUDES} -o ${ofile/.o/.rel} ${ifile} \
# && touch ${ofile}
