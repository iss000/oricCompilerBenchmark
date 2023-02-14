// Selection sort in C

// original source: https://www.programiz.com/dsa
#include "../sort-helper.h"

// function to swap the the position of two elements
void swap(int* a, int* b)
{
  int temp = *a;
  *a = *b;
  *b = temp;
}

void selectionSort(int array[], int size)
{
  int step, i;
  for(step = 0; step < size - 1; step++)
  {
    int min_idx = step;
    for(i = step + 1; i < size; i++)
    {

      // To sort in descending order, change > to < in this line.
      // Select the minimum element in each loop.
      if(array[i] < array[min_idx])
        min_idx = i;
    }

    // put min at the correct position
    swap(&array[min_idx], &array[step]);
  }
}

// driver code
int main(void)
{
  selectionSort(data, datasize);
  printArray(data, datasize);
  return 0;
}
