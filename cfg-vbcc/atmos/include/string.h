#ifndef __STRING_H
#define __STRING_H 1

#ifndef __SIZE_T
#define __SIZE_T 1
typedef unsigned int size_t;
#endif

#undef NULL
#define NULL ((void *)0)

void _fmemcpy(__far void *,const __far void *,size_t);
void *memcpy(void *,const void *,size_t);
void *memmove(void *,const void *,size_t);
char *strcpy(char *,const char *);
char *strncpy(char *,const char *,size_t);
char *strcat(char *,const char *);
char *strncat(char *,const char *,size_t);
int memcmp(const void *,const void *,size_t);
int strcmp(const char *,const char *);
int strncmp(const char *,const char *,size_t);
void *memchr(const void *,int,size_t);
char *strchr(const char *,int);
size_t strcspn(const char *,const char *);
char *strpbrk(const char *,const char *);
char *strrchr(const char *,int);
size_t strspn(const char *,const char *);
char *strstr(const char *,const char *);
void *memset(void *,int,size_t);
size_t strlen(const char *);
char *strtok(char *,const char *);
char *strerror(int);
int strcoll(const char *,const char *);
size_t strxfrm(char *,const char *,size_t);

#if !defined(__NOINLINE__) && defined(__OPTSPEED__)
void *__memset16(void *,int,size_t);
#define memset(d,c,n) ((n)<256 ? __memset8(d,c,n) : __memset16(d,c,n))
void *__memset8(__reg("r0/r1") void *, __reg("r2/r3") int,
                __reg("r4/r5") size_t) =
  "\tinline\n"
  "\tlda\tr2\n"
  "\tldy\tr4\n"
  "\tbne\t.2\n"
  "\tbeq\t.3\n"
  ".1:\tsta\t(r0),y\n"
  ".2:\tdey\n"
  "\tbne\t.1\n"
  "\tsta\t(r0),y\n"
  ".3:\tlda\tr0\n"
  "\tldx\tr1\n"
  "\teinline";

size_t strlen(__reg("r0/r1") const char *) =
  "\tinline\n"
  "\tldx\t#0\n"
  "\tldy\t#0\n"
  ".1:\tlda\t(r0),y\n"
  "\tbeq\t.2\n"
  "\tiny\n"
  "\tbne\t.1\n"
  "\tinc\tr1\n"
  "\tinx\n"
  "\tbne\t.1\n"
  ".2:\ttya\n"
  "\teinline";

char *strcpy(__reg("r0/r1") char *, __reg("r2/r3") const char *) =
  "\tinline\n"
  "\tlda\tr1\n"
  "\tpha\n"
  "\tldy\t#0\n"
  ".1:\tlda\t(r2),y\n"
  "\tsta\t(r0),y\n"
  "\tbeq\t.2\n"
  "\tiny\n"
  "\tbne\t.1\n"
  "\tinc\tr1\n"
  "\tinc\tr3\n"
  "\tbne\t.1\n"
  ".2:\tpla\n"
  "\ttax\n"
  "\tlda\tr0\n"
  "\teinline";
#endif /* !__NOINLINE__ && __OPTSPEED__ */

#endif /* __STRING_H */
