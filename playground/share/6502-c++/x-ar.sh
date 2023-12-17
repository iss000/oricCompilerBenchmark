#!/bin/bash
ofile=${1}; shift

BASE=$(dirname ${BASE})

${BASE}/cc65/bin/ar65 r ${ofile} $*
