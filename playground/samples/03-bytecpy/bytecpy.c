#include <types.h>

int main(void)
{
  *(char*)MEMPTR(0x4000) = *(char*)MEMPTR(0x2000);
  return 0;
}
