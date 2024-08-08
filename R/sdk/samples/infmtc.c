/*
 *
 * An example WPS SDK informat in C
 *
 */
#include <uwproc.h>
#include <assert.h>
#include <string.h>

void* iffmai(int* request)
{
    if (*request==1) {
        UWPRCC(0);

        /* Declare that this module provides 1 informat */
        FMTDFS(1);

        /* Declare first informat
           Informat      : SDKXMPONETWO
           Min width     : 1
           Max width     : 32
           Default width : 8
           Justification : 0 (left justified)
           Min decimals  : 0
           Max decimals  : 10
           Default dec.  : 0
       */
        FMTDFN(1, "@SDKXMPONETWO", 1, 32, 8, 0, 0, 10, 0);

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
 * Implementing routine for first declared informat (@SDKXMPONETWO)
 * from : string we're being asked to read in
 * inw  : width of the input string
 * w    : width of the output value (this will be the size of a 
 *        double, 8)
 * d    : format decimals
 * to   : output value
 */
int rtn1(char* from, int inw, int w, int d, double* to)
{
    if (inw>=3) {
        if (strncmp(from, "ONE", 3)==0) {
            *to = 1.0;
        }
        else if (strncmp(from, "TWO", 3)==0) {
            *to = 2.0;
        }
        else *to = MACMISSING;
    }
    else *to = MACMISSING;

    return 0;
}

