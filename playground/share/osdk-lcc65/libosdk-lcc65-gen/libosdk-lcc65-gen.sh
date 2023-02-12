#!/bin/sh

cd $(dirname $0)

SRCDIR=$(dirname $0)/src
SRC2DIR=$(dirname $0)/src2
DESTDIR=$(dirname $0)/../libosdk-lcc65-src


rm -rf ${DESTDIR}
mkdir -p ${DESTDIR}

# sources
for item in `find ${SRCDIR} -type f`; do
  cp -f ${item} ${DESTDIR}/
done

# additional sources
for item in `find ${SRC2DIR} -type f`; do
  cp -f ${item} ${DESTDIR}/
done

cp -f ${SRCDIR}/../_.s ${DESTDIR}/
cp -f ${SRCDIR}/../.gitignore ${DESTDIR}/
