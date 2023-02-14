// Bubble sort in C

// original source: https://www.programiz.com/dsa
#include "../sort-helper.h"

// perform the bubble sort
void bubbleSort(int array[], int size)
{
  int step, i, temp;
  // loop to access each array element
  for(step = 0; step < size - 1; ++step)
  {

    // loop to compare array elements
    for(i = 0; i < size - step - 1; ++i)
    {

      // compare two adjacent elements
      // change > to < to sort in descending order
      if(array[i] > array[i + 1])
      {

        // swapping occurs if elements
        // are not in the intended order
        temp = array[i];
        array[i] = array[i + 1];
        array[i + 1] = temp;
      }
    }
  }
}

int main(void)
{
  bubbleSort(data, datasize);
  printArray(data, datasize);
  return 0;
}
