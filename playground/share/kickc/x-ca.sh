#!/bin/bash
ofile=${1}; shift
ifile=${1}; shift

[ "$(basename ${ifile})" == "boot0.s" ] \
&& cp -f ${ifile} ${ofile} \
|| true
