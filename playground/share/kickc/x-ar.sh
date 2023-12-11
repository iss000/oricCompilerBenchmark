#!/bin/bash
ofile=${1}; shift

echo -e $* > ${ofile}

# alternative (obsolete)
# T=$(cat ${ofile}| sort -u)
# echo "$T" > ${ofile}

