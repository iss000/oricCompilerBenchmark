/// @file
/// Functions for performing input and output.

#include <stddef.h>
#include <errno.h>
#include <printf.h>
#include <sprintf.h>

#if defined(__CX16__) // For the moment only supported for the CX16 ...

    #ifndef __STDIO_FILELEN
        #define __STDIO_FILELEN 32
    #endif

    #ifndef __STDIO_ERRORLEN
        #define __STDIO_ERRORLEN 32
    #endif

    #ifndef __STDIO_FILECOUNT
        #define __STDIO_FILECOUNT 4
    #endif

    typedef struct {
        char filename[__STDIO_FILECOUNT*__STDIO_FILELEN];
        char channel[__STDIO_FILECOUNT];
        char device[__STDIO_FILECOUNT];
        char secondary[__STDIO_FILECOUNT];
        char status[__STDIO_FILECOUNT];
    } FILE;



    FILE *fopen(const char *path, const char *mode);
    int fclose(FILE *stream);
    unsigned int fgets(char *ptr, unsigned int size, FILE *stream);
    int ferror(FILE *stream);
    void perror(char* prefix);
#endif