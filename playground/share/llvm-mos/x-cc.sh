#!/bin/bash
ofile=${1}; shift
ifile=${1}; shift

# TODO: determine c/cc/cpp

# VERBOSE="-v"

# [ -z "${OPT}" ] && OPT="-Os"

CFLAGS="${CFLAGS} --target=mos -D__LLVM_MOS__"
CFLAGS="${CFLAGS} ${VERBOSE}"
CFLAGS="${CFLAGS} ${OPT}"
# CFLAGS="${CFLAGS} -xc"
# CFLAGS="${CFLAGS} -flto"
# CFLAGS="${CFLAGS} --std=c99 -Wno-incompatible-library-redeclaration"
CFLAGS="${CFLAGS} -funsigned-char"
CFLAGS="${CFLAGS} -nostdinc"

CPPFLAGS="${CPPFLAGS} -nostdinc++"

AFLAGS=""

filename=$(basename -- "$ifile")
extension="${filename##*.}"
filename="${filename%.*}"

case "$extension" in
  c)   MOS_CLANG=clang ;;
  cc)  MOS_CLANG=clang++ ;;
  cpp) MOS_CLANG=clang++ ;;
esac

${BASE}/bin/$MOS_CLANG -c ${CFLAGS} ${INCLUDES} -o ${ofile} ${ifile}

# ${BASE}/bin/$MOS_CLANG -S ${CFLAGS} ${INCLUDES} -o ${ofile/.o/.s} ${ifile}
# ${BASE}/bin/$MOS_CLANG -c ${AFLAGS} ${INCLUDES} -o ${ofile} ${ofile/.o/.s}
