#!/bin/bash

SRCDIR=$(dirname $0)/src
SRC2DIR=$(dirname $0)/src2
DESTDIR=$(dirname $0)/../libgcc-6502-src


rm -rf ${DESTDIR}
mkdir -p ${DESTDIR}

# lib1funcs.S + addsf3.S
ITEMS=`cat ${SRCDIR}/lib1funcs.S| grep '#ifdef'| sed -e 's/^.*\ //g'`
# echo $ITEMS
for item in $ITEMS; do
  cpp -E ${SRCDIR}/lib1funcs.S -D${item} -o ${DESTDIR}/_${item:1}.s
  sed -i ${DESTDIR}/_${item:1}.s -e '/^#/d'
done

# crt0.S
item=${SRCDIR}/crt0.S
item1=crt0.tmp
otem=${DESTDIR}/_$(basename ${item/.S/.orig})
cat $item| sed -e 's/^#error.*/        rts/g' > $item1
cpp -E $item1 -o $otem && rm -f $item1
sed -i $otem -e '/^#/d'
# # #
sed -i $otem -e 's/^        lda #38/\n__STARTUP__:/g'
sed -i $otem -e 's/^        sta 1/_start:/g'

# softregs.S -> _zeropage.s
item=${SRCDIR}/softregs.S
otem=${DESTDIR}/_zeropage.s
cpp -E $item -o $otem
sed -i $otem -e '/^#/d'

# savestack.S
item=${SRCDIR}/savestack.S
otem=${DESTDIR}/$(basename ${item/.S/.s})
cpp -E $item -o $otem
sed -i $otem -e '/^#/d'

# savestack_sp.S
item=${SRCDIR}/savestack_sp.S
otem=${DESTDIR}/$(basename ${item/.S/.s})
cpp -E $item -o $otem
sed -i $otem -e '/^#/d'

# fprenorm-left.S
item=${SRCDIR}/fprenorm-left.S
otem=${DESTDIR}/$(basename ${item/.S/.s})
cpp -E $item -o $otem
sed -i $otem -e '/^#/d'

# fprenorm-right.S
item=${SRCDIR}/fprenorm-right.S
otem=${DESTDIR}/$(basename ${item/.S/.s})
cpp -E $item -o $otem
sed -i $otem -e '/^#/d'

# softfpregs.S
item=${SRCDIR}/softfpregs.S
otem=${DESTDIR}/$(basename ${item/.S/.s})
cpp -E $item -o $otem
sed -i $otem -e '/^#/d'

# additional sources
for item in `find ${SRC2DIR} -type f`; do
  cp -f ${item} ${DESTDIR}/
done

cp -f ${SRCDIR}/../_.s ${DESTDIR}/
cp -f ${SRCDIR}/../.gitignore ${DESTDIR}/
