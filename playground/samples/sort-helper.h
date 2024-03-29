#ifndef __SORT_HELPER__
#define __SORT_HELPER__

#include <conio.h>

static char valbuf[10];
static int __k;
static int __i;

static void _putint(int val)
{
  __k = 0;
  if(0 == val)
    _putc('0');
  else
  {
    while(0 != val)
    {
      valbuf[__k] = '0' + (val % 10);
      val /= 10;
      __k++;
    }
    while(__k-- > 0)
      _putc(valbuf[__k]);
  }
}


#define datasize  256
static int data[datasize] =
{
  65,24,184,38,214,96,55,231,138,193,186,75,20,94,189,63,242,132,124,74,11,29,226,200,
  26,15,170,69,35,211,32,40,129,92,4,22,161,6,27,153,54,213,142,148,140,68,23,91,47,245,
  204,13,36,175,18,177,162,117,120,85,100,110,164,9,128,81,143,17,119,206,62,185,58,157,
  130,134,107,99,126,180,34,59,49,232,178,45,252,248,168,199,93,125,0,165,70,122,98,196,
  28,111,234,95,80,158,156,197,151,112,203,221,240,205,89,90,150,241,166,51,108,249,97,3,
  60,73,44,83,144,191,190,163,174,208,56,218,50,247,61,76,237,115,154,173,104,183,37,233,
  64,30,210,77,114,194,229,48,152,255,8,243,160,246,136,188,43,228,235,123,86,201,172,141,
  225,147,121,57,212,87,71,182,10,217,113,31,16,192,131,236,42,198,159,149,103,219,139,167,
  116,5,118,53,88,25,250,1,14,202,78,230,106,169,7,171,19,227,137,216,220,195,79,155,102,
  209,187,222,176,251,207,135,238,33,244,67,84,179,52,101,127,21,66,133,109,215,254,181,
  72,105,12,253,39,41,46,223,2,145,146,224,82,239
};

// print array
void printArray(int array[], int size)
{
  for(__i = 0; __i < size; ++__i)
  {
    if(0<__i)
      _putc(',');
    _putint(array[__i]);
  }
  _putc('\n');
}

#endif /* __SORT_HELPER__ */
