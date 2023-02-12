#!/bin/sh
ofile=${1}; shift

OBJS="$(echo $* |sed -e 's/\.o/.rel/g')"

# ${BASE}/bin/sdar -rcSD ${ofile/.a/.lib} ${OBJS} \
# && ${BASE}/bin/sdar s ${ofile/.a/.lib} \
# && touch ${ofile}

${BASE}/../cc65/bin/ar65 r ${ofile} $*
