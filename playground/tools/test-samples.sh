#!/bin/bash

if [ x"$(basename $(pwd))" != x"samples" ]
then
  echo "$0 must be called from samples/ directory"
  echo "i.e. use: ../tools/$(basename $0)"
  exit 1
fi

ALL="
  00-type-sizes
  01-dummy
  02-hello-world
  03-bytecpy
  04-memcopy
  05-0xcafe
  06-sieve
  07-aes256
  08-mandelbrot
  09-frogmove
  10-pi
  11-shuffle
  12-bubble-sort
  13-selection-sort
  14-insertion-sort
  15-merge-sort
  16-quick-sort
  17-counting-sort
  18-radix-sort
  19-shell-sort
  20-heap-sort
"

rm -rf test-samples
mkdir -p test-samples

for i in $ALL
do
  echo "$i: ./test-samples/$i.bin"
  gcc -o test-samples/$i.bin $i/*.c ../libmos6502vm/_puts.c \
    -I. -I../libmos6502vm \
    -D__HOST_C__ \
    -D_putc=putchar \
    -Wall \
    -Wno-implicit-function-declaration \
    -Wno-builtin-declaration-mismatch \
    -Wno-int-to-pointer-cast \
    -Wno-pointer-to-int-cast \
    -Wno-char-subscripts \
    -Wno-unused-variable \
    -g3 \
  && ./test-samples/$i.bin > test-samples/$i.txt #|| exit 1
done
