#!/bin/sh

ALL="
  00-dummy
  01-hello-world
  02-type-sizes
  03-memcopy
  04-sieve
  05-aes256
  06-mandelbrot
  07-bytecpy
  08-frogmove
  09-pi
  10-bubble-sort
  11-selection-sort
  12-insertion-sort
  13-merge-sort
  14-quick-sort
  15-counting-sort
  16-radix-sort
  17-shell-sort
  18-heap-sort
  19-shuffle
"

rm -rf test-samples
mkdir -p test-samples

for i in $ALL
do
  echo "$i: ./test-samples/$i.bin"
  gcc -o test-samples/$i.bin $i/*.c -g3 \
    -I. -I../libmos6502vm \
    -D_putc=putchar -D_puts=puts \
    -Wall \
    2>/dev/null \
  && ./test-samples/$i.bin > test-samples/$i.txt #|| exit 1
done
#
