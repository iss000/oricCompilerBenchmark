/*
 *   Simple front-end for aes 256 targeting Oric-1/Atmos computers.
 *   No external library functions needed. For benchmarking purposes only.
 *
 *   Copyleft (c) 2022 iss
 *
 *   Permission to use, copy, modify, and distribute this software for any
 *   purpose with or without fee is hereby granted, provided that the above
 *   copyright notice and this permission notice appear in all copies.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *   WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *   MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *   ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *
 */

#include <conio.h>

// #define BACK_TO_TABLES

#include <aes256.h>

static void xprintc(const char c);
static void xprints(const char* s);
// static void xprinti(unsigned int val);
static void xdump(char* s, unsigned char i, unsigned char* buf, unsigned char sz);

static aes256_context ctx;
static unsigned char key[32];
static unsigned char buf[32];
static unsigned char i;

int main(void) //int argc, char* argv[])
{
  //     xprints("SIZE OF KEY:");
  //     xprinti(sizeof(key));
  //     xprintc('\n');
  //     xprints("SIZE OF BUF:");
  //     xprinti(sizeof(buf));
  //     xprintc('\n');
  /* put a test vector */
  for(i = 0; i < sizeof(buf); i++)
    buf[i] = i & 1 ? 0x55 : 0xaa;
  for(i = 0; i < sizeof(key); i++)
    key[i] = i;

  xdump("TXT: ", i, buf, sizeof(buf));
  xdump("KEY: ", i, key, sizeof(key));
  xprints("---- ----------------------------------------------------------------\n");

  aes256_init(&ctx, key);
  aes256_encrypt_ecb(&ctx, &buf[0]);
  aes256_encrypt_ecb(&ctx, &buf[16]);

  xdump("ENC: ", i, buf, sizeof(buf));
  xprints("OK?: DD2EF27CA800C474EB1B13C853D45EC0DD2EF27CA800C474EB1B13C853D45EC0\n");
  xprints("---- ----------------------------------------------------------------\n");

  aes256_init(&ctx, key);
  aes256_decrypt_ecb(&ctx, &buf[0]);
  aes256_decrypt_ecb(&ctx, &buf[16]);

  xdump("DEC: ", i, buf, sizeof(buf));

  aes256_done(&ctx);

  return 0;
} /* main */

// static char valbuf[10];
// static void xprinti(unsigned int val)
// {
//  char k = 0;
//  if (0 == val)
//    xprintc('0');
//  else
//  {
//    while (0 != val)
//    {
//      valbuf[k] = '0' + val % 10;
//      val /= 10;
//      k++;
//    }
//    while (k-- > 0)
//      xprintc(valbuf[k]);
//  }
// }

static void xprintc(const char c)
{
  _putc(c);
}

static void xprints(const char* s)
{
  _puts(s);
}

static void xdump(char* s, unsigned char i, unsigned char* buf, unsigned char sz)
{
  unsigned char a, b;
  xprints(s);
  for(i = 0; i < sz; i++)
  {
    a = buf[i] / 16;
    a += ((a < 10) ? '0' : 'A' - 10);
    b = buf[i] % 16;
    b += ((b < 10) ? '0' : 'A' - 10);
    xprintc(a);
    xprintc(b);
  }
  xprintc('\n');
}
