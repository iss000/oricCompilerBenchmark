#!/bin/sh

cd $(dirname $0)

SRCDIR=$(dirname $0)/src
SRC2DIR=$(dirname $0)/src2
SRCINC=$(dirname $0)/inc

DESTDIR=$(dirname $0)/../libkickc-src
DESTINC=$(dirname $0)/../include


rm -rf ${DESTDIR} ${DESTINC}
mkdir -p ${DESTDIR} ${DESTINC}

# # sources
for item in `find ${SRCDIR} -type f`; do
  cp -f ${item} ${DESTDIR}/
done

# additional sources
for item in `find ${SRC2DIR} -type f`; do
  cp -f ${item} ${DESTDIR}/
done

cp -arf ${SRCINC}/* ${DESTINC}/

cp -f ${SRCDIR}/../_.s ${DESTDIR}/
cp -f ${SRCDIR}/../.gitignore ${DESTDIR}/
cp -f ${SRCDIR}/../.gitignore ${DESTINC}/
