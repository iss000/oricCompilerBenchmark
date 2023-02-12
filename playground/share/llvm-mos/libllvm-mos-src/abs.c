#define _abs(i) (i < 0 ? -i : i)

int abs(int i) { return _abs(i); }
long labs(long i) { return _abs(i); }
long long llabs(long long i) { return _abs(i); }
