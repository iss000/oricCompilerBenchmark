#!/bin/bash
ofile=${1}; shift

ar r ${ofile} $* >/dev/null 2>&1
