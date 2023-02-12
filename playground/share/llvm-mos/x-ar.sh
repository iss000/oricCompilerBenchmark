#!/bin/sh
ofile=${1}; shift

${BASE}/bin/llvm-ar -rcSD ${ofile} $*
