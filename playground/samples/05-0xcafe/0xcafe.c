#include <conio.h>

static char hex[] = "0123456789ABCDEF";
static void puthex(unsigned int val)
{
  unsigned char t;
  t = (val >> 12) &0x0f; _putc(hex[t]);
  t = (val >>  8) &0x0f; _putc(hex[t]);
  t = (val >>  4) &0x0f; _putc(hex[t]);
  t = (val >>  0) &0x0f; _putc(hex[t]);
}

static unsigned int Oxcafe = 0b1100101011111110;
int main(void)
{
  _puts("0XCAFE == 0X");
  puthex(Oxcafe);
  _puts(Oxcafe == 0xcafe? " :)":" :(");
  _putc(LF);

  return 0;
}
