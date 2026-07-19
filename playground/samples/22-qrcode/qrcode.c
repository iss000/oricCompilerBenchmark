/*
 * qr_encode.c
 *
 *  Created on: Jan 18, 2012
 *  Adapted by Jamie Howard
 *  Author: swex
 */

#include <conio.h>

static void* _memcpy(void* destination, void* source, unsigned int num)
{
  char* src = source;
  char* dst = destination;
  char* src_end = (char*)source+num;
  while(src!=src_end) *dst++ = *src++;
  return destination;
}

static void* _memmove(void* destination, void* source, unsigned int num)
{
  if((unsigned int)destination<(unsigned int)source)
  {
    _memcpy(destination, source, num);
  }
  else
  {
    // copy backwards
    char* src = (char*)source+num;
    char* dst = (char*)destination+num;
    unsigned int i;
    for(i=0; i<num; i++) *--dst = *--src;
  }
  return destination;
}


static void* _memset(void* str, char c, unsigned int num)
{
  if(num>0)
  {
    char* end = (char*)str + num;
    char* dst;
    for(dst = str; dst!=end; dst++)
      *dst = c;
  }
  return str;
}

unsigned int _strlen(const char* str)
{
  unsigned int len = 0;
  while(*str)
  {
    len++;
    str++;
  }
  return len;
}

#define abs(x) (((x)<0)?(-(x)):(x))

// #include "qr_encode.h"

#define MAX_BITDATA 301

int EncodeData(int nLevel, int nVersion, const char* lpsSource, int sourcelen, unsigned char QR_m_data[]);

// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //

#define kDisplayWidth 8

#define ch_fill     '#'
#define ch_empty    '-'
static const char* textIn = "https://raxiss.com/article/id/30-MOS6502-compiler-benchmark";

static unsigned char qr_m_data[MAX_BITDATA];
static char res[MAX_BITDATA*8];

static void binfill(long int x, char* so)
{
  // fill in array from right to left
  char s[kDisplayWidth+1];
  int i=kDisplayWidth;
  s[i--]=0x00;   // terminate string
  do
  {
    // fill in array from right to left
    s[i--]=(x & 1) ? ch_fill:ch_empty;
    x>>=1;  // shift right 1 bit
  }
  while(x > 0);

  while(i>=0)
    s[i--]=ch_empty;

  _memmove(so, s, _strlen(s)+1);
}


int main(void)
{
  int qr_width=EncodeData(0,0,textIn,0,qr_m_data);
  int size = ((qr_width*qr_width)/8)+(((qr_width*qr_width)%8)?1:0);
  int i;

  for(i=0; i<size; i++)
    binfill(qr_m_data[i], &res[i*8]);

  for(i=0; i<qr_width*qr_width; i++)
  {
    if(i%qr_width == 0)
      _putc('\n');

    _putc(res[i]);
  }

  return 0;
}


// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //

// Constant

// Error correction level
#define QR_LEVEL_L  0
#define QR_LEVEL_M  1
#define QR_LEVEL_Q  2
#define QR_LEVEL_H  3

//Data Mode
#define QR_MODE_NUMERAL   0
#define QR_MODE_ALPHABET  1
#define QR_MODE_8BIT      2
#define QR_MODE_KANJI     3

//Group version (model number)
#define QR_VERSION_S      0 // 1 ~ 9

#define MAX_ALLCODEWORD   256   // The maximum total number of code words
#define MAX_DATACODEWORD  256   // Maximum data word code (version 40-L)

#define MAX_CODEBLOCK     153   // The maximum number of block data code word (Including RS code word)
#define MAX_MODULESIZE     49   // Maximum number of modules in a side

/////////////////////////////////////////////////////////////////////////////

typedef struct tagRS_BLOCKINFO
{
  int ncRSBlock;      //RS block number
  int ncAllCodeWord;  //The number of codewords in the block
  int ncDataCodeWord; //The number of data code words (the number of code words - the number of RS code word)

} RS_BLOCKINFO, *LPRS_BLOCKINFO;

/////////////////////////////////////////////////////////////////////////////
//Version code-related information (model number)

typedef struct tagQR_VERSIONINFO
{
  int nVersionNo;
  int ncAllCodeWord;

  // Error correction levels (0 = L, 1 = M, 2 = Q, 3 = H)
  int ncDataCodeWord[4];  // data len

  int ncAlignPoint; // position
  int nAlignPoint[6]; // numberof

  RS_BLOCKINFO RS_BlockInfo1[4]; // EC pos
  RS_BLOCKINFO RS_BlockInfo2[4]; // EC pos

} QR_VERSIONINFO, *LPQR_VERSIONINFO;


typedef unsigned short WORD;

typedef unsigned char BYTE;

typedef BYTE* LPBYTE;

typedef const char* LPCSTR;

#define ZeroMemory(Destination,Length) _memset((void*)(Destination),0,(unsigned int)(Length))


static int m_nLevel;
static int m_QR_nVersion;
static int m_nMaskingNo;

static int m_ncDataCodeWordBit;
static int m_ncAllCodeWord;
static int m_nEncodeVersion;
static int m_ncDataBlock;
static int m_nSymbleSize;

static QR_VERSIONINFO QR_VersonInfo[] =
{
  {0}, // (Ver.0)
  {
    1, // Ver.1
    26, {19, 16, 13, 9},
    0, {0, 0, 0, 0, 0, 0},
    {{1, 26, 19}, {1, 26, 16}, {1, 26, 13}, {1, 26, 9}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
  },
  {
    2, // Ver.2
    44, {34, 28, 22, 16},
    1, {18, 0, 0, 0, 0, 0},
    {{1, 44, 34}, {1, 44, 28}, {1, 44, 22}, {1, 44, 16}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
  },
  {
    3, // Ver.3
    70, {55, 44, 34, 26},
    1, {22, 0, 0, 0, 0, 0},
    {{1, 70, 55}, {1, 70, 44}, {2, 35, 17}, {2, 35, 13}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
  },
  {
    4, // Ver.4
    100, {80, 64, 48, 36},
    1, {26, 0, 0, 0, 0, 0},
    {{1, 100, 80}, {2, 50, 32}, {2, 50, 24}, {4, 25, 9}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
  },
  {
    5, // Ver.5
    134, {108, 86, 62, 46},
    1, {30, 0, 0, 0, 0, 0},
    {{1, 134, 108}, {2, 67, 43}, {2, 33, 15}, {2, 33, 11}},
    {{0, 0, 0}, {0, 0, 0}, {2, 34, 16}, {2, 34, 12}}
  },
  {
    6, // Ver.6
    172, {136, 108, 76, 60},
    1, {34, 0, 0, 0, 0, 0},
    {{2, 86, 68}, {4, 43, 27}, {4, 43, 19}, {4, 43, 15}},
    {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
  },
  {
    7, // Ver.7
    196, {156, 124, 88, 66},
    2, {22, 38, 0, 0, 0, 0},
    {{2, 98, 78}, {4, 49, 31}, {2, 32, 14}, {4, 39, 13}},
    {{0, 0, 0}, {0, 0, 0}, {4, 33, 15}, {1, 40, 14}}
  },
  {
    8, // Ver.8
    242, {194, 154, 110, 86},
    2, {24, 42, 0, 0, 0, 0},
    {{2, 121, 97}, {2, 60, 38}, {4, 40, 18}, {4, 40, 14}},
    {{0, 0, 0}, {2, 61, 39}, {2, 41, 19}, {2, 41, 15}}
  }
};

//RS STUFF
static BYTE byExpToInt[] = {  1,   2,   4,   8,  16,  32,  64, 128,  29,  58, 116, 232, 205, 135,  19,  38,
                              76, 152,  45,  90, 180, 117, 234, 201, 143,   3,   6,  12,  24,  48,  96, 192,
                              157,  39,  78, 156,  37,  74, 148,  53, 106, 212, 181, 119, 238, 193, 159,  35,
                              70, 140,   5,  10,  20,  40,  80, 160,  93, 186, 105, 210, 185, 111, 222, 161,
                              95, 190,  97, 194, 153,  47,  94, 188, 101, 202, 137,  15,  30,  60, 120, 240,
                              253, 231, 211, 187, 107, 214, 177, 127, 254, 225, 223, 163,  91, 182, 113, 226,
                              217, 175,  67, 134,  17,  34,  68, 136,  13,  26,  52, 104, 208, 189, 103, 206,
                              129,  31,  62, 124, 248, 237, 199, 147,  59, 118, 236, 197, 151,  51, 102, 204,
                              133,  23,  46,  92, 184, 109, 218, 169,  79, 158,  33,  66, 132,  21,  42,  84,
                              168,  77, 154,  41,  82, 164,  85, 170,  73, 146,  57, 114, 228, 213, 183, 115,
                              230, 209, 191,  99, 198, 145,  63, 126, 252, 229, 215, 179, 123, 246, 241, 255,
                              227, 219, 171,  75, 150,  49,  98, 196, 149,  55, 110, 220, 165,  87, 174,  65,
                              130,  25,  50, 100, 200, 141,   7,  14,  28,  56, 112, 224, 221, 167,  83, 166,
                              81, 162,  89, 178, 121, 242, 249, 239, 195, 155,  43,  86, 172,  69, 138,   9,
                              18,  36,  72, 144,  61, 122, 244, 245, 247, 243, 251, 235, 203, 139,  11,  22,
                              44,  88, 176, 125, 250, 233, 207, 131,  27,  54, 108, 216, 173,  71, 142,   1
                           };


static BYTE byIntToExp[] = {  0,   0,   1,  25,   2,  50,  26, 198,   3, 223,  51, 238,  27, 104, 199,  75,
                              4, 100, 224,  14,  52, 141, 239, 129,  28, 193, 105, 248, 200,   8,  76, 113,
                              5, 138, 101,  47, 225,  36,  15,  33,  53, 147, 142, 218, 240,  18, 130,  69,
                              29, 181, 194, 125, 106,  39, 249, 185, 201, 154,   9, 120,  77, 228, 114, 166,
                              6, 191, 139,  98, 102, 221,  48, 253, 226, 152,  37, 179,  16, 145,  34, 136,
                              54, 208, 148, 206, 143, 150, 219, 189, 241, 210,  19,  92, 131,  56,  70,  64,
                              30,  66, 182, 163, 195,  72, 126, 110, 107,  58,  40,  84, 250, 133, 186,  61,
                              202,  94, 155, 159,  10,  21, 121,  43,  78, 212, 229, 172, 115, 243, 167,  87,
                              7, 112, 192, 247, 140, 128,  99,  13, 103,  74, 222, 237,  49, 197, 254,  24,
                              227, 165, 153, 119,  38, 184, 180, 124,  17,  68, 146, 217,  35,  32, 137,  46,
                              55,  63, 209,  91, 149, 188, 207, 205, 144, 135, 151, 178, 220, 252, 190,  97,
                              242,  86, 211, 171,  20,  42,  93, 158, 132,  60,  57,  83,  71, 109,  65, 162,
                              31,  45,  67, 216, 183, 123, 164, 118, 196,  23,  73, 236, 127,  12, 111, 246,
                              108, 161,  59,  82,  41, 157,  85, 170, 251,  96, 134, 177, 187, 204,  62,  90,
                              203,  89,  95, 176, 156, 169, 160,  81,  11, 245,  22, 235, 122, 117,  44, 215,
                              79, 174, 213, 233, 230, 231, 173, 232, 116, 214, 244, 234, 168,  80,  88, 175
                           };



static BYTE byRSExp7[]  = {87, 229, 146, 149, 238, 102,  21};
static BYTE byRSExp10[] = {251,  67,  46,  61, 118,  70,  64,  94,  32,  45};
static BYTE byRSExp13[] = { 74, 152, 176, 100,  86, 100, 106, 104, 130, 218, 206, 140,  78};
static BYTE byRSExp15[] = {  8, 183,  61,  91, 202,  37,  51,  58,  58, 237, 140, 124,   5,  99, 105};
static BYTE byRSExp16[] = {120, 104, 107, 109, 102, 161,  76,   3,  91, 191, 147, 169, 182, 194, 225, 120};
static BYTE byRSExp17[] = { 43, 139, 206,  78,  43, 239, 123, 206, 214, 147,  24,  99, 150,  39, 243, 163, 136};
static BYTE byRSExp18[] = {215, 234, 158,  94, 184,  97, 118, 170,  79, 187, 152, 148, 252, 179,   5,  98,  96, 153};
static BYTE byRSExp20[] = { 17,  60,  79,  50,  61, 163,  26, 187, 202, 180, 221, 225,  83, 239, 156, 164, 212, 212, 188, 190};
static BYTE byRSExp22[] = {210, 171, 247, 242,  93, 230,  14, 109, 221,  53, 200,  74,   8, 172,  98,  80, 219, 134, 160, 105, 165, 231};
static BYTE byRSExp24[] = {229, 121, 135,  48, 211, 117, 251, 126, 159, 180, 169, 152, 192, 226, 228, 218, 111,   0, 117, 232,  87,  96, 227,  21};
static BYTE byRSExp26[] = {173, 125, 158,   2, 103, 182, 118,  17, 145, 201, 111,  28, 165,  53, 161,  21, 245, 142,  13, 102,  48, 227, 153, 145, 218,  70};
static BYTE byRSExp28[] = {168, 223, 200, 104, 224, 234, 108, 180, 110, 190, 195, 147, 205,  27, 232, 201,  21,  43, 245,  87,  42, 195, 212, 119, 242,  37,   9, 123};
static BYTE byRSExp30[] = { 41, 173, 145, 152, 216,  31, 179, 182,  50,  48, 110,  86, 239,  96, 222, 125,  42, 173, 226, 193,
                            224, 130, 156,  37, 251, 216, 238,  40, 192, 180
                          };
static BYTE byRSExp32[] = { 10,   6, 106, 190, 249, 167,   4,  67, 209, 138, 138,  32, 242, 123,  89,  27, 120, 185,  80, 156,
                            38,  69, 171,  60,  28, 222,  80,  52, 254, 185, 220, 241
                          };
static BYTE byRSExp34[] = {111,  77, 146,  94,  26,  21, 108,  19, 105,  94, 113, 193,  86, 140, 163, 125,  58, 158, 229, 239,
                           218, 103,  56,  70, 114,  61, 183, 129, 167,  13,  98,  62, 129,  51
                          };
static BYTE byRSExp36[] = {200, 183,  98,  16, 172,  31, 246, 234,  60, 152, 115,   0, 167, 152, 113, 248, 238, 107,  18,  63,
                           218,  37,  87, 210, 105, 177, 120,  74, 121, 196, 117, 251, 113, 233,  30, 120
                          };
static BYTE byRSExp38[] = {159,  34,  38, 228, 230,  59, 243,  95,  49, 218, 176, 164,  20,  65,  45, 111,  39,  81,  49, 118,
                           113, 222, 193, 250, 242, 168, 217,  41, 164, 247, 177,  30, 238,  18, 120, 153,  60, 193
                          };
static BYTE byRSExp40[] = { 59, 116,  79, 161, 252,  98, 128, 205, 128, 161, 247,  57, 163,  56, 235, 106,  53,  26, 187, 174,
                            226, 104, 170,   7, 175,  35, 181, 114,  88,  41,  47, 163, 125, 134,  72,  20, 232,  53,  35,  15
                          };
static BYTE byRSExp42[] = {250, 103, 221, 230,  25,  18, 137, 231,   0,   3,  58, 242, 221, 191, 110,  84, 230,   8, 188, 106,
                           96, 147,  15, 131, 139,  34, 101, 223,  39, 101, 213, 199, 237, 254, 201, 123, 171, 162, 194, 117,
                           50,  96
                          };
static BYTE byRSExp44[] = {190,   7,  61, 121,  71, 246,  69,  55, 168, 188,  89, 243, 191,  25,  72, 123,   9, 145,  14, 247,
                           1, 238,  44,  78, 143,  62, 224, 126, 118, 114,  68, 163,  52, 194, 217, 147, 204, 169,  37, 130,
                           113, 102,  73, 181
                          };
static BYTE byRSExp46[] = {112,  94,  88, 112, 253, 224, 202, 115, 187,  99,  89,   5,  54, 113, 129,  44,  58,  16, 135, 216,
                           169, 211,  36,   1,   4,  96,  60, 241,  73, 104, 234,   8, 249, 245, 119, 174,  52,  25, 157, 224,
                           43, 202, 223,  19,  82,  15
                          };
static BYTE byRSExp48[] = {228,  25, 196, 130, 211, 146,  60,  24, 251,  90,  39, 102, 240,  61, 178,  63,  46, 123, 115,  18,
                           221, 111, 135, 160, 182, 205, 107, 206,  95, 150, 120, 184,  91,  21, 247, 156, 140, 238, 191,  11,
                           94, 227,  84,  50, 163,  39,  34, 108
                          };
static BYTE byRSExp50[] = {232, 125, 157, 161, 164,   9, 118,  46, 209,  99, 203, 193,  35,   3, 209, 111, 195, 242, 203, 225,
                           46,  13,  32, 160, 126, 209, 130, 160, 242, 215, 242,  75,  77,  42, 189,  32, 113,  65, 124,  69,
                           228, 114, 235, 175, 124, 170, 215, 232, 133, 205
                          };
static BYTE byRSExp52[] = {116,  50,  86, 186,  50, 220, 251,  89, 192,  46,  86, 127, 124,  19, 184, 233, 151, 215,  22,  14,
                           59, 145,  37, 242, 203, 134, 254,  89, 190,  94,  59,  65, 124, 113, 100, 233, 235, 121,  22,  76,
                           86,  97,  39, 242, 200, 220, 101,  33, 239, 254, 116,  51
                          };
static BYTE byRSExp54[] = {183,  26, 201,  87, 210, 221, 113,  21,  46,  65,  45,  50, 238, 184, 249, 225, 102,  58, 209, 218,
                           109, 165,  26,  95, 184, 192,  52, 245,  35, 254, 238, 175, 172,  79, 123,  25, 122,  43, 120, 108,
                           215,  80, 128, 201, 235,   8, 153,  59, 101,  31, 198,  76,  31, 156
                          };
static BYTE byRSExp56[] = {106, 120, 107, 157, 164, 216, 112, 116,   2,  91, 248, 163,  36, 201, 202, 229,   6, 144, 254, 155,
                           135, 208, 170, 209,  12, 139, 127, 142, 182, 249, 177, 174, 190,  28,  10,  85, 239, 184, 101, 124,
                           152, 206,  96,  23, 163,  61,  27, 196, 247, 151, 154, 202, 207,  20,  61,  10
                          };
static BYTE byRSExp58[] = { 82, 116,  26, 247,  66,  27,  62, 107, 252, 182, 200, 185, 235,  55, 251, 242, 210, 144, 154, 237,
                            176, 141, 192, 248, 152, 249, 206,  85, 253, 142,  65, 165, 125,  23,  24,  30, 122, 240, 214,   6,
                            129, 218,  29, 145, 127, 134, 206, 245, 117,  29,  41,  63, 159, 142, 233, 125, 148, 123
                          };
static BYTE byRSExp60[] = {107, 140,  26,  12,   9, 141, 243, 197, 226, 197, 219,  45, 211, 101, 219, 120,  28, 181, 127,   6,
                           100, 247,   2, 205, 198,  57, 115, 219, 101, 109, 160,  82,  37,  38, 238,  49, 160, 209, 121,  86,
                           11, 124,  30, 181,  84,  25, 194,  87,  65, 102, 190, 220,  70,  27, 209,  16,  89,   7,  33, 240
                          };
static BYTE byRSExp62[] = { 65, 202, 113,  98,  71, 223, 248, 118, 214,  94,   0, 122,  37,  23,   2, 228,  58, 121,   7, 105,
                            135,  78, 243, 118,  70,  76, 223,  89,  72,  50,  70, 111, 194,  17, 212, 126, 181,  35, 221, 117,
                            235,  11, 229, 149, 147, 123, 213,  40, 115,   6, 200, 100,  26, 246, 182, 218, 127, 215,  36, 186,
                            110, 106
                          };
static BYTE byRSExp64[] = { 45,  51, 175,   9,   7, 158, 159,  49,  68, 119,  92, 123, 177, 204, 187, 254, 200,  78, 141, 149,
                            119,  26, 127,  53, 160,  93, 199, 212,  29,  24, 145, 156, 208, 150, 218, 209,   4, 216,  91,  47,
                            184, 146,  47, 140, 195, 195, 125, 242, 238,  63,  99, 108, 140, 230, 242,  31, 204,  11, 178, 243,
                            217, 156, 213, 231
                          };
static BYTE byRSExp66[] = {  5, 118, 222, 180, 136, 136, 162,  51,  46, 117,  13, 215,  81,  17, 139, 247, 197, 171,  95, 173,
                             65, 137, 178,  68, 111,  95, 101,  41,  72, 214, 169, 197,  95,   7,  44, 154,  77, 111, 236,  40,
                             121, 143,  63,  87,  80, 253, 240, 126, 217,  77,  34, 232, 106,  50, 168,  82,  76, 146,  67, 106,
                             171,  25, 132,  93,  45, 105
                          };
static BYTE byRSExp68[] = {247, 159, 223,  33, 224,  93,  77,  70,  90, 160,  32, 254,  43, 150,  84, 101, 190, 205, 133,  52,
                           60, 202, 165, 220, 203, 151,  93,  84,  15,  84, 253, 173, 160,  89, 227,  52, 199,  97,  95, 231,
                           52, 177,  41, 125, 137, 241, 166, 225, 118,   2,  54,  32,  82, 215, 175, 198,  43, 238, 235,  27,
                           101, 184, 127,   3,   5,   8, 163, 238
                          };

static LPBYTE  byRSExp[] = {0,      0,      0,      0,      0,      0,      0,      byRSExp7,  0,      0,
                            byRSExp10, 0,      0,      byRSExp13, 0,      byRSExp15, byRSExp16, byRSExp17, byRSExp18, 0,
                            byRSExp20, 0,      byRSExp22, 0,      byRSExp24, 0,      byRSExp26, 0,      byRSExp28, 0,
                            byRSExp30, 0,      byRSExp32, 0,      byRSExp34, 0,      byRSExp36, 0,      byRSExp38, 0,
                            byRSExp40, 0,      byRSExp42, 0,      byRSExp44, 0,      byRSExp46, 0,      byRSExp48, 0,
                            byRSExp50, 0,      byRSExp52, 0,      byRSExp54, 0,      byRSExp56, 0,      byRSExp58, 0,
                            byRSExp60, 0,      byRSExp62, 0,      byRSExp64, 0,      byRSExp66, 0,      byRSExp68
                           };

static int nIndicatorLen8Bit[] = { 8, 16, 16};

int SetBitStream(int nIndex, WORD wData, int ncData,BYTE m_byDataCodeWord[MAX_DATACODEWORD])
{
  int i;

  if(nIndex == -1 || nIndex + ncData > MAX_DATACODEWORD * 8)
    return -1;

  for(i = 0; i < ncData; ++i)
  {
    if(wData & (1 << (ncData - i - 1)))
    {
      m_byDataCodeWord[(nIndex + i) / 8] |= 1 << (7 - ((nIndex + i) % 8));
    }
  }

  return nIndex + ncData;
}


int GetBitLength(int ncData, int nVerGroup)
{
  return 4 + nIndicatorLen8Bit[nVerGroup] + (8 * ncData);
}




int EncodeSourceData(LPCSTR lpSrc, int ncLength, int nVerGroup,int m_nBlockLength[MAX_DATACODEWORD],
                     BYTE m_byBlockMode[MAX_DATACODEWORD],BYTE m_byDataCodeWord[MAX_DATACODEWORD])
{
  int i, j;
  int ncSrcBits, ncDstBits; //The bit length of the block mode if you have over the original bit length and a single alphanumeric
  int nBlock = 0;
  int ncComplete = 0; //Data pre-processing counter
  m_ncDataCodeWordBit = 0;//Bit counter processing unit

  ZeroMemory(m_nBlockLength, sizeof(int)*MAX_DATACODEWORD);

  // Investigate whether continuing characters (bytes) which mode is what
  for(m_ncDataBlock = i = 0; i < ncLength; ++i)
  {
    BYTE byMode = QR_MODE_8BIT;

    if(i == 0)
      m_byBlockMode[0] = byMode;
    if(m_byBlockMode[m_ncDataBlock] != byMode)
      m_byBlockMode[++m_ncDataBlock] = byMode;

    ++m_nBlockLength[m_ncDataBlock];
  }

  ++m_ncDataBlock;

  nBlock = 0;

  while(nBlock < m_ncDataBlock - 1)
  {
    ncSrcBits = GetBitLength(m_nBlockLength[nBlock], nVerGroup)
                + GetBitLength(m_nBlockLength[nBlock + 1], nVerGroup);

    ncDstBits = GetBitLength(m_nBlockLength[nBlock] + m_nBlockLength[nBlock + 1], nVerGroup);

    // If there is a 8-bit byte block mode before, subtract the duplicate indicator minute
    if(nBlock >= 1 && m_byBlockMode[nBlock - 1] == QR_MODE_8BIT)
      ncDstBits -= (4 + nIndicatorLen8Bit[nVerGroup]);

    // If there is a block behind the 8-bit byte mode, subtract the duplicate indicator minute
    if(nBlock < m_ncDataBlock - 2 && m_byBlockMode[nBlock + 2] == QR_MODE_8BIT)
      ncDstBits -= (4 + nIndicatorLen8Bit[nVerGroup]);

    if(ncSrcBits > ncDstBits)
    {
      if(nBlock >= 1 && m_byBlockMode[nBlock - 1] == QR_MODE_8BIT)
      {
        // 8-bit byte mode coupling block in front of the block to join
        m_nBlockLength[nBlock - 1] += m_nBlockLength[nBlock];

        // The subsequent shift
        for(i = nBlock; i < m_ncDataBlock - 1; ++i)
        {
          m_byBlockMode[i]  = m_byBlockMode[i + 1];
          m_nBlockLength[i] = m_nBlockLength[i + 1];
        }

        --m_ncDataBlock;
        --nBlock;
      }

      if(nBlock < m_ncDataBlock - 2 && m_byBlockMode[nBlock + 2] == QR_MODE_8BIT)
      {
        // 8-bit byte mode coupling block at the back of the block to join
        m_nBlockLength[nBlock + 1] += m_nBlockLength[nBlock + 2];


        // The subsequent shift
        for(i = nBlock + 2; i < m_ncDataBlock - 1; ++i)
        {
          m_byBlockMode[i]  = m_byBlockMode[i + 1];
          m_nBlockLength[i] = m_nBlockLength[i + 1];
        }

        --m_ncDataBlock;
      }

      m_byBlockMode[nBlock] = QR_MODE_8BIT;
      m_nBlockLength[nBlock] += m_nBlockLength[nBlock + 1];


      // The subsequent shift
      for(i = nBlock + 1; i < m_ncDataBlock - 1; ++i)
      {
        m_byBlockMode[i]  = m_byBlockMode[i + 1];
        m_nBlockLength[i] = m_nBlockLength[i + 1];
      }

      --m_ncDataBlock;


      // Re-examination in front of the block bound
      if(nBlock >= 1)
        --nBlock;

      continue;
    }

    ++nBlock;//Investigate the next block

  }

  /////////////////////////////////////////////////////////////////////////
  // Mosquito bit array

  ZeroMemory(m_byDataCodeWord, MAX_DATACODEWORD);

  for(i = 0; i < m_ncDataBlock && m_ncDataCodeWordBit != -1; ++i)
  {
    /////////////////////////////////////////////////////////////////
    // 8-bit byte mode

    // Mode indicator (0100b)
    m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, 4, 4,m_byDataCodeWord);


    // Set number of characters
    m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, (WORD)m_nBlockLength[i], nIndicatorLen8Bit[nVerGroup],m_byDataCodeWord);


    // Save the bit string
    for(j = 0; j < m_nBlockLength[i]; ++j)
    {
      m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, (WORD)lpSrc[ncComplete + j], 8,m_byDataCodeWord);
    }

    ncComplete += m_nBlockLength[i];
  }

  return (m_ncDataCodeWordBit != -1);
}


/////////////////////////////////////////////////////////////////////////////
// APPLICATIONS: To get the bit length
// Args: data mode type, data length, group version (model number)
// Returns: data bit length
// Remarks: data length of argument in Kanji mode is the number of bytes, not characters



int GetEncodeVersion(LPCSTR lpSrc, int ncLength,int m_nBlockLength[MAX_DATACODEWORD],BYTE m_byBlockMode[MAX_DATACODEWORD],
                     BYTE m_byDataCodeWord[MAX_DATACODEWORD])
{
  int nVerGroup = QR_VERSION_S;
  int j;

  if(EncodeSourceData(lpSrc, ncLength, 0, m_nBlockLength, m_byBlockMode, m_byDataCodeWord))
  {
    for(j = 1; j <= 9; ++j)
    {
      if((m_ncDataCodeWordBit + 7) / 8 <= QR_VersonInfo[j].ncDataCodeWord[m_nLevel])
        return j;
    }
  }

  return 0;
}


int min(int a, int b)
{
  if(a<=b)
  {
    return a;
  }
  else
  {
    return b;
  }
}

void GetRSCodeWord(LPBYTE lpbyRSWork, int ncDataCodeWord, int ncRSCodeWord)
{
  int i, j;

  for(i = 0; i < ncDataCodeWord ; ++i)
  {
    if(lpbyRSWork[0] != 0)
    {
      BYTE nExpFirst = byIntToExp[lpbyRSWork[0]]; //Multiplier coefficient is calculated from the first term

      for(j = 0; j < ncRSCodeWord; ++j)
      {

        //Add (% 255  ^ 255 = 1) the first term multiplier to multiplier sections
        BYTE nExpElement = (BYTE)(((int)(byRSExp[ncRSCodeWord][j] + nExpFirst)) % 255);

        //Surplus calculated by the exclusive
        lpbyRSWork[j] = (BYTE)(lpbyRSWork[j + 1] ^ byExpToInt[nExpElement]);
      }


      //Shift the remaining digits
      for(j = ncRSCodeWord; j < ncDataCodeWord + ncRSCodeWord - 1; ++j)
        lpbyRSWork[j] = lpbyRSWork[j + 1];
    }
    else
    {

      //Shift the remaining digits
      for(j = 0; j < ncDataCodeWord + ncRSCodeWord - 1; ++j)
        lpbyRSWork[j] = lpbyRSWork[j + 1];
    }
  }
}

void SetFinderPattern(int x, int y,BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE])
{
  static BYTE byPattern[] = {0x7f,  // 1111111b
                             0x41,  // 1000001b
                             0x5d,  // 1011101b
                             0x5d,  // 1011101b
                             0x5d,  // 1011101b
                             0x41,  // 1000001b
                             0x7f
                            }; // 1111111b
  int i, j;

  for(i = 0; i < 7; ++i)
  {
    for(j = 0; j < 7; ++j)
    {
      m_byModuleData[x + j][y + i] = (byPattern[i] & (1 << (6 - j))) ? '\x30' : '\x20';
    }
  }
}

void SetVersionPattern(BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE])
{
  int i, j;
  int nVerData = m_QR_nVersion << 12;

  if(m_QR_nVersion <= 6)
    return;

  //Calculated bit remainder

  for(i = 0; i < 6; ++i)
  {
    if(nVerData & (1 << (17 - i)))
    {
      nVerData ^= (0x1f25 << (5 - i));
    }
  }

  nVerData += m_QR_nVersion << 12;

  for(i = 0; i < 6; ++i)
  {
    for(j = 0; j < 3; ++j)
    {
      m_byModuleData[m_nSymbleSize - 11 + j][i] = m_byModuleData[i][m_nSymbleSize - 11 + j] =
          (nVerData & (1 << (i * 3 + j))) ? '\x30' : '\x20';
    }
  }
}

void SetAlignmentPattern(int x, int y,BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE])
{
  static BYTE byPattern[] = {0x1f,  // 11111b
                             0x11,  // 10001b
                             0x15,  // 10101b
                             0x11,  // 10001b
                             0x1f
                            }; // 11111b
  int i, j;

  if(m_byModuleData[x][y] & 0x20)
    return;     //Excluded due to overlap with the functional module

  x -= 2;
  y -= 2;   //Convert the coordinates to the upper left corner

  for(i = 0; i < 5; ++i)
  {
    for(j = 0; j < 5; ++j)
    {
      m_byModuleData[x + j][y + i] = (byPattern[i] & (1 << (4 - j))) ? '\x30' : '\x20';
    }
  }
}



void SetFunctionModule(BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE])
{
  int i, j;


  //Position detection pattern
  SetFinderPattern(0, 0,m_byModuleData);
  SetFinderPattern(m_nSymbleSize - 7, 0,m_byModuleData);
  SetFinderPattern(0, m_nSymbleSize - 7,m_byModuleData);

  //Separator pattern position detection
  for(i = 0; i < 8; ++i)
  {
    m_byModuleData[i][7] = m_byModuleData[7][i] = '\x20';
    m_byModuleData[m_nSymbleSize - 8][i] = m_byModuleData[m_nSymbleSize - 8 + i][7] = '\x20';
    m_byModuleData[i][m_nSymbleSize - 8] = m_byModuleData[7][m_nSymbleSize - 8 + i] = '\x20';
  }


  //Registration as part of a functional module position description format information
  for(i = 0; i < 9; ++i)
  {
    m_byModuleData[i][8] = m_byModuleData[8][i] = '\x20';
  }

  for(i = 0; i < 8; ++i)
  {
    m_byModuleData[m_nSymbleSize - 8 + i][8] = m_byModuleData[8][m_nSymbleSize - 8 + i] = '\x20';
  }


  //Version information pattern
  SetVersionPattern(m_byModuleData);


  //Pattern alignment
  for(i = 0; i < QR_VersonInfo[m_QR_nVersion].ncAlignPoint; ++i)
  {
    SetAlignmentPattern(QR_VersonInfo[m_QR_nVersion].nAlignPoint[i], 6,m_byModuleData);
    SetAlignmentPattern(6, QR_VersonInfo[m_QR_nVersion].nAlignPoint[i],m_byModuleData);

    for(j = 0; j < QR_VersonInfo[m_QR_nVersion].ncAlignPoint; ++j)
    {
      SetAlignmentPattern(QR_VersonInfo[m_QR_nVersion].nAlignPoint[i], QR_VersonInfo[m_QR_nVersion].nAlignPoint[j],m_byModuleData);
    }
  }

  //Timing pattern
  for(i = 8; i <= m_nSymbleSize - 9; ++i)
  {
    m_byModuleData[i][6] = (i % 2) == 0 ? '\x30' : '\x20';
    m_byModuleData[6][i] = (i % 2) == 0 ? '\x30' : '\x20';
  }
}

void SetCodeWordPattern(BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE],BYTE m_byAllCodeWord[MAX_ALLCODEWORD])
{
  int x = m_nSymbleSize;
  int y = m_nSymbleSize - 1;

  int nCoef_x = 1;  //placement orientation axis x
  int nCoef_y = 1;  //placement orientation axis y

  int i, j;

  for(i = 0; i < m_ncAllCodeWord; ++i)
  {
    for(j = 0; j < 8; ++j)
    {
      do
      {
        x += nCoef_x;
        nCoef_x *= -1;

        if(nCoef_x < 0)
        {
          y += nCoef_y;

          if(y < 0 || y == m_nSymbleSize)
          {
            y = (y < 0) ? 0 : m_nSymbleSize - 1;
            nCoef_y *= -1;

            x -= 2;

            if(x == 6)     //Timing pattern
              --x;
          }
        }
      }
      while(m_byModuleData[x][y] & 0x20);   //Exclude a functional module


      m_byModuleData[x][y] = (m_byAllCodeWord[i] & (1 << (7 - j))) ? '\x02' : '\x00';

    }
  }
}


void SetMaskingPattern(int nPatternNo,BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE])
{
  int i, j;

  for(i = 0; i < m_nSymbleSize; ++i)
  {
    for(j = 0; j < m_nSymbleSize; ++j)
    {
      if(!(m_byModuleData[j][i] & 0x20))   //Exclude a functional module
      {
        int bMask;

        switch(nPatternNo)
        {
          case 0:
            bMask = ((i + j) % 2 == 0);
            break;

          case 1:
            bMask = (i % 2 == 0);
            break;

          case 2:
            bMask = (j % 3 == 0);
            break;

          case 3:
            bMask = ((i + j) % 3 == 0);
            break;

          case 4:
            bMask = (((i / 2) + (j / 3)) % 2 == 0);
            break;

          case 5:
            bMask = (((i * j) % 2) + ((i * j) % 3) == 0);
            break;

          case 6:
            bMask = ((((i * j) % 2) + ((i * j) % 3)) % 2 == 0);
            break;

          default: // case 7:
            bMask = ((((i * j) % 3) + ((i + j) % 2)) % 2 == 0);
            break;
        }

        m_byModuleData[j][i] = (BYTE)((m_byModuleData[j][i] & 0xfe) | (((m_byModuleData[j][i] & 0x02) > 1) ^ bMask));
      }
    }
  }
}

void SetFormatInfoPattern(int nPatternNo,BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE])
{
  int nFormatInfo;
  int i;
  int nFormatData;

  switch(m_nLevel)
  {
    case QR_LEVEL_M:
      nFormatInfo = 0x00; // 00nnnb
      break;

    case QR_LEVEL_L:
      nFormatInfo = 0x08; // 01nnnb
      break;

    case QR_LEVEL_Q:
      nFormatInfo = 0x18; // 11nnnb
      break;

    default: // case QR_LEVEL_H:
      nFormatInfo = 0x10; // 10nnnb
      break;
  }

  nFormatInfo += nPatternNo;

  nFormatData = nFormatInfo << 10;


  //Calculated bit remainder

  for(i = 0; i < 5; ++i)
  {
    if(nFormatData & (1 << (14 - i)))
    {
      nFormatData ^= (0x0537 << (4 - i)); // 10100110111b
    }
  }

  nFormatData += nFormatInfo << 10;


  //Masking
  nFormatData ^= 0x5412; // 101010000010010b


  // Position detection patterns located around the upper left
  for(i = 0; i <= 5; ++i)
    m_byModuleData[8][i] = (nFormatData & (1 << i)) ? '\x30' : '\x20';

  m_byModuleData[8][7] = (nFormatData & (1 << 6)) ? '\x30' : '\x20';
  m_byModuleData[8][8] = (nFormatData & (1 << 7)) ? '\x30' : '\x20';
  m_byModuleData[7][8] = (nFormatData & (1 << 8)) ? '\x30' : '\x20';

  for(i = 9; i <= 14; ++i)
    m_byModuleData[14 - i][8] = (nFormatData & (1 << i)) ? '\x30' : '\x20';


  //Position detection patterns located under the upper right corner
  for(i = 0; i <= 7; ++i)
    m_byModuleData[m_nSymbleSize - 1 - i][8] = (nFormatData & (1 << i)) ? '\x30' : '\x20';


  //Right lower left position detection patterns located
  m_byModuleData[8][m_nSymbleSize - 8] = '\x30';  //Module fixed dark

  for(i = 8; i <= 14; ++i)
    m_byModuleData[8][m_nSymbleSize - 15 + i] = (nFormatData & (1 << i)) ? '\x30' : '\x20';
}
int CountPenalty(BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE])
{
  int nPenalty = 0;
  int i, j, k;
  int nCount = 0;

  //Column of the same color adjacent module
  for(i = 0; i < m_nSymbleSize; ++i)
  {
    for(j = 0; j < m_nSymbleSize - 4; ++j)
    {
      int nCount = 1;

      for(k = j + 1; k < m_nSymbleSize; k++)
      {
        if(((m_byModuleData[i][j] & 0x11) == 0) == ((m_byModuleData[i][k] & 0x11) == 0))
          ++nCount;
        else
          break;
      }

      if(nCount >= 5)
      {
        nPenalty += 3 + (nCount - 5);
      }

      j = k - 1;
    }
  }


  //Adjacent module line of the same color
  for(i = 0; i < m_nSymbleSize; ++i)
  {
    for(j = 0; j < m_nSymbleSize - 4; ++j)
    {
      int nCount = 1;

      for(k = j + 1; k < m_nSymbleSize; k++)
      {
        if(((m_byModuleData[j][i] & 0x11) == 0) == ((m_byModuleData[k][i] & 0x11) == 0))
          ++nCount;
        else
          break;
      }

      if(nCount >= 5)
      {
        nPenalty += 3 + (nCount - 5);
      }

      j = k - 1;
    }
  }


  //Modules of the same color block (2 ~ 2)
  for(i = 0; i < m_nSymbleSize - 1; ++i)
  {
    for(j = 0; j < m_nSymbleSize - 1; ++j)
    {
      if((((m_byModuleData[i][j] & 0x11) == 0) == ((m_byModuleData[i + 1][j]   & 0x11) == 0)) &&
          (((m_byModuleData[i][j] & 0x11) == 0) == ((m_byModuleData[i]  [j + 1] & 0x11) == 0)) &&
          (((m_byModuleData[i][j] & 0x11) == 0) == ((m_byModuleData[i + 1][j + 1] & 0x11) == 0)))
      {
        nPenalty += 3;
      }
    }
  }


  //Pattern (dark dark: light: dark: light) ratio 1:1:3:1:1 in the same column
  for(i = 0; i < m_nSymbleSize; ++i)
  {
    for(j = 0; j < m_nSymbleSize - 6; ++j)
    {
      if(((j == 0) || (!(m_byModuleData[i][j - 1] & 0x11))) &&
          (m_byModuleData[i][j]     & 0x11)   &&
          (!(m_byModuleData[i][j + 1] & 0x11))  &&
          (m_byModuleData[i][j + 2] & 0x11)   &&
          (m_byModuleData[i][j + 3] & 0x11)   &&
          (m_byModuleData[i][j + 4] & 0x11)   &&
          (!(m_byModuleData[i][j + 5] & 0x11))  &&
          (m_byModuleData[i][j + 6] & 0x11)   &&
          ((j == m_nSymbleSize - 7) || (!(m_byModuleData[i][j + 7] & 0x11))))
      {

        //Clear pattern of four or more before or after
        if(((j < 2 || !(m_byModuleData[i][j - 2] & 0x11)) &&
            (j < 3 || !(m_byModuleData[i][j - 3] & 0x11)) &&
            (j < 4 || !(m_byModuleData[i][j - 4] & 0x11))) ||
            ((j >= m_nSymbleSize - 8  || !(m_byModuleData[i][j + 8]  & 0x11)) &&
             (j >= m_nSymbleSize - 9  || !(m_byModuleData[i][j + 9]  & 0x11)) &&
             (j >= m_nSymbleSize - 10 || !(m_byModuleData[i][j + 10] & 0x11))))
        {
          nPenalty += 40;
        }
      }
    }
  }


  //Pattern (dark dark: light: dark: light) in the same line ratio 1:1:3:1:1
  for(i = 0; i < m_nSymbleSize; ++i)
  {
    for(j = 0; j < m_nSymbleSize - 6; ++j)
    {
      if(((j == 0) || (!(m_byModuleData[j - 1][i] & 0x11))) &&
          (m_byModuleData[j]    [i] & 0x11)   &&
          (!(m_byModuleData[j + 1][i] & 0x11))  &&
          (m_byModuleData[j + 2][i] & 0x11)   &&
          (m_byModuleData[j + 3][i] & 0x11)   &&
          (m_byModuleData[j + 4][i] & 0x11)   &&
          (!(m_byModuleData[j + 5][i] & 0x11))  &&
          (m_byModuleData[j + 6][i] & 0x11)   &&
          ((j == m_nSymbleSize - 7) || (!(m_byModuleData[j + 7][i] & 0x11))))
      {

        //Clear pattern of four or more before or after
        if(((j < 2 || !(m_byModuleData[j - 2][i] & 0x11)) &&
            (j < 3 || !(m_byModuleData[j - 3][i] & 0x11)) &&
            (j < 4 || !(m_byModuleData[j - 4][i] & 0x11))) ||
            ((j >= m_nSymbleSize - 8  || !(m_byModuleData[j + 8][i]  & 0x11)) &&
             (j >= m_nSymbleSize - 9  || !(m_byModuleData[j + 9][i]  & 0x11)) &&
             (j >= m_nSymbleSize - 10 || !(m_byModuleData[j + 10][i] & 0x11))))
        {
          nPenalty += 40;
        }
      }
    }
  }


  //The proportion of modules for the entire dark

  for(i = 0; i < m_nSymbleSize; ++i)
  {
    for(j = 0; j < m_nSymbleSize; ++j)
    {
      if(!(m_byModuleData[i][j] & 0x11))
      {
        ++nCount;
      }
    }
  }

  nPenalty += (abs(50 - ((nCount * 100) / (m_nSymbleSize * m_nSymbleSize))) / 5) * 10;

  return nPenalty;
}


void FormatModule(BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE],BYTE m_byAllCodeWord[MAX_ALLCODEWORD])
{
  int i, j;
  int nMinPenalty;
  int nPenalty;

  ZeroMemory(m_byModuleData, sizeof(BYTE)*MAX_MODULESIZE*MAX_MODULESIZE);

  //Function module placement
  SetFunctionModule(m_byModuleData);


  //Data placement
  SetCodeWordPattern(m_byModuleData,m_byAllCodeWord);

  if(m_nMaskingNo == -1)
  {

    //Select the best pattern masking
    m_nMaskingNo = 0;

    SetMaskingPattern(m_nMaskingNo,m_byModuleData);     //Masking
    SetFormatInfoPattern(m_nMaskingNo,m_byModuleData);  //Placement pattern format information

    nMinPenalty = CountPenalty(m_byModuleData);

    for(i = 1; i <= 7; ++i)
    {
      SetMaskingPattern(i,m_byModuleData);      //Masking
      SetFormatInfoPattern(i,m_byModuleData);     //Placement pattern format information

      nPenalty = CountPenalty(m_byModuleData);

      if(nPenalty < nMinPenalty)
      {
        nMinPenalty = nPenalty;
        m_nMaskingNo = i;
      }
    }
  }

  SetMaskingPattern(m_nMaskingNo,m_byModuleData);   //Masking
  SetFormatInfoPattern(m_nMaskingNo,m_byModuleData); //Placement pattern format information

  // The module pattern converted to a Boolean value

  for(i = 0; i < m_nSymbleSize; ++i)
  {
    for(j = 0; j < m_nSymbleSize; ++j)
    {
      m_byModuleData[i][j] = (BYTE)((m_byModuleData[i][j] & 0x11) != 0);
    }
  }

}

void putBitToPos(unsigned int pos,int bw,unsigned char* bits)
{
  unsigned int tmp;
  unsigned int bitpos[8]= {128,64,32,16,8,4,2,1};
  if(bw==0) return;
  if(pos%8==0)
  {
    tmp=(pos/8)-1;
    bits[tmp]=bits[tmp]^bitpos[7];
  }
  else
  {
    tmp=pos/8;
    bits[tmp]=bits[tmp]^bitpos[pos%8-1];
  }
}

static BYTE m_byModuleData[MAX_MODULESIZE][MAX_MODULESIZE];
static BYTE m_byAllCodeWord[MAX_ALLCODEWORD];
static int m_nBlockLength[MAX_DATACODEWORD];
static BYTE m_byBlockMode[MAX_DATACODEWORD];
static BYTE m_byDataCodeWord[MAX_DATACODEWORD];
static BYTE m_byRSWork[MAX_CODEBLOCK];

int EncodeData(int nLevel, int nVersion, const char* lpSrc, int sourcelen, unsigned char QR_m_data[])
{
  int i, j;
  int bAutoExtent=0;
  int ncLength=0;
  int ncDataCodeWord;
  int ncTerminater;
  int nDataCwIndex;
  int ncBlock1;
  int ncBlock2;
  int ncBlockSum;
  int nBlockNo;
  int ncDataCw1;
  int ncDataCw2;
  BYTE byPaddingCode;
  int ncRSCw1;
  int ncRSCw2;

  m_nLevel = nLevel;
  m_nMaskingNo = -1;

  ZeroMemory(QR_m_data,MAX_BITDATA);
  // If the data length is not specified, acquired by l_strlen
  ncLength = sourcelen > 0 ? sourcelen : _strlen((char*)lpSrc);

  // printf("\n_strlen = %i\n",ncLength);

  if(ncLength == 0)
    return -1; // No data


  // Check version (model number)
  m_nEncodeVersion = GetEncodeVersion(lpSrc, ncLength, m_nBlockLength, m_byBlockMode,m_byDataCodeWord);

  if(m_nEncodeVersion == 0)
    return -1;
  // Over-capacity
  if(nVersion == 0)
  {

    // Auto Part
    m_QR_nVersion = m_nEncodeVersion;
  }
  else
  {
    if(m_nEncodeVersion <= nVersion)
    {
      m_QR_nVersion = nVersion;
    }
    else
    {
      if(bAutoExtent)
        m_QR_nVersion = m_nEncodeVersion;   // Automatic extended version (model number)
      else
        return -1;  // Over-capacity
    }
  }

  // printf("Using version %i\n", m_nEncodeVersion);

  // Terminator addition code "0000"
  ncDataCodeWord = QR_VersonInfo[m_QR_nVersion].ncDataCodeWord[nLevel];

  ncTerminater = min(4, (ncDataCodeWord * 8) - m_ncDataCodeWordBit);

  if(ncTerminater > 0)
    m_ncDataCodeWordBit = SetBitStream(m_ncDataCodeWordBit, 0, ncTerminater,m_byDataCodeWord);


  // Additional padding code "11101100, 00010001"
  byPaddingCode = 0xec;

  for(i = (m_ncDataCodeWordBit + 7) / 8; i < ncDataCodeWord; ++i)
  {
    m_byDataCodeWord[i] = byPaddingCode;

    byPaddingCode = (BYTE)(byPaddingCode == 0xec ? 0x11 : 0xec);
  }


  // Calculated the total clear area code word
  m_ncAllCodeWord = QR_VersonInfo[m_QR_nVersion].ncAllCodeWord;

  ZeroMemory(m_byAllCodeWord, m_ncAllCodeWord);

  nDataCwIndex = 0;    // Position data processing code word


  // Division number data block
  ncBlock1 = QR_VersonInfo[m_QR_nVersion].RS_BlockInfo1[nLevel].ncRSBlock;

  ncBlock2 = QR_VersonInfo[m_QR_nVersion].RS_BlockInfo2[nLevel].ncRSBlock;

  ncBlockSum = ncBlock1 + ncBlock2;


  nBlockNo = 0;       // Block number in the process


  // The number of data code words by block
  ncDataCw1 = QR_VersonInfo[m_QR_nVersion].RS_BlockInfo1[nLevel].ncDataCodeWord;

  ncDataCw2 = QR_VersonInfo[m_QR_nVersion].RS_BlockInfo2[nLevel].ncDataCodeWord;


  // Code word interleaving data placement
  for(i = 0; i < ncBlock1; ++i)
  {
    for(j = 0; j < ncDataCw1; ++j)
    {
      m_byAllCodeWord[(ncBlockSum * j) + nBlockNo] = m_byDataCodeWord[nDataCwIndex++];

    }

    ++nBlockNo;
  }


  for(i = 0; i < ncBlock2; ++i)
  {
    for(j = 0; j < ncDataCw2; ++j)
    {
      if(j < ncDataCw1)
      {
        m_byAllCodeWord[(ncBlockSum * j) + nBlockNo] = m_byDataCodeWord[nDataCwIndex++];
      }
      else
      {
        // 2 minute fraction block placement event
        m_byAllCodeWord[(ncBlockSum * ncDataCw1) + i]  = m_byDataCodeWord[nDataCwIndex++];
      }
    }

    ++nBlockNo;
  }



  // RS code words by block number (currently пїЅпїЅ The same number)
  ncRSCw1 = QR_VersonInfo[m_QR_nVersion].RS_BlockInfo1[nLevel].ncAllCodeWord - ncDataCw1;

  ncRSCw2 = QR_VersonInfo[m_QR_nVersion].RS_BlockInfo2[nLevel].ncAllCodeWord - ncDataCw2;


  // RS code word is calculated
  nDataCwIndex = 0;
  nBlockNo = 0;

  for(i = 0; i < ncBlock1; ++i)
  {
    ZeroMemory(m_byRSWork, sizeof(m_byRSWork));


    _memmove(m_byRSWork, m_byDataCodeWord + nDataCwIndex, ncDataCw1);


    GetRSCodeWord(m_byRSWork, ncDataCw1, ncRSCw1);


    // RS code word placement
    for(j = 0; j < ncRSCw1; ++j)
    {
      m_byAllCodeWord[ncDataCodeWord + (ncBlockSum * j) + nBlockNo] = m_byRSWork[j];
    }

    nDataCwIndex += ncDataCw1;
    ++nBlockNo;
  }

  for(i = 0; i < ncBlock2; ++i)
  {
    ZeroMemory(m_byRSWork, sizeof(m_byRSWork));

    _memmove(m_byRSWork, m_byDataCodeWord + nDataCwIndex, ncDataCw2);

    GetRSCodeWord(m_byRSWork, ncDataCw2, ncRSCw2);


    // RS code word placement
    for(j = 0; j < ncRSCw2; ++j)
    {
      m_byAllCodeWord[ncDataCodeWord + (ncBlockSum * j) + nBlockNo] = m_byRSWork[j];
    }

    nDataCwIndex += ncDataCw2;
    ++nBlockNo;
  }

  m_nSymbleSize = m_QR_nVersion * 4 + 17;


  // Module placement
  FormatModule(m_byModuleData, m_byAllCodeWord);

  for(i=0; i<m_nSymbleSize; i++)
  {
    for(j=0; j<m_nSymbleSize; j++)
    {
      if(!m_byModuleData[i][j])
      {
        putBitToPos((j*m_nSymbleSize)+i+1,0,QR_m_data);
      }
      else
        putBitToPos((j*m_nSymbleSize)+i+1,1,QR_m_data);
    }

  }

  return m_nSymbleSize;
}
