#!/bin/bash
ofile=${1}; shift
ifile=${1}; shift

# AFLAGS="-xplosgff"
#
# ${BASE}/bin/sdas6500 ${AFLAGS} ${INCLUDES} -o ${ofile/.o/.rel} ${ifile} \
# && touch ${ofile}

AFLAGS="--target none"

${BASE}/bin/sdas-to-ca65.lua ${ifile} ${ofile/.o/.a65} \
&& ${BASE}/../cc65/bin/ca65 ${AFLAGS} ${INCLUDES} -o ${ofile} ${ofile/.o/.a65}
