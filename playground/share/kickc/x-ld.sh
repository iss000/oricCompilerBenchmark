#!/bin/sh
ofile=${1}; shift
test -z "${START}" && { echo "START undefined."; exit 1; }

# -Ouplift, -Onouplift, -Onolongbranchfix, -Ocoalesce, -Oloophead, -Onoloophead, -Onocache, -Oliverangecallpath
# [ -z "${OPT}" ] && OPT=""

cat share/kickc/none.tgt |sed -e "s/@START@/${START}/g" >$(dirname ${ofile})/none.tgt

# VERBOSE="-v"

KICKC="java -jar ${BASE}/jar/kickc-release.jar"

AFLAGS="-cpu=mos6502x"
# AFLAGS="${AFLAGS} -calling=__phicall"
AFLAGS="${AFLAGS} ${VERBOSE} "

CFLAGS="${CFLAGS} -var_model=ssa_zp"
CFLAGS="${CFLAGS} ${OPT}"

LFLAGS="-a "
LFLAGS="${LFLAGS} -platform=none"
LFLAGS="${LFLAGS} -platformdir=$(dirname ${ofile})"
LFLAGS="${LFLAGS} -link=share/kickc/none.cfg"
LFLAGS="${LFLAGS} -F $(dirname $0)/fragment"

# LFLAGS="${LFLAGS} -F ${BASE}/fragment"
# LFLAGS="${LFLAGS} -I ${BASE}/include"
# LFLAGS="${LFLAGS} -L ${BASE}/lib"

LIBPATH="$(dirname $(dirname ${ofile}))"
LIBOBJ=$(find ${LIBPATH} -wholename "${LIBPATH}/lib*/*.o")

# ${KICKC} ${AFLAGS} ${CFLAGS} ${INCLUDES} ${LFLAGS} -o ${ofile} $* ${LIBOBJ} # ${LDFLAGS}  ${LIBS}
${KICKC} ${AFLAGS} ${CFLAGS} ${INCLUDES} ${LFLAGS} -o ${ofile} $* ${LIBOBJ} \
> /dev/null
