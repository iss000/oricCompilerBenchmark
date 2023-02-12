#include <ctype.h>

// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
char toupper(char ch) {
    if(ch>='a' && ch<='z') {
        return ch + ('A'-'a');
    } else {
        return ch;
    }
}