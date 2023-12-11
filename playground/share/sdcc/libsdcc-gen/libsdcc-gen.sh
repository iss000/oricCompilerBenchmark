#!/bin/bash

cd $(dirname $0)

SRCDIR=$(dirname $0)/src
SRC2DIR=$(dirname $0)/src2
DESTDIR=$(dirname $0)/../libsdcc-src
DESTINC=$(dirname $0)/../include


rm -rf ${DESTDIR} ${DESTINC}
mkdir -p ${DESTDIR} ${DESTINC}

LIBSDCC_GEN_MK=$(pwd)/libsdcc-gen.mk

cat ${SRCDIR}/m6502/Makefile.in \
|sed -e "s#@srcdir@#${SRCDIR}/m6502#g" \
>Makefile

echo -e "
.PHONY: list list2
list:
\t@echo \$(subst ../,${SRCDIR}/,\$(M6502SOURCES))
list2:
\t@echo \$(addprefix ${SRCDIR}/m6502/,\$(patsubst %.rel,%.c,\$(OBJ)))

" >> Makefile

cp -af $(make list) ${DESTDIR}/
cp -af $(make list2) ${DESTDIR}/

cp -f ${SRCDIR}/../.gitignore ${DESTDIR}/
cp -f ${SRCDIR}/../.gitignore ${DESTINC}/

cp -arf inc/* ${DESTINC}/

# additional sources
for item in `find ${SRC2DIR} -type f`; do
  cp -f ${item} ${DESTDIR}/
done

cp -f ${SRCDIR}/../_.s ${DESTDIR}/

# HACK: fail to compile
rm -f ${DESTDIR}/_fsdiv.c
rm -f ${DESTDIR}/_itoa.c
rm -f ${DESTDIR}/_ltoa.c
rm -f ${DESTDIR}/printf_large.c
rm -f ${DESTDIR}/strtoul.c
rm -f ${DESTDIR}/time.c
