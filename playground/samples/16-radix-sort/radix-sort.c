// Radix Sort in C Programming

// original source: https://www.programiz.com/dsa
#include "../sort-helper.h"

// Function to get the largest element from an array
int getMax(int array[], int n)
{
  int i;
  int max = array[0];
  for(i = 1; i < n; i++)
    if(array[i] > max)
      max = array[i];
  return max;
}

int count[256];
int output[datasize];

// Using counting sort to sort the elements in the basis of significant places
void countingSort(int array[], int size, int place)
{
  int i;
  int max = (array[0] / place) % 10;

  for(i = 1; i < size; i++)
  {
    if(((array[i] / place) % 10) > max)
      max = array[i];
  }

  for(i = 0; i < max; ++i)
    count[i] = 0;

  // Calculate count of elements
  for(i = 0; i < size; i++)
    count[(array[i] / place) % 10]++;

  // Calculate cumulative count
  for(i = 1; i < 10; i++)
    count[i] += count[i - 1];

  // Place the elements in sorted order
  for(i = size - 1; i >= 0; i--)
  {
    output[count[(array[i] / place) % 10] - 1] = array[i];
    count[(array[i] / place) % 10]--;
  }

  for(i = 0; i < size; i++)
    array[i] = output[i];
}

// Main function to implement radix sort
void radixsort(int array[], int size)
{
  int place;
  // Get maximum element
  int max = getMax(array, size);

  // Apply counting sort to sort elements based on place value.
  for(place = 1; max / place > 0; place *= 10)
    countingSort(array, size, place);
}

// Driver code
int main(void)
{
  radixsort(data, datasize);
  printArray(data, datasize);
  return 0;
}
