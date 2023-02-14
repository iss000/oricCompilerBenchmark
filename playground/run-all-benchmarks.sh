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
  ./tools/report-csv-js.lua $i www/bench-$i.csv www/bench-$i.js $DATE || exit 1
  # ./tools/report-csv-html.lua www/bench-$i.csv www/bench-$i.html || exit 1
  mv obj obj-$i
  mv bin bin-$i
done
tar -cjf www/bench-data-$DATE.tar.bz2 bin-{size,speed}/ obj-{size,speed}/ www/bench-{size,speed}.js
