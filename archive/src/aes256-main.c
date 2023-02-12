/*
 *   Simple front-end for aes 256 targeting Oric-1/Atmos computers.
 *   No external library functions needed. For benchmarking purposes only.
 *
 *   Copyleft (c) 2021 iss
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

#include "aes256.c"

#define STRINGIFY_(x) #x
#define STRINGIFY(x) STRINGIFY_(x)

#define peek(addr)          (*((unsigned char*)(addr)))
#define poke(addr, val)     {*((unsigned char*)(addr)) = val;}
#define call(addr)          ((void (*)())(addr))()

// atmos & oric-1 cls
#define atmos_cls           0xccce
#define oric1_cls           0xcc0a
#define is_atmos()          (0x44==peek(0xfffe))
#define cls()               call(is_atmos()?atmos_cls:oric1_cls)

static int px = 0;
static int py = 0;
static char* scrn = (char*)0xbb80;

static void xcls(void);
static void xprintc(const char c);
static void xprints(const char* s);
static void xprinti(unsigned int val);
static void xdump(char* s, unsigned char i, unsigned char* buf, int sz);

unsigned int delay;

static aes256_context ctx;
static unsigned char key[32];
static unsigned char buf[16];
static unsigned char i;

int main (void) //int argc, char* argv[])
{
  cls();
  poke(0x276,0);
  poke(0x26a,10);

  xcls();

  xprints(STRINGIFY(NAME)"\n\n");

  /* put a test vector */
  for (i = 0; i < sizeof(buf); i++) buf[i] = i * 16 + i;
  for (i = 0; i < sizeof(key); i++) key[i] = i;

  xdump("TXT:", i, buf, sizeof(buf));
  xdump("KEY:", i, key, sizeof(key));
  xprints("---\n");

  aes256_init(&ctx, key);
  aes256_encrypt_ecb(&ctx, buf);

  xdump("ENC: ", i, buf, sizeof(buf));
  xprints("TST:\n8EA2B7CA516745BFEAFC49904B496089\n");

  aes256_init(&ctx, key);
  aes256_decrypt_ecb(&ctx, buf);
  xdump("DEC: ", i, buf, sizeof(buf));

  aes256_done(&ctx);
  xprints("---\n");
  delay = 65536 - (*(unsigned int*)0x276);
  xprints("TIME:  ");
  xprinti(delay / 100);
  xprintc('.');
  xprinti(delay % 100);
  xprints(" [SEC]\n");

  return 0;
} /* main */

static void xcls(void)
{
  for(py=0; py<28; py++)
    for(px=0; px<40; px++)
      poke(0xbb80+40*py+px,0x20);

  px = 0;
  py = 5;
}

static char valbuf[10];
static void xprinti(unsigned int val)
{
  char k = 0;
  if(0==val)
    xprintc('0');
  else
  {
    while(0 != val)
    {
      valbuf[k] = '0' + val % 10;
      val /= 10;
      k++;
    }
    while(k-->0)
      xprintc(valbuf[k]);
  }
}

static void xprintc(const char c)
{
  if('\n' == c)
    px=40;
  else
  {
    poke(scrn+py*40+px, c);
    ++px;
  }

  if(px == 40)
  {
    px = 0;
    ++py;
    if(py == 28)
      py = 2;
  }
}

static void xprints(const char* s)
{
  while(s && *s)
    xprintc(*s++);
}

static void xdump(char* s, unsigned char i, unsigned char* buf, int sz)
{
  unsigned char a,b;
  xprints(s);
  for (i = 0; i < (sz); i++)
  {
    if(0==(i%16))
      xprintc('\n');
    a = buf[i]/16;
    a += ((a<10)? '0' : 'A'-10);
    b = buf[i]%16;
    b += ((b<10)? '0' : 'A'-10);
    xprintc(a);
    xprintc(b);
  }
  xprintc('\n');
}
