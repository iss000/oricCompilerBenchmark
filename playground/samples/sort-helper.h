#ifndef __SORT_HELPER__
#define __SORT_HELPER__

#include <conio.h>

static char valbuf[10];
static int __k;
static int __i;

static void _putint(int val)
{
  __k = 0;
  if (0 == val)
    _putc('0');
  else
  {
    while (0 != val)
    {
      valbuf[__k] = '0' + (val % 10);
      val /= 10;
      __k++;
    }
    while (__k-- > 0)
      _putc(valbuf[__k]);
  }
}


#define datasize  10
static int data[datasize] = { 71, 2, 45, 0, 11, 9, 100, 88, 24, 57 };

// print array
void printArray(int array[], int size) {
  for (__i = 0; __i < size; ++__i) {
    if(0<__i)
      _putc(',');
    _putint(array[__i]);
  }
  _putc('\n');
}

#endif /* __SORT_HELPER__ */
