#!/bin/sh

PASSES="size speed"
DATE="$(date '+%Y-%m-%d')"

rm -rf bin/ obj/ bin-{size,speed}/ obj-{size,speed}/

#
for i in $PASSES
do
  rm -rf bin/ obj/
  ./tools/bench.lua $i || exit 1
  # for j in bin/*-frogmove.bin; do ./tools/oheader.lua $j 0x800; done
  mv obj obj-$i
  mv bin bin-$i
done
#
for i in $PASSES
do
  ./tools/report-csv-js.lua $i www/bench-$i.csv www/bench-$i.js $DATE || exit 1
done
#
tar -cjf www/bench-data-$DATE.tar.bz2 bin-{size,speed}/ obj-{size,speed}/ www/bench-{size,speed}.{js,csv} www/date-{size,speed}.js
