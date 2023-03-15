// Relatively straigtforward implementation of long division in C. Not
// particularly tuned for performance, but clear.

#define __inlinefunc

static __inlinefunc unsigned udiv(unsigned a, unsigned b)
{
  if(!b || b > a)
    return 0;

  // Here b <= a.

  // Shift b as far left as possible without exceeding a. If the hightest bit of
  // b is 1, then the next shift, if were performed at a higher bit width, would
  // make it exceed a.
  char num_digits_remaining = 0;
  while(!(b & 1 << (sizeof(unsigned) * 8 - 1)) && (b << 1) <= a)
  {
    b <<= 1;
    ++num_digits_remaining;
  }

  // Since b <= a, the first digit is always 1. This is not counted in
  // num_digits_remaining.
  unsigned q = 1;
  a -= b;
  b >>= 1;

  for(; num_digits_remaining; --num_digits_remaining)
  {
    // Prepare q to receive the next digit as its LSB.
    q <<= 1;

    // If the quotient digit is a 1
    if(b <= a)
    {
      q |= 1;

      // Subtract out 1 * the divisor.
      a -= b;
    }

    // The next quotient digit corrsponds to one smaller power of 2 times the
    // divisor.
    b >>= 1;
  }

  return q;
}

static __inlinefunc unsigned umod(unsigned a, unsigned b)
{
  if(!b || b > a)
    return a;

  // Here b <= a.

  // Shift b as far left as possible without exceeding a. If the hightest bit of
  // b is 1, then the next shift, if were performed at a higher bit width, would
  // make it exceed a.
  char num_digits_remaining = 0;
  while(!(b & 1 << (sizeof(unsigned) * 8 - 1)) && (b << 1) <= a)
  {
    b <<= 1;
    ++num_digits_remaining;
  }

  // Since b <= a, the first digit is always 1. This is not counted in
  // num_digits_remaining.
  a -= b;
  b >>= 1;

  for(; num_digits_remaining; --num_digits_remaining)
  {
    // If the quotient digit is a 1
    if(b <= a)
    {
      // Subtract out 1 * the divisor.
      a -= b;
    }

    // The next quotient digit corrsponds to one smaller power of 2 times the
    // divisor.
    b >>= 1;
  }

  return a;
}

static __inlinefunc unsigned udivmod(unsigned a, unsigned b, char* rem)
{
  if(!b || b > a)
  {
    *rem = a;
    return 0;
  }

  // Here b <= a.

  // Shift b as far left as possible without exceeding a. If the hightest bit of
  // b is 1, then the next shift, if were performed at a higher bit width, would
  // make it exceed a.
  char num_digits_remaining = 0;
  while(!(b & 1 << (sizeof(unsigned) * 8 - 1)) && (b << 1) <= a)
  {
    b <<= 1;
    ++num_digits_remaining;
  }

  // Since b <= a, the first digit is always 1. This is not counted in
  // num_digits_remaining.
  unsigned q = 1;
  a -= b;
  b >>= 1;

  for(; num_digits_remaining; --num_digits_remaining)
  {
    // Prepare q to receive the next digit as its LSB.
    q <<= 1;

    // If the quotient digit is a 1
    if(b <= a)
    {
      q |= 1;

      // Subtract out 1 * the divisor.
      a -= b;
    }

    // The next quotient digit corrsponds to one smaller power of 2 times the
    // divisor.
    b >>= 1;
  }

  *rem = a;
  return q;
}

// extern "C" {
char __udivqi3(char a, char b)
{
  return udiv(a, b);
}
unsigned __udivhi3(unsigned a, unsigned b)
{
  return udiv(a, b);
}
unsigned long __udivsi3(unsigned long a, unsigned long b)
{
  return udiv(a, b);
}
unsigned long long __udivdi3(unsigned long long a, unsigned long long b)
{
  return udiv(a, b);
}

char __umodqi3(char a, char b)
{
  return umod(a, b);
}
unsigned __umodhi3(unsigned a, unsigned b)
{
  return umod(a, b);
}
unsigned long __umodsi3(unsigned long a, unsigned long b)
{
  return umod(a, b);
}
unsigned long long __umoddi3(unsigned long long a, unsigned long long b)
{
  return umod(a, b);
}

char __udivmodqi4(char a, char b, char* rem)
{
  return udivmod(a, b, rem);
}
unsigned __udivmodhi4(unsigned a, unsigned b, char* rem)
{
  return udivmod(a, b, rem);
}

// Version of abs that returns INT_MIN for INT_MIN, without undefined behavior.
static __inlinefunc char safe_abs(char a)
{
  unsigned char int_min = (unsigned char)(1) << (sizeof(unsigned char) * 8 - 1);
  unsigned char ua = (unsigned char)(a);
  return (char)((a >= 0 || ua == int_min) ? ua : (-a));
}


static __inlinefunc char divmod(char a, char b, char* rem)
{
  char urem;
  char uq = (char)(udivmod(safe_abs(a), safe_abs(b), &urem));

  // Negating int_min here is fine, since it's only undefined behavior if the
  // signed division itself is.
  *rem = a < 0 ? -urem : urem;
  return (a < 0 != b < 0) ? -uq : uq;
}


#define div(a,b) (a/b)
char __divqi3(char a, char b)
{
  return div(a, b);
}
int __divhi3(int a, int b)
{
  return div(a, b);
}
long __divsi3(long a, long b)
{
  return div(a, b);
}
long long __divdi3(long long a, long long b)
{
  return div(a, b);
}

#define mod(a,b) (a%b)
char __modqi3(char a, char b)
{
  return mod(a, b);
}
int __modhi3(int a, int b)
{
  return mod(a, b);
}
long __modsi3(long a, long b)
{
  return mod(a, b);
}
long long __moddi3(long long a, long long b)
{
  return mod(a, b);
}

char __divmodqi4(char a, char b, char* rem)
{
  return divmod(a, b, rem);
}
int __divmodhi4(int a, int b, char* rem)
{
  return divmod(a, b, rem);
}


// These can are large enough to pull in the stack pointer, so break them out
// into a separate file so they can be compiled without LTO.

unsigned long __udivmodsi4(unsigned long a, unsigned long b,
                           unsigned long* rem)
{
  return udivmod(a, b, rem);
}
unsigned long long __udivmoddi4(unsigned long long a, unsigned long long b,
                                unsigned long long* rem)
{
  return udivmod(a, b, rem);
}
long __divmodsi4(long a, long b, long* rem)
{
  return divmod(a, b, rem);
}
long long __divmoddi4(long long a, long long b, long long* rem)
{
  return divmod(a, b, rem);
}
