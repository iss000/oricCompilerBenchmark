// mandelbrot sample based on idea of:
// https://people.sc.fsu.edu/~jburkardt/c_src/mandelbrot_ascii/mandelbrot_ascii.html

#include <conio.h>

/* Graphics definitions */
#define SCREEN_X (64)
#define SCREEN_Y (64)

void mandelbrot(void)
{
  long r, i, R, I, b, n;
  for(i = -100; i < 100; i += 6)
  {
    for(r = -200; I = i, (R = r) < 100; r += 3)
    {
      for(n = 0; b = I * I, 2600 > n++ && R * R + b < 400; I = 2 * R * I + i, R = R * R - b + r)
      {
        _putc(n + 31);
      }
    }
    _putc('\n');
  }
}

int main(void)
{
  /* calc mandelbrot set */
  mandelbrot();

  /* Done */
  return 0;
}
