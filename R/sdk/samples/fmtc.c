/*
 *
 * An example WPS SDK format in C
 *
 */
#include <uwproc.h>
#include <assert.h>
#include <string.h>

void* iffmai(int* request)
{
    if (*request==1) {
        UWPRCC(0);

        /* Declare that this module provides 2 formats */
        FMTDFS(2);

        /* Declare first format
           Format        : SDKXMPONETWO
           Min width     : 1
           Max width     : 32
           Default width : 1
           Justification : 0 (left justified)
           Min decimals  : 0
           Max decimals  : 0
           Default dec.  : 0
       */
        FMTDFN(1, "SDKXMPONETWO", 1, 32, 1, 0, 0, 0, 0);

        /* Declare second format
           Format        : $SDKXMPONEOFF
           Min width     : 1
           Max width     : 200
           Default width : 1
           Justification : 0 (left justified)
           Min decimals  : 0
           Max decimals  : 0
           Default dec.  : 0
       */
        FMTDFN(2, "$SDKXMPONEOFF", 1, 200, 1, 0, 0, 0, 0);

        return FMTDFE();
    }
    else if (*request==2) {
        return FMTFNE();
    }

    assert(0);
    return 0;
}

int iffext() { return 0; }

/*
 * Implementing routine for first declared format (SDKXMPONETWO)
 * from : value we're being asked to format
 * inw  : width of a double, i.e 8
 * w    : format width
 * d    : format decimals
 * to   : output buffer.
 */
int rtn1(double* from, int inw, int w, int d, char* to)
{
    const char* s;
    int l;
    int i;

    if (SAS_ZMISS(*from)) s = "MISSING";
    else if (*from==1) s = "ONE";
    else if (*from==2) s = "TWO";
    else s = "OTHER";

    l = (int)strlen(s);
    if (l>w) {
        for (i=0; i<w; i++) to[i] = '*';
    }
    else {
        memcpy(to, s, l);
        for (i=l; i<w; i++) to[i] = ' ';
    }

    return 0;
}

/*
 * Implementing routine for second declared format ($SDKXMPONEOFF)
 * from : value we're being asked to format
 * inw  : width of the source string.
 * w    : format width
 * d    : format decimals
 * to   : output buffer.
 */
int rtn2(char* from, int inw, int w, int d, char* to)
{
    int i;
    int j;

    j = inw<w ? inw : w;
    for (i=0; i<j; i++) {
        to[i] = from[i]+1;
    }

    for (;i<w;) {
        to[i++] = ' ';
    }

    return 0;
}
