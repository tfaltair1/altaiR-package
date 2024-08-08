/*
 *
 * An example WPS SDK function in C
 *
 */
#include <uwproc.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

void* iffmai(int* request)
{
    if (*request==1) {
        UWPRCC(0);

        /* Declare that this module provides 4 function/call routine */
        FNCDFS(5);

        /* Declare first function.
           Function : SDKXMPADD
           Min args : 2
           Max args : 2
           Return type : 1 (numeric)

           Type of argument 1 : 1 (numeric)
           Type of argument 2 : 1 (numeric)
       */
        FNCDFN(1, "SDKXMPADD", 2, 2, 1);
        FNCDFA(1, 1, 1);
        FNCDFA(1, 2, 1);

        /* Declare second function.
           Function : SDKXMPCAT
           Min args : 2
           Max args : 2
           Return type : 2 (character)

           Type of argument 1 : 2 (character)
           Type of argument 2 : 2 (character)
       */
        FNCDFN(2, "SDKXMPCAT", 2, 2, 2);
        FNCDFA(2, 1, 2);
        FNCDFA(2, 2, 2);

        /* Declare third function.
           Function : SDKXMPCHOOSEN
           Min args : 1
           Max args : 100
           Return type : 1 (numeric)

           Type of argument 1 : 1 (numeric)
           Type of arguments 2-10 : 1 (numeric)

       */
        FNCDFN(3, "SDKXMPCHOOSEN", 1, 100, 1);
        FNCDFA(3, 1, 1);
        FNCDFA(3, 2, 1);
        FNCDFA(3, 3, 1);
        FNCDFA(3, 4, 1);
        FNCDFA(3, 5, 1);
        FNCDFA(3, 6, 1);
        FNCDFA(3, 7, 1);
        FNCDFA(3, 8, 1);
        FNCDFA(3, 9, 1);
        FNCDFA(3, 10, 1);

        /* Declare forth function.
           Function : SDKXMPCHOOSEC
           Min args : 1
           Max args : 100
           Return type : 2 (character)

           Type of argument 1 : 1 (numeric)
           Type of arguments 2-10 : 2 (character)

       */
        FNCDFN(4, "SDKXMPCHOOSEC", 1, 100, 2);
        FNCDFA(4, 1, 1);
        FNCDFA(4, 2, 2);
        FNCDFA(4, 3, 2);
        FNCDFA(4, 4, 2);
        FNCDFA(4, 5, 2);
        FNCDFA(4, 6, 2);
        FNCDFA(4, 7, 2);
        FNCDFA(4, 8, 2);
        FNCDFA(4, 9, 2);
        FNCDFA(4, 10, 2);

        /* Declare fifth function.
           Function : SDKXMPTEST
           Min args : 0
           Max args : 0
           Return type : 0 (call routine)
       */
        FNCDFN(5, "SDKXMPTEST", 0, 0, 0);

        return FNCDFE();
    }
    else if (*request==2) {
        return FNCFNE();
    }

    assert(0);
    return 0;
}

int iffext() { return 0; }

/*
 * Implementing routine for first declared function (SDKXMPADD)
 */
int rtn1(double* arg1, double* arg2, double* result)
{
    if (SAS_ZMISS(*arg1) || SAS_ZMISS(*arg2)) return F_EMISS;
    *result = *arg1 + *arg2;
    return F_OK;
}

#define MIN(a,b) (a)<(b) ? (a) : (b)

/*
 * Implementing routine for second declared function (SDKXMPCAT)
 */
int rtn2(
    short* arg1_maxlen, short* arg1_len, char** arg1,
    short* arg2_maxlen, short* arg2_len, char** arg2,
    short* result_maxlen, short* result_len, char** result)
{
    short copylen1, copylen2;
    
    copylen1 = MIN(*arg1_len, *result_maxlen);
    memcpy(*result, *arg1, copylen1);
    copylen2 = MIN(*arg2_len, *result_maxlen-copylen1);
    if (copylen2) memcpy(*result+copylen1, *arg2, copylen2);
    *result_len = copylen1+copylen2;
    return F_OK;
}

/*
 * Implementing routine for third declared function (SDKXMPCHOOSEN)
 */
int rtn3(double* dchoose, double* result)
{
    long n;
    int choose;
    double* arg;

    if (SAS_ZMISS(*dchoose) || *dchoose<0.0 || *dchoose>(double)MACINT)
        return F_EIAF+1;
    choose = (int)*dchoose;

    FNCN(&n);
    if (choose<1 || choose>=n) return F_EIAF+1;

    FNCARG(choose+1, 0, (ptr*)&arg, 0, 0);
    *result = *arg;

    return F_OK;
}

/*
 * Implementing routine for forth declared function (SDKXMPCHOOSEC)
 */
int rtn4(double* dchoose, 
         short* result_maxlen, short* result_len, char** result)
{
    long n;
    int choose;
    char* arg;
    short* arg_len;
    short arg_maxlen;
    short copylen;

    if (SAS_ZMISS(*dchoose) || *dchoose<0.0 || *dchoose>(double)MACINT)
        return F_EIAF+1;
    choose = (int)*dchoose;

    FNCN(&n);
    if (choose<1 || choose>=n) return F_EIAF+1;

    FNCARG(choose+1, 0, (ptr*)&arg, &arg_len, &arg_maxlen);

    copylen = MIN(*arg_len, *result_maxlen);
    memcpy(*result, arg, copylen);
    *result_len = copylen;

    return F_OK;
}

/*
 * Implementing routine for fifth declared function (SDKXMPTEST)
 */
int rtn5()
{
    typedef struct _TQ TQ;
    struct _TQ {
        char   eyecatcher[4];
        TQ*    tq;
        int    len;
    };
    TQ* tq;
    unsigned char* addr;
    char saddr[9];
    int i;
    
    tq = (TQ*)malloc(sizeof(TQ));
    memcpy(tq->eyecatcher, "TOMQ", 4);
    tq->tq = tq;
    tq->len = sizeof(TQ);

    addr = (unsigned char*)&tq;
    /* Following needed in order to be able to use the result easily 
       with PEEKCLONG. */
    for (i=0; i<4; i++) {
        sprintf(saddr+(i*2), "%02X", (unsigned int)addr[i]);
    }
    /* If you don't mind about PEEKCLONG, just
     * sprintf(saddr, "%08X", (unsigned int)tq);
     * The above commented line will work on big endian platforms 
     * (all but intel)
     * with PEEKCLONG as well
     */
    SAS_XJSYMPC("TOMQ", 4, saddr, 8, 'F', 0);


    return F_OK;
}