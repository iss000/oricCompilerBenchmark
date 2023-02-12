// #include <string.h>

extern char __bss_start[];
extern char __bss_end[];
extern void __memset(char *ptr, char value, unsigned int num);

void __zero_bss(void) {
  __memset(__bss_start, 0, __bss_end - __bss_start);
}
