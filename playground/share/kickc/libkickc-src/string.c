// C standard library string.h
// Functions to manipulate C strings and arrays.
#include <string.h>
#include <ctype.h>

// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
void* memcpy( void* destination, void* source, size_t num ) {
    char* src = source;
    char* dst = destination;
    char* src_end = (char*)source+num;
    while(src!=src_end) *dst++ = *src++;
    return destination;
}

// Move block of memory
// Copies the values of num bytes from the location pointed by source to the memory block pointed by destination. Copying takes place as if an intermediate buffer were used, allowing the destination and source to overlap.
void* memmove( void* destination, void* source, size_t num ) {
    if((unsigned int)destination<(unsigned int)source) {
        memcpy(destination, source, num);
    } else {
        // copy backwards
        char* src = (char*)source+num;
        char* dst = (char*)destination+num;
        for( size_t i=0; i<num; i++) *--dst = *--src;
    }
    return destination;
}

// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
void *memset(void *str, char c, size_t num) {
    if(num>0) {
        char* end = (char*)str + num;
        for(char* dst = str; dst!=end; dst++)
            *dst = c;
    }
    return str;
}

// Copies the C string pointed by source into the array pointed by destination, including the terminating null character (and stopping at that point).
char* strcpy( char* destination, char* source ) {
    char* src = source;
    char* dst = destination;
    while(*src) *dst++ = *src++;
    *dst = 0;
    return destination;
}

/// Copies up to n characters from the string pointed to, by src to dst.
/// In a case where the length of src is less than that of n, the remainder of dst will be padded with null bytes.
/// @param dst − This is the pointer to the destination array where the content is to be copied.
/// @param src − This is the string to be copied.
/// @param n − The number of characters to be copied from source.
/// @return The destination
char *strncpy(char *dst, const char *src, size_t n) {
    for(size_t i = 0;i<n;i++) {
        char c = *src;
        if(c) src++;
        *dst++ = c;
    }
    return dst;
}

// Converts a string to uppercase.
char * strupr(char *str) {
    char * src = str;
    while(*src) {
        *src = toupper(*src);
        src++;
    }
    return str;
}

// Computes the length of the string str up to but not including the terminating null character.
size_t strlen(char *str) {
    size_t len = 0;
    while(*str) {
        len++;
        str++;
    }
    return len;
}

// Searches for the first occurrence of the character c (an unsigned char) in the first n bytes of the string pointed to, by the argument str.
// - str: The memory to search
// - c: A character to search for
// - n: The number of bytes to look through
// Return: A pointer to the matching byte or NULL if the character does not occur in the given memory area.
void *memchr(const void *str, char c, size_t n) {
    char * ptr = str;
    for(size_t i=0;i<n;i++) {
        if(*ptr==c)
            return ptr;
        ptr++;
    }
    return (void*)0;
}

/// Compares the first n bytes of memory area str1 and memory area str2.
/// @param str1 This is the pointer to a block of memory.
/// @param str2 This is the pointer to a block of memory.
/// @param n This is the number of bytes to be compared.
/// @return if Return value < 0 then it indicates str1 is less than str2.
///         if Return value > 0 then it indicates str2 is less than str1.
///         if Return value = 0 then it indicates str1 is equal to str2.
int memcmp(const void *str1, const void *str2, size_t n) {
    for(char *s1 = str1, *s2 = str2; n!=0; n--,s1++,s2++) {
        if(*s1!=*s2)
            return (int)(signed char)(*s1-*s2);
    }
    return 0;
}


/// compares the string pointed to, by str1 to the string pointed to by str2.
/// @param str1 This is the first string to be compared.
/// @param str2 This is the second string to be compared.
/// @return if Return value < 0 then it indicates str1 is less than str2.
///         if Return value > 0 then it indicates str2 is less than str1.
///         if Return value = 0 then it indicates str1 is equal to str2.
int strcmp(const char *str1, const char *str2) {
    char *s1 = str1, *s2 = str2;
    while(*s1==*s2) {
        if(*s1==0) return 0;
        s1++; s2++;
    }
    return (int)(signed char)(*s1-*s2);
}

/// Compares at most the first n bytes of str1 and str2.
/// @param str1 This is the first string to be compared.
/// @param str2 This is the second string to be compared.
/// @param The maximum number of characters to be compared.
/// @return if Return value < 0 then it indicates str1 is less than str2.
///         if Return value > 0 then it indicates str2 is less than str1.
///         if Return value = 0 then it indicates str1 is equal to str2.
int strncmp(const char *str1, const char *str2, size_t n) {
    char *s1 = str1, *s2 = str2;
    while(*s1==*s2) {
        n--;
        if(*s1==0 || n==0) return 0;
        s1++; s2++;
    }
    return (int)(signed char)(*s1-*s2);
}