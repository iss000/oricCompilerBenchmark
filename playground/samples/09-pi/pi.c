#include <conio.h>

#define NUM_DIG 560

#define SCALE 10000
#define ARRINIT 2000

static long arr[NUM_DIG + 1];
static char digits_s[32];
static int digits_dt;
static int digits_c;

void pi_digits(int digits)
{
  long carry = 0;
  int i,j;
  long sum, temp;

  for(i = 0; i <= digits; ++i)
    arr[i] = ARRINIT;
  for(i = digits; i > 0; i-= 14)
  {
    sum = 0;
    for(j = i; j > 0; --j)
    {
      sum = sum * j + SCALE * arr[j];
      arr[j] = sum % (j * 2 - 1);
      sum /= j * 2 - 1;
    }

    // dec print
    temp = carry + sum / SCALE;
    for(digits_c=0; digits_c < 4; temp /= 10)
      digits_s[digits_c++] = '0' + temp % 10;

    while(digits_c > 0)
    {
      if(digits_dt == 1)
        _putc('.');
      ++digits_dt;

      --digits_c;
      _putc(digits_s[digits_c]);
    }

    carry = sum % SCALE;
  }
}

int main(void)
{
  _puts("pi="); pi_digits(NUM_DIG); _putc('\n');
  return 0;
}
