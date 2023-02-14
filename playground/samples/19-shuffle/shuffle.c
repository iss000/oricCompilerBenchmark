// Shuffle in C

// Generate shuffled array as input for the sort algo's

#include "../sort-helper.h"

static long seed = 0x55aa55aa;
static int rando(void)
{
  seed = (69069 * seed) + 1234567;
  return 0x7fff & seed;
}

void swap(int a, int b)
{
  int temp = data[a];
  data[a] = data[b];
  data[b] = temp;
}

int main(void)
{
  int i;

  // prepare array
  for(i=0; i<datasize; ++i)
    data[i] = i;

  // Fisher-Yates shuffle:
  // swap element with random later element
  for(i=datasize-1; i > 0; --i)
    swap(i, rando() % (i + 1));

  // Stupid shuffle :)
  for(i=0; i<datasize; ++i)
    swap(i, rando() % datasize);

  printArray(data, datasize);
  return 0;
}
