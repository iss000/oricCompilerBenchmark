#!/bin/sh

if [ x"$(basename $(pwd))" != x"samples" ]
then
  echo "$0 must be called from samples/ directory"
  echo "i.e. use: ../tools/$(basename $0)"
  exit 1
fi

ALL=(
  'type-sizes'
  'dummy'
  'hello-world'
  'bytecpy'
  'memcopy'
  '0xcafe'
  'sieve'
  'aes256'
  'mandelbrot'
  'frogmove'
  'pi'
  'shuffle'
  'bubble-sort'
  'selection-sort'
  'insertion-sort'
  'merge-sort'
  'quick-sort'
  'counting-sort'
  'radix-sort'
  'shell-sort'
  'heap-sort'
)

# change 'echo' to 'mv' to real execute
safe_mv=echo

for ((idx=0; idx<${#ALL[@]}; ++idx)); do
  n=`printf "%.2d-%s" "$idx" "${ALL[idx]}"`
  o=`find . -type d -name "*-${ALL[idx]}" |sed -e s#./##`
  [ x"$o" != x"$n" ] && $safe_mv $o $n
done
