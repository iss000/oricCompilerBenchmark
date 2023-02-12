#!/bin/sh
ofile=${1}; shift

echo -e $* > ${ofile}

# alternative (obsolete)
# T=$(cat ${ofile}| sort -u)
# echo "$T" > ${ofile}

