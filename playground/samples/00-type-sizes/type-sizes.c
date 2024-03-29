#include <conio.h>
#include <compat.h>

static unsigned int sizeof_char;
static unsigned int sizeof_short;
static unsigned int sizeof_int;
static unsigned int sizeof_long;

static char valbuf[10];
static void putint(unsigned int val)
{
  unsigned char k = 0;
  if(0 == val)
    _putc('0');
  else
  {
    while(0 != val)
    {
      valbuf[k] = '0' + (char)_modr16u(val, 10, 0);
      val = _div16u(val, 10);
      k++;
    }
    while(k-- > 0)
      _putc(valbuf[k]);
  }
}

int main(void)
{
  sizeof_char = sizeof(char);
  sizeof_short = sizeof(short);
  sizeof_int = sizeof(int);
  sizeof_long = sizeof(long);

  _puts("SIZE OF CHAR  :");
  putint(sizeof_char);
  _putc(LF);

  _puts("SIZE OF SHORT :");
  putint(sizeof_short);
  _putc(LF);

  _puts("SIZE OF INT   :");
  putint(sizeof_int);
  _putc(LF);

  _puts("SIZE OF LONG  :");
  putint(sizeof_long);
  _putc(LF);

  return 0;
}
