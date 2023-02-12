#!/bin/sh

PASSES="size speed"
DATE="$(date '+%Y-%m-%d')"

rm -rf bin/ obj/ bin-{size,speed}/ obj-{size,speed}/ www/bin-obj-*.tar.bz2

#
for i in $PASSES
do
  rm -rf bin/ obj/ bin-$i/ obj-$i/
  ./tools/bench.lua $i || exit 1
  ./tools/report-csv-js.lua $i www/bench-$i.csv www/bench-$i.js $DATE || exit 1
  # ./tools/report-csv-html.lua www/bench-$i.csv www/bench-$i.html || exit 1
  mv obj obj-$i
  mv bin bin-$i
  # for j in bin-$i/*-frogmove.bin; do ./tools/oheader.lua $j 0x800; done
done
tar -cjf www/bin-obj-$DATE.tar.bz2 bin-*/ obj-*/
