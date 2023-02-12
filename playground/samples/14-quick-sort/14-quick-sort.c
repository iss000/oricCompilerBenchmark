// Quick sort in C

// original source: https://www.programiz.com/dsa
#include "../sort-helper.h"

// function to swap elements
void swap(int* a, int* b)
{
  int t = *a;
  *a = *b;
  *b = t;
}

// function to find the partition position
int partition(int array[], int low, int high)
{

  // select the rightmost element as pivot
  int pivot = array[high];

  // pointer for greater element
  int j, i = (low - 1);

  // traverse each element of the array
  // compare them with the pivot
  for(j = low; j < high; j++)
  {
    if(array[j] <= pivot)
    {

      // if element smaller than pivot is found
      // swap it with the greater element pointed by i
      i++;

      // swap element at i with element at j
      swap(&array[i], &array[j]);
    }
  }

  // swap the pivot element with the greater element at i
  swap(&array[i + 1], &array[high]);

  // return the partition point
  return (i + 1);
}

void quickSort(int array[], int low, int high)
{
  int pi;
  if(low < high)
  {

    // find the pivot element such that
    // elements smaller than pivot are on left of pivot
    // elements greater than pivot are on right of pivot
    pi = partition(array, low, high);

    // recursive call on the left of pivot
    quickSort(array, low, pi - 1);

    // recursive call on the right of pivot
    quickSort(array, pi + 1, high);
  }
}

// main function
int main(void)
{
  quickSort(data, 0, datasize - 1);
  printArray(data, datasize);
  return 0;
}
