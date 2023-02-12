#!/bin/sh
ofile=${1}; shift

${BASE}/bin/ar65 r ${ofile} $*
