#ifndef UWHOST_INCLUDED
#define UWHOST_INCLUDED
/******************************************************************************
 * Constants
 ******************************************************************************/
/*
 * MACBIG      Largest double precision floating point value
 * MACFBIG     Largest single precision floating point value
 * MACFMISSING SAS missing value as a float
 * MACFSMALL   Smallest positive single precision floating point value
 * MACINT      Largest signed int value
 * MACUINT     Largest unsigned signed int value
 * MACLONG     Largest signed long value
 * MACULONG    Largest unsigned signed long value
 * MACMISSING  SAS missing value as a double
 * MACNULL     NULL value
 * MACSHORT    Largest signed short integer
 * MACSMALL    Smallest positive double precision floating point value
 */
#define MACBIG  1.7976931348623158e+308
#define MACFBIG 3.402823466e+38F
#define MACFMISSING ((float)SAS_ZMISSV('.'))
#define MACFSMALL 1.175494351e-38F
#define MACINT 2147483647
#define MACLONG 2147483647L
#define MACINTMIN (-2147483647 - 1)
#define MACLONGMIN (-2147483647L - 1)
#define MACUINT 0xFFFFFFFFU
#define MACULONG 0xFFFFFFFFUL
#define MACMISSING SAS_ZMISSV('.')
#define MACNULL 0
#define MACSHORT 32767
#define MACSMALL 2.2250738585072014e-308

#define WPS_MACLN2 0.693147180559945309417
#define WPS_MACLN10 2.30258509299404568402

#endif
