#!/bin/bash
ofile=${1}; shift

BASE=${BASE/oscar64/cc65}

${BASE}/bin/ar65 r ${ofile} $*
