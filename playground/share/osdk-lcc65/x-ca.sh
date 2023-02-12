#!/bin/sh
ofile=${1}; shift
ifile=${1}; shift

# ### OSDK native
AFLAGS=""

cp -f ${ifile} ${ofile/.o/.s} \
&& touch ${ofile}

# ### OSDK - LD65
