#!/bin/bash
ofile=${1}; shift
ifile=${1}; shift

# ### OSDK native
MACROS="${BASE}/macro/macros.h"
C1FLAGS="-DXA -Wall -lang-c++"

# -O0 no optimization
# -O1 remove ADDR and CNST leaves
# -O2 allocate register variables
#     and do some easy opt. (INC...)
# -O3 optimizes INDIR, ASGN ...
# [ -z "${OPT}" ] && OPT="-O2"

CFLAGS="${CFLAGS} ${OPT}"

NFLAG=$(basename ${ifile})
NFLAG="${NFLAG//[^[:alnum:]]/_}"

RCC=${RCC:-compiler}
# RCC=${RCC:-lcc65}

#TODO: why cpp doesn't work on second call ???

${BASE}/bin/cpp ${C1FLAGS} -E -MMD ${ofile/.o/.d} ${INCLUDES} ${ifile} -o ${ofile/.o/.c1} \
&& ${BASE}/bin/${RCC} ${CFLAGS} -N"${NFLAG}" ${ofile/.o/.c1} ${ofile/.o/.c2} \
&& cpp ${C1FLAGS} -imacros ${MACROS} -traditional -P ${ofile/.o/.c2} ${ofile/.o/.c3} \
&& ${BASE}/bin/macrosplitter	${ofile/.o/.c3} ${ofile/.o/.s} \
&& dos2unix ${ofile/.o/.s} >/dev/null 2>&1 \
&& touch ${ofile}

# ??? ${OPT65} ${$1_OBJDIR}/$${notdir $${<:.c=.s}} > $$@

# cp -f  ${SYSROOT}/$(basename ${ofile/.a/})/library.ndx ${ofile/.a/}/

# ### OSDK - LD65
# CFLAGS="--cpu 6502"
# CFLAGS="${CFLAGS} -Ois"
# CFLAGS="${CFLAGS} --target none"
# # Language standard (c89, c99, cc65)
# CFLAGS="${CFLAGS} --standard cc65"
# CFLAGS="${CFLAGS} -g"
#
# ${BASE}/bin/cc65 ${CFLAGS} ${INCLUDES} -o ${ofile/.o/.s} ${ifile} \
# && $(dirname $0)/x-ca.sh ${ofile} ${ofile/.o/.s}
