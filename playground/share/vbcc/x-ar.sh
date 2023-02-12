#!/bin/sh
ofile=${1}; shift

ar r ${ofile} $* >/dev/null 2>&1
