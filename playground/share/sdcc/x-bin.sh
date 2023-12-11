#!/bin/bash
ofile=${1}; shift
ifile=${1}; shift

# ${BASE}/bin/sdobjcopy \
# --input-target=ihex --output-target=binary \
# -S --discard-all --writable-text \
# ${ifile} ${ofile}

# ${BASE}/bin/sdobjcopy \
# --input-target=srec --output-target=binary \
# -S --discard-all --writable-text \
# ${ifile} ${ofile}

# ${BASE}/bin/makebin -s 65536 -p ${ifile} ${ofile}

# START_ADDRESS=0x0800
# LAST="0x$(cat ${ifile/.prg/.map}|grep '^C:'|cut -d' ' -f4|sort |tail -1)"
# ${BASE}/../hex2bin -e bin -l $(( $LAST - $START_ADDRESS )) ${ifile}
# cp -f ${ifile/.prg/.bin} ${ofile}

cp -f ${ifile} ${ofile}
