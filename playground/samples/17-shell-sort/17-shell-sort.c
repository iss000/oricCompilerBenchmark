// Shell Sort in C programming

// original source: https://www.programiz.com/dsa
#include "../sort-helper.h"

// Shell sort
void shellSort(int array[], int n)
{
  int i,j,temp,interval;
  // Rearrange elements at each n/2, n/4, n/8, ... intervals
  for(interval = n / 2; interval > 0; interval /= 2)
  {
    for(i = interval; i < n; i += 1)
    {
      temp = array[i];
      for(j = i; j >= interval && array[j - interval] > temp; j -= interval)
      {
        array[j] = array[j - interval];
      }
      array[j] = temp;
    }
  }
}

// Driver code
int main(void)
{
  shellSort(data, datasize);
  printArray(data, datasize);
  return 0;
}
