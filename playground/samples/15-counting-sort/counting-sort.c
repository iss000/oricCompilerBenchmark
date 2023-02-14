// Counting sort in C programming

// original source: https://www.programiz.com/dsa
#include "../sort-helper.h"

// The size of count must be at least (max+1) but
// we cannot declare it as int count(max+1) in C as
// it does not support dynamic memory allocation.
// So, its size is provided statically.
int count[256];
int output[datasize];

void countingSort(int array[], int size)
{
  int i;

  // Find the largest element of the array
  int max = array[0];
  for(i = 1; i < size; i++)
  {
    if(array[i] > max)
      max = array[i];
  }

  // Initialize count array with all zeros.
  for(i = 0; i <= max; ++i)
  {
    count[i] = 0;
  }

  // Store the count of each element
  for(i = 0; i < size; i++)
  {
    count[array[i]]++;
  }

  // Store the cummulative count of each array
  for(i = 1; i <= max; i++)
  {
    count[i] += count[i - 1];
  }

  // Find the index of each element of the original array in count array, and
  // place the elements in output array
  for(i = size - 1; i >= 0; i--)
  {
    output[count[array[i]] - 1] = array[i];
    count[array[i]]--;
  }

  // Copy the sorted elements into original array
  for(i = 0; i < size; i++)
  {
    array[i] = output[i];
  }
}

// Driver code
int main(void)
{
  countingSort(data, datasize);
  printArray(data, datasize);
  return 0;
}
