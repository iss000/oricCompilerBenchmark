#include <types.h>

static uint8_t* dst = MEMPTR(0x4000);
static uint8_t* src = MEMPTR(0x2000);
static const uint16_t len = 0x2000;
static uint16_t i;

int main(void)
{
  for(i = 0; i < len; ++i)
  {
    dst[i] = src[i];
  }
  return 0;
}
