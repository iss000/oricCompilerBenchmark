#include <conio.h>

#define number 4096

static int i,j;
static int primes[number+1];
static char buf[32];

static void decprint(int v)
{
  // dec print
  for(j=0; j < sizeof(buf)/sizeof(char);)
  {
    buf[j++] = '0' + v % 10;
    v /= 10;
    if(0==v)
      break;
  }

  while(j > 0)
  {
    --j;
    _putc(buf[j]);
  }
  _putc(' ');
}

int main(void)
{
  //populating array with naturals numbers
  for(i = 2; i<=number; i++)
    primes[i] = i;

  i = 2;
  while((i*i) <= number)
  {
    if(primes[i] != 0)
    {
      for(j=2; j<number; j++)
      {
        if(primes[i]*j > number)
          break;
        else
          // Instead of deleteing , making elemnets 0
          primes[primes[i]*j]=0;
      }
    }
    i++;
  }

  for(i = 2; i<=number; i++)
  {
    //If number is not 0 then it is prime
    if(primes[i]!=0)
      decprint(primes[i]);
  }

  return 0;
}
