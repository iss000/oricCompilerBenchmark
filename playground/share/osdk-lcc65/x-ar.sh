#!/bin/bash
ofile=${1}; shift

# ### OSDK native
cp -f ${LIBSRCDIR}/library.ndx ${ofile/.a/}/ \
&& touch ${ofile}

# ### OSDK - LD65
# ${BASE}/../cc65/bin/ar65 r ${ofile} $*
