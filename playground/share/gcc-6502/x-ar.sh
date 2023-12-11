#!/bin/bash
ofile=${1}; shift

${BASE}/../cc65/bin/ar65 r ${ofile} $*
