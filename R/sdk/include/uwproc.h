#ifndef UWPROC_INCLUDED
#define UWPROC_INCLUDED

#ifndef SASAPI
#ifdef __cplusplus
#define SASAPI extern "C"
#else
#define SASAPI
#endif
#endif
#include "uwhost.h"
#include <math.h>

/*
 * Header file defining the functions and constants
 * that make up the WPS SDK for writing user defined
 * functions, formats, informats and call routines
 */
/*=====================================================================
  
  Common definitions

  ====================================================================*/
typedef char* ptr;

#define U_MAXNAME 32
typedef struct {
    short name_l;          /* The length of the string in name */
    char  name[U_MAXNAME]; /* Characters of the name */
} u_sname;


/*======================================================================
  

  ====================================================================*/
/*
 *
 */ 
SASAPI void UWPRCC(void* null);

/*======================================================================
  
  Routines for defining an IFFC module containing functions or call 
  routines.

  ====================================================================*/

/*
 * Specifies the number of functions or call routines that are in an
 * IFFC package 
 *
 * See the sample IFFCs for usage information.
 */
SASAPI void FNCDFS(
    long count        /* The number of IFFCs to be defined in the 
                         module */
    );

/* 
 * Defines a single function or call routine
 *
 * See the sample IFFCs for usage information.
 */
SASAPI void FNCDFN(
    long         number,      /* The number of the routine that 
                                 processes the function or call routine.
                                 The first routine should have number 1 
                                 */
    const char*  name,        /* The name of the function or call 
                                 routine */
    long         min_args,    /* The minimum number of arguments that 
                                 can be passed to the function or call 
                                 routine */
    long         max_args,    /* The maximum number of arguments that 
                                 can be passed to the function or call 
                                 routine. This can be -1 if any number 
                                 of arguments are allowed. */
    long         return_type  /* The return type of the routine. This 
                                 can be one of the values:
                                  0 : if this is a CALL routine
                                  1 : if this is a function and the 
                                      return type is numeric
                                  2 : if this is a function and the 
                                      return type is character
                                  In addition the constant XFS_L can be
                                  added to this argument to indicate that
                                  null arguments can be passed to this 
                                  function.
                              */
    );

#define XFS_L     0x0200      /* Indicates that null arguments are allowed  */ 

/* 
 * Describes an argument to a function or call routine
 *
 * See the sample IFFCs for usage information.
 */
SASAPI void FNCDFA(
    long  routine_number, /* The number of the routine for which the 
                             argument is being described. This is the 
                             number passed to the first the FNCDFN 
                             routine */
    long  arg_number,     /* The number of this argument. The first 
                             argument has number 1 */
    long  arg_type        /* The type of the argument. This should be 
                             one of the following values:
                               1  if the argument is numeric
                               2  if the argument is character
                               3  if the argument can be either numeric 
                                  or character
                          */
    );

/* 
 * Completes the list of function and call routine definitions.
 *
 * The return value should be returned from the iffmai routine.
 *
 * See the sample IFFCs for usage information.
 */
SASAPI ptr FNCDFE();

/*
 * Returns a table of addresses for the routines that process the
 * functions and call routines defined in the IFFC package
 *
 * The return value should be returned from the iffmai routine.
 *
 * See the sample IFFCs for usage information.
 */
SASAPI ptr FNCFNE();

/*======================================================================
  
  Routines used to access arguments to functions or call routines.

  ====================================================================*/
/*
 * Obtains the value of an argument to a function or call routine
 * 
 * 
 */
SASAPI void FNCARG(
    long    arg_number,      /* Argument number to get the value of. 
                                1 for the first */
    long*   arg_type,        /* Pointer to integer in which will be 
                                returned the argument type. 
                                1=Numeric, 2=Character.
                                If the arg_number parameter is outside 
                                the range of 1..arg_count, then arg_type
                                is returned with 0.*/
    ptr*    arg_value,       /* Pointer to a pointer that will receive 
                                the address of the argument */
    short** current_len_ptr, /* Pointer to a short that will receive a 
                                pointer to the current length of a 
                                string argument.
                                No value is returned for numeric values.
                                */
    short*  max_length_ptr   /* Pointer to a short that will recieve the
                                max length of a string argument.
                                No value is returned for numeric values.
                                */
    );

/*
 * Determines the number of arguments that where passed to a function
 * or call routine.
 *
 * Use of this routine is only necessary for functions/call routines 
 * that take a variable number of arguments, have arguments that can be
 * of either numeric or character type, or have more than 10 arguments
 */
SASAPI void FNCN(long* count);

/*======================================================================
  
  Routines for defining an IFFC module containing formats or informats

  ====================================================================*/

/*
 * Specifies the number of formats or informats that are in an
 * IFFC package 
 *
 * See the sample IFFCs for usage information.
 */
SASAPI void FMTDFS(
    long count        /* The number of IFFCs to be defined in the 
                         module */
    );

/* 
 * Defines a single format or informat
 *
 * The name indicated whether a format or informat is being
 * defined, and whether it is numeric or character.
 * If the name begins with an '@', then an informat is being defined.
 * After the '@' (if any) there can be up to 8 characters defining the 
 * name. The first of those can be a '$' indicating a character format 
 * or informat. The '$', if present, uses one of the 8 characters.
 * All formats and informats within a module must have the same 5 letter
 * prefix. This does not include the '$' or the '@'.
 *
 * See the sample IFFCs for usage information.
 */
SASAPI void FMTDFN(
    long         number,       /* The number of the routine that 
                                  processes the format or informat. The 
                                  first routine should have number 1 */
    const char*  name,         /* The name of the format or informat */
    long         min_width,    /* The minimum width of the format/
                                  informat */
    long         max_width,    /* The maximum width of the format/
                                  informat */
    long         def_width,    /* The default width of the format/
                                  informat */
    long         justification,/* The justification of formatted values. 
                                  This should be one of the following 
                                  values:
                                    0 : for informats, or for formats 
                                        which justify output to the left
                                    1 : for formats that justify output 
                                        to the right
                                */
    long         min_decimals, /* The minimum allowed number of decimals
                                  for the format or informat */
    long         max_decimals, /* The maximum allowed number of decimals 
                                  for the format or informat */
    long         def_decimals  /* The default number of decimals for the 
                                   format or informat */
    );

/* 
 * Completes the list of format and informat definitions.
 *
 * The return value should be returned from the iffmai routine.
 *
 * See the sample IFFCs for usage information.
 */
SASAPI ptr FMTDFE();

/*
 * Returns a table of addresses for the routines that process the
 * formats and informats defined in the IFFC package
 *
 * The return value should be returned from the iffmai routine.
 *
 * See the sample IFFCs for usage information.
 */
SASAPI ptr FMTFNE();


/*======================================================================

  SAS_DSS routines : Access to DATA step symbol tables.

  ====================================================================*/
struct SYMINFO {
    char        type;       /* Variable type: 1 - numeric, 2 - character 
                             */
	char        align1;
    short       size;       /* Length of variable */
    const char* spelling;   /* Pointer to the variable name */
    short       spellen;    /* Length of the name */
    short       slabell;    /* Length of label */
    const char* slabel;     /* Pointer to the label */
    char        formatn[32];/* Format name, padded if necessary with 
                               blanks. */
    short       formatw;    /* Format width, or -1 if the width not
                               specified. */
    short       formatd;    /* Format decimals, or -1 if the digits not
                               specified. */
    long        formatj;    /* Format justification. Always 0 under WPS  
                             */
    long        formatc;    /* Format code */
    ptr         formatp;    /* Format data */
    int        (*ignore1)();
    char        iformatn[32];/* Informat name, padded if necessary with 
                               blanks. */
    short       iformatw;   /* Informat width, or -1 if the width not 
                               specified. */
    short       iformatd;   /* Informat decimals, or -1 if the digits not
                               specified. */
    long        iformatj;   /* Informat justification. Always 0 under 
                               WPS */
    long        iformatc;   /* Informat code */
    ptr         iformatp;   /* Informat data */
    int        (*ignore2)();

    union {
        ptr        cloc;
        double    *floc;     /* Pointer to numeric value */
        struct X_STRING {
            short maxlen;    /* Allocated length */
            short curlen;    /* Current length */
            ptr   data;      /* Pointer to the string data */
        } *tloc;
    } loc;                   /* Value storage location */
};

/*
 * Returns the number of variables in the DATA step -- the number
 * of entries in the symbol table
 */
SASAPI int SAS_DSSRSN();

/*
 * Obtains all symbol table entries
 *
 * The n parameter is modified by the SAS_DSSRSIF to reflect the 
 * number of elements in the syminfoptr array filled in by the routine. 
 */
SASAPI void SAS_DSSRSIF(
    struct SYMINFO*  syminfoptr, /* Pointer to SYMINFO array to fill in
                                  */
    long*            n           /* Pointer to number of SYMINFO 
                                    elements */
    );

/*
 * Obtains a symbol table entry for a named variable
 *
 * The routine returns 0 if the variable of the given name was found,
 * and non-zero if not.
 */
SASAPI int SAS_DSSRSI(
    const char*     varname,  /* Name of the variable */
    int             varnamel, /* Length of the variable name */
    struct SYMINFO* syminfo   /* Pointer to SYMINFO structure to fill 
                                 in */
    );

/*
 * Iterates through all symbol table entries.
 *
 * The routine returns 0 if a variable was found and information was
 * returned in the syminfo structure. A value of 1 is returned if there
 * are no more variables to return.
 */
SASAPI int SAS_DSSRSIT(
    struct SYMINFO* syminfo,  /* Pointer to SYMINFO structure to fill 
                                 in */
    ptr*            anchor    /* Anchor pointer. Pass address of a NULL
                                 ptr variable on first invocation */
    );

/*======================================================================

  SAS_XF routines : Formats and Informats

  ====================================================================*/
struct FATTRSTR {
    short   fwmin;  /* Minimum width */
    short   fwmax;  /* Maximum width */
    short   fwdef;  /* Default width */
    short   fjust;  /* Justification: 0=left, 1=right */

    short   fdmin;  /* Minimum number of decimals */
    short   fdmax;  /* Maximum number of decimals */
    short   fddef;  /* Default number of decimals */
    short   fmdef;  /* Default modifier : reserved */
};

/*  
 * Deletes one or all loaded formats and informats.
 *
 * The iffcode parameter identifies the format code to delete.
 * Specify the value 999 to delete all formats and informats.
 *
 * It is not necessary to explicitly delete formats and informats
 * They will be deleted automatically when SAS_XEXIT is called.
 */
SASAPI void SAS_XFDEL(long iffcode);

/* 
 * Loads a named format or informat
 *
 * Returns zero if the format was loaded successfully, 
 * and non-zero otherwise
 */
#if 0
Not currently supported.
SASAPI int SAS_XFNAME(
    const char* format_name,  /* Pointer to 32 byte name, padded with 
                                 blanks if necessary. The first blank or
                                 null terminates the name if this is 
                                 before 32 characters */
    int         format_type,  /* Whether a format or informat is to be 
                                 loaded.
                                 Pass 'F' for a format, 'I' for an 
                                 informat */
    ptr         format_info,  /* Optionally pass in the pointer to a 
                                 FATTRSTR structure to receive 
                                 information about maximum, minimum and 
                                 default widths of the format/informat 
                                 */
    long*       iffcode       /* Receives the format/informat code */
    );
#endif

/* 
 * Returns the name associated with a format or informat code
 * Returns a null pointer if the format code is not valid.
 * The returned string will have a leading $ for character
 * formats, a leading @ for numeric informats and a leading
 * @$ for a character informat.
 */
SASAPI const char* SAS_XFSHOW(long iffcode);

/*
 * Performs an informat request for a character value.
 *
 * This routine uses an informat to read a character data from a 
 * supplied field. 
 *
 * This routine is equivalent to using formatted input with informat
 *  formatw.
 * where format is the name of the informat passd to SAS_XFNAME, and 
 * w is the input_length parameter.
 *
 * Only as much of the output buffer will be written to as is necessary
 * to input the given input string. There is no way to tell how much 
 * has been used. For example performing a SAS_XFXIC call with the $HEX
 * informat and passing an input string of length 20 will produce
 * 10 characters in the output string, whatever length (greater than 10)
 * is passed to output_length. The remainder of the output_string buffer
 * is unmodified.
 * Passing an output buffer that is too short will result in a truncated 
 * output string.
 *
 * The return value will be 0 if the routine was successful and nonzero
 * otherwise. 
 * The return value will be 0 if the routine was successful and nonzero
 * otherwise. Success means that the informat successfully parsed the 
 * input string. If the informat determines that the input string is
 * invalid, a non-zero return code is returned.
 * The input length being outside the valid range doesn't necessarily 
 * result in non-zero return code.
 */
SASAPI int SAS_XFXIC(
    const void*    input,         /* Pointer to the source field */
    int            input_length,  /* Length of the source field */
    long           informat_code, /* Code identifying informat to use. 
                                     If this is 0 then the default 
                                     informat is used */
    char*          output_string, /* Receives the output string */
    int            output_length  /* Length of output string buffer */
    );


/*
 * Performs an informat request for a numeric value.
 *
 * This routine uses an informat to read a numeric data from a supplied
 * field. 
 *
 * This routine is equivalent to using formatted input with informat
 *  formatw.d
 * where format is the name of the informat passd to SAS_XFNAME, and 
 * w is the input_length parameter and d is the decimals parameter.
 *
 * The return value will be 0 if the routine was successful and nonzero
 * otherwise. Success means that the informat successfully parsed the 
 * input string. If the informat determines that the input string is
 * invalid, a non-zero return code is returned.
 * The input length being outside the valid range doesn't necessarily 
 * result in non-zero return code.
 * 
 */
SASAPI int SAS_XFXIN(
    const void*    input,         /* Pointer to the source field */
    int            input_length,  /* Length of the source field */
    int            decimals,      /* Number of decimal for the informat 
                                   */
    long           informat_code, /* Code identifying informat to use. 
                                     If this is 0 then the default 
                                     informat is used */
    double*        result         /* Receives the resulting numeric 
                                     value */
    );

/* 
 * Performs a formatting request for a character value.
 *
 * 
 * The return value will be 0 if the routine was successful and nonzero
 * otherwise. 
 *
 * It is not necessarily an error to supply a value for width that is 
 * outside the declared valid range for the format. The formatted value 
 * will be truncated or padded as necessary so that it fills the output 
 * buffer.
 * The formatted value will be padded on the left or the right according
 * to the justification defined for the format.
 */
SASAPI int SAS_XFXPC(
    const char*    char_value,   /* Pointer to the character value to 
                                    format */
    int            length,       /* Length of the input value */
    long           format_code,  /* Code identifying format to use. If 
                                    this is, then the default format 
                                    ($CHAR.) is used */
    char*          output_field,  /* Pointer to the output field */
    int            output_length  /* Length of the output field */
);

/* 
 * Performs a formatting request for a numeric value.
 *
 * 
 * The return value will be 0 if the routine was successful and nonzero
 * otherwise. 
 * 
 * It is not necessarily an error to supply a value for width that is 
 * outside the declared valid range for the format. The formatted result
 * will be padded to the relevant length, either to the right or the 
 * left, depending on the defined justification for the format.
 *
 * The width parameter determines the number of bytes written to the
 * output field, so the buffer pointed to by output_field should be 
 * at least width bytes in length.
 * 
 */
SASAPI int SAS_XFXPN(
    double         numeric_value, /* Pointer to the numeric value to 
                                     format */
    int            width,         /* Width of the output field */
    int            decimals,      /* Number of decimals for the format 
                                   */
    long           format_code,   /* Code identifying format to use. If 
                                     this is, then the default format 
                                     w.d is used */
    char*          output_field   /* Pointer to the output field */
);

/*======================================================================

  SAS_XJ routines : Macro Variable access.

  ====================================================================*/
/*
 * Returns the value of a macro variable. 
 * This is equivalent to SYMGET
 *
 * The return value is a return code. A return code of 0
 * indicates success. A non-zero return code indicates failure and
 * usually means that the macro name is unrecognised. This particular
 * error is indicated with a return value of -1.
 *
 * This routine allocates memory to contain the value of the macro 
 * variable and returns a pointer to that memory in the value
 * parameter. It is important that this memory is freed by calling
 * SAS_XJSYMFR
 */
SASAPI int SAS_XJSYMGC(
    const char* macro_name,  /* Name of the macro variable to return */
    int         name_length, /* Length of the name */
    char**      value,       /* Receives pointer to memory containing 
                                value */
    int*        value_length,/* Receives length of value */
    int         zero,        /* Must be zero */
    ptr         null         /* Must be NULL */
    );

/*
 * Sets the value of a macro variable.
 *
 * The return value is a return code. A return code of 0
 * indicates success. A non-zero return code indicates failure and
 * usually means that the macro name is invalid. The return code
 * can be passed to SAS_XPRLOG to report the status
 */
SASAPI int SAS_XJSYMPC(
    const char* macro_name,   /* Name of the macro variable to set */
    int         name_length,  /* Length of the name */
    const char* value,        /* Value to set the macro variable to */
    int         value_length, /* Length of the value */
    int         f,            /* Must be 'F' */
    ptr         null          /* Must be 0 or NULL */
    );

/*
 * Frees memory returned from SAS_XJSYMGC
 */
SASAPI void SAS_XJSYMFR(
    char*       mem          /* Pointer returned from SAS_XJSYMGC in 
                                value */
    );


/*======================================================================

  SAS_XM routines : Memory management

  ====================================================================*/
#define XM_HEAP ((void*)-1)
#define XM_ZERO 1
#define XM_EXIT 2
#define XM_SIZE 4
#define XM_OSA  4096L
#define XM_ISA  4096L

/*
 * Allocates memory from a given pool
 *
 * The pool_id_ptr parameter must either be a value previously returned 
 * from a call to the SAS_XMPOOLC routinem or it must be the constant 
 * XM_HEAP in order to allocate memory from the standard process heap.
 * 
 * The flags parameter can be any combination of the following flags:
 *   XM_EXIT:  Calls SAS_XEXIT if no memory is available to service the 
 *             request.
 *   XM_SIZE:  Stores the size of the area allocated so that you do not 
 *             need to specify the size in later calls to free the 
 *             memory
 *   XM_ZERO:  Initialises the allocated memory to zero.
 *
 * These flags are combined with any that might have been specified on 
 * the call to SAS_XMPOOLC. 
 *
 * The return value is a pointer to the memory allocated, or 0 if no 
 * memory could be allocated and the XM_EXIT flag was not specified.
 *
 * The memory allocated can later be freed using SAS_XMFREE. 
 * Alternatively the entire pool can be freed using SAS_XMPOOLD.
 *
 */
SASAPI void* SAS_XMALLOC(
    void*    pool_id_ptr,   /* Pointer to the pool to allocate from */
    int      length,        /* Number of bytes to allocate */
    int      flags          /* Flags. See the documentation for 
                               details */
    );

/*
 * Allocates memory, calling SAS_XEXIT automatically if there is 
 * insufficient memory available.
 * 
 * This allocates memory from the standard procedure heap and exits
 * the procedure if insufficient memory is available. It is equivalent
 * to calling
 *  SAS_XMALLOC(XM_HEAP, length, XM_EXIT | XM_SIZE);
 *
 */
SASAPI void* SAS_XMEMEX(int length);

/*
 * Frees memory allcoated by SAS_XMEMGET, SAS_XMEMZER, or SAS_XMEMEX
 */
SASAPI void SAS_XMEMFRE(void* ptr);

/* 
 * Allocates memory
 * The memory is not zeroed, and if insufficient memory is 
 * available, 0 is returned. See SAS_XMEMEX and SAS_XMEMZER
 * for alternatives to this.
 *
 * This is equivalent to calling
 *  SAS_XMALLOC(XM_HEAP, length, XM_SIZE);
 */
SASAPI void* SAS_XMEMGET(int length);

/* 
 * Allocates memory and zeros it.
 * If insufficient memory is available, 0 is returned. 
 *
 * This is equivalent to calling
 *  SAS_XMALLOC(XM_HEAP, length, XM_ZERO | XM_SIZE);
 */
SASAPI void* SAS_XMEMZER(int length);

/*
 * Frees memory allocated from a pool.
 *
 */
SASAPI void SAS_XMFREE(
    void*     pool_id_ptr,/* Pointer to pool from which memory was 
                             allocated */
    void*     mem_ptr,    /* Pointer to allocated memory */
    int       length      /* Length of allocated memory, or -1 if 
                             XM_SIZE was specified on allocation */
    );

/* 
 * Creates a new memory pool
 *
 * The initial_size parameter specifies the initial storage
 * allocation for the pool. The value XM_ISA can be specified
 * here to indicate a default initial storage size.
 *
 * The overflow_size parameter specifies the increment by which 
 * the pool should grow when necessary. A value of 0 can be
 * given here to indicate that the pool isn't allowed to grow.
 * Alternatively a value of XM_OSA can be used to specify a 
 * default storage size increment.
 *
 * The flags parameter sets flags that will apply to all
 * allocations from the pool. The flags specified here are 
 * combined with the flags specified on SAS_XMALLOC.
 * Any combination of the following flags can be specified:
 * 
 *   XM_EXIT:  The SAS_XEXIT routine is called if an allocation request
 *             from the pool fails due to insufficient space.
 *   XM_SIZE:  The size of any allocations should be stored along with
 *             the allocation so that the space can later be freed.
 *   XM_ZERO:  All areas allocated from the pool should have their 
 *             contents zeroed.
 *
 * The return value is a pointer that should be used to identify
 * the pool to further SAS_XM routines. A null pointer is returned
 * if the initial size of memory cannot be allocated and XM_EXIT
 * is not specified.
 */
SASAPI void* SAS_XMPOOLC(
    long      initial_size,  /* Initial size of the pool */
    long      overflow_size, /* Increment by which to grow pool */
    int       flags          /* Flags for the pool */
    );

/*
 * Deletes a memory pool created using SAS_XMPOOLC
 */
SASAPI void SAS_XMPOOLD(void* pool_id_ptr);

/*======================================================================

  SAS_XOPT routines : System options.

  ====================================================================*/
/*
 * Fetches the value of a bit option.
 *
 * The name of the system option must be null terminated, and can 
 * be in any case.
 * The return code returned in return_code will be 0 if the option
 * is found and the value is returned, -1 if the option name is invalid
 * or isn't the name of a system option, and -2 if the option is known,
 * but isn't a bit option.
 * The return value is the value of the option, 1 if the option is ON,
 * 0 if the option is OFF.
 */
SASAPI int SAS_XOPTBGT(
    const char* option_name,  /* The name of the system option. */
    int*        return_code   /* Receives a return code */
    );

/* 
 * Sets the value of a bit option.
 * The name of the system option must be null terminated, and can be 
 * in any case.
 * 
 * The return code returned in return_code will be 0 if the option
 * is found and the value is returned, -1 if the option name is invalid
 * or isn't the name of a system option, and -2 if the option is known,
 * but isn't a bit option. Note that the SAS documentation incorrectly
 * states that this return code can be passed to SAS_XPRLOG. It can't
 */
SASAPI int SAS_XOPTBST(
    const char* option_name,
    int         value
    );

/*
 * Fetches the value of a character option.
 *
 * The name of the system option must be null terminated, and can be in 
 * any case.
 * The return code returned in return_code will be 0 if the option
 * is found and the value is returned, -1 if the option name is invalid
 * or isn't the name of a system option, and -2 if the option is known,
 * but isn't a character option.
 *
 * The return value is a pointer to the null terminated string value.
 * This value may change, so you should if necessary duplicate and store
 * the string if you need to refer to it later.
 */
SASAPI const char* SAS_XOPTCGT(
    const char* option_name,  /* The name of the system option. */
    int*        return_code   /* Receives a return code */
    );

/* 
 * Sets the value of a character option.
 *
 * The name of the system option must be null terminated, and can be 
 * in any case. The new value must be null terminated. The value is 
 * subject to the same rules on case, quotes and parentheses as when a 
 * value is set using the OPTIONS statement.
 * The return code returned in return_code will be 0 if the option
 * is found and the value is returned, -1 if the option name is invalid
 * or isn't the name of a system option, and -2 if the option is known,
 * but isn't a character option. Note that the SAS documentation 
 * incorrectly states that this return code can be passed to SAS_XPRLOG. 
 * It can't.
 */
SASAPI int SAS_XOPTCST(
    const char* option_name,  /* The name of the system option. */
    const char* value         /* The new value */
    );


/*
 * Fetches the value of an integer option.
 *
 * The name of the system option must be null terminated, and can be 
 * in any case.
 * The return code returned in return_code will be 0 if the option
 * is found and the value is returned, -1 if the option name is invalid
 * or isn't the name of a system option, and -2 if the option is known,
 * but isn't an integer option. 
 *
 * The return value is the value of the option.
 */
SASAPI long SAS_XOPTIGT(
    const char* option_name,  /* The name of the system option. */
    int*        return_code   /* Receives a return code */
    );

/* 
 * Sets the value of an integer option.
 *
 * The name of the system option must be null terminated, and can be 
 * in any case.
 * The return code returned in return_code will be 0 if the option
 * is found and the value is returned, -1 if the option name is invalid
 * or isn't the name of a system option, and -2 if the option is known,
 * but isn't an integer option. Note that the SAS documentation 
 * incorrectly states that this return code can be passed to SAS_XPRLOG. 
 * It can't.
 */
SASAPI int SAS_XOPTIST(
    const char* option_name,  /* The name of the system option. */
    long        value         /* The new value */
    );

/*======================================================================

  SAS_XP routines : Printing

  The general form of format code is as follows:

    $[flags][width][.precision][l]type

  flags width and precision are not necessarily valid for all types.

  The type codes allowed are as follows:

  b     string     Formats a character string that ends in a blank or a
                   null terminator. If a length is provided as in %*b or
                   %nb, then the first blank character or null 
                   terminator after that length terminates the string.

  c     int        Formats a string character

  d     int|long   Formats an integer

  f     double     Formats a floating point number. The number is 
                   formatted as if by w.d format. 

  s     string     Formats a string

  x     int|long   Formats an integer in hexadecimal. Hexadecimal 
                   characters are always printed in upper case, whether
                   x or X are used.     
   

  o     int|long   Formats an integer in octal.

  Unlike with conventional C printf usage, the format codes are not case
  sensitive. So D is identical to d, X is identical to x. In 
  conventional C printf usage, X for example prints out an integer in 
  hexadecimal with upper case hex digits, whereas x prints out with 
  lower case hex digits.

  The following flags are supported.
  -     Valid for numeric output format codes. 
        Left aligns the value in the output field. By default the value 
        is right aligned. Has no effect on the s format code.
  

  The width field can either be a number specified in the format code 
  itself or it can be specified as * in which case the width field is 
  taken from the next argument in the argument list. The width argument
  must therefore preceed the precision argument, if any, and the value 
  to be formatted.
  The effect of the width depends on the format type:

    f    If no width is specified, then 
         the number is formatted using w.d into a temporary buffer
         and the trimmed result is output. If a width is specified, 
         then the w.d format is used directly to print the output.

    s    The width specifies the length of the input string. If no width
         is specified, the input string is assumed to be null 
         terminated.

  Otherwise the width specifies the width of the output field

  The precision field can either be a number specified in the format 
  code itself, preceeded by a '.', or it can be specified as '.*' in 
  which case the precision value is taken from the next argument in the
  argument list.
  The effect of the precision field depends on the format type:

    b   The precision field has no effect.
    
    c   The precision field has no effect.
    
    d   Specifies the minimum number of digits to be printed. The 
        value is padded on the left with zeros if necessary.

    f   Controls the number of decimal digits generated in the output.
        The width and precision fields together determine the format 
        used to output the number. 

    s   Controls the width of the output field.

  There are special forms of %f that allow the use of an arbitrary 
  format loaded with SAS_XFNAME, or SAS_XFFILE. Specifying
     %w.$f
  formats a numeric using width 'w' and a format code that is given as 
  an argument before the number to format (so two arguments are 
  required, the format code and the number to format). 

  The width can be specified as an argument using 
     %*.$f
  in this case the arguments would be the width, the format code and the
  number to format.
  
  Note that the use of width and precision in %s are subtly different to 
  conventional C usage. The width specifies the length of the input 
  string. That is, to print the contents of a string that is not null 
  terminated, or to print part of a string, a width field must be 
  specified. In conventional C printf usage, it is the precision that 
  has this effect. In conventional C printf usage the width gives the 
  minimum width of the output field, and the output will take up more 
  space than this if more characters are provided in the input string 
  (either up to the null terminator or up to the width given in the 
  precision). In SAS usage the precision defines the width of the output
  field, and only that number of characters will ever be output.
  In addition, output using %s is always left aligned, unlike in normal 
  C printf usage where it is right aligned unless the - modifier is 
  used.

  In addition to the above normal printf style format codes, there are a
  number of SAS specific format controls that can be used.

  %nh  Highlights an entire line using a specific color. The color codes 
       are:
          %0h  The color of data lines
          %1h  The color of header lines
          %2h  The color of source lines
          %3h  The color of title lines
          %4h  The color of BY lines
          %5h  The color of footnote lines
          %6h  The color of error lines
          %7h  The color of warning lines
          %8h  The color of note lines.

       This option is not supported by the SAS_XPSSTR routine which 
       formats a message to a string. It is only valid for the 
       SAS_XPSLOG routine, or the routines that print a message to the
       procedure output file.

  %m   Marks a position to which subsequent wrapped lines should be 
       indented.
       This format code is only valid for the SAS_XPSLOG routine.

  %n   Advances to a new line and cancels the effect of %m. \n can be
       used as an alternative
       This format code is only valid for the SAS_XPSLOG routine.

  %-2n Advances to a new line without cancelling the effect of %m
       This format code is only valid for the SAS_XPSLOG routine.

  %nt  Formats text to begin in column n. When you specify a plus sign
  %+nt or a minus sign the text begins at a position relative to the
  %-nt current location.

  %1z  Outputs the string ERROR:
  %2z  Outputs the string WARNING:
  %3z  Outputs the string NOTE:

  %%   Generates a single % sign.


  ====================================================================*/
/*
 * Prints a message to the log
 *
 * Log messages, unlike messages written to the procedure output file, 
 * can be any length and are wrapped to subsequent lines if the message 
 * does not fit on one line. The message is only split at spaces between 
 * words.
 *
 * For the list of printf-style format codes and the expected argument 
 * types see above.
 */
SASAPI void SAS_XPSLOG(
    const char* format_string,  /* The format string, null terminated */
    ...                         /* Any inserts into the message */
    );

/*
 * Formats a message to a supplied buffer
 *
 * If the message is too long to fit in the supplied output buffer,
 * then the message will be truncated. The resulting string buffer
 * will be null terminated.
 *
 * The return value is the number of character written to the 
 * destination buffer, not including the null terminator.
 */
SASAPI int SAS_XPSSTR(
    char*       output_buff,    /* The destination buffer */
    int         length,         /* The length of the destination area. 
                                 */
    const char* format_string,  /* The format string, null terminated 
                                 */
    ...                         /* Any inserts into the message */
    );

/*
 * Formats a message to the output buffer for printing to the
 * procedure output file, or the log file. When used within 
 * functions, formats and informats the output is sent to the 
 * log.
 *
 * Note that the message is not printed to the log
 * file, it is simply formatted to the output buffer at the 
 * current output buffer position.
 * If the message is too long to fit in the remainder of the 
 * output buffer, then it is truncated to fit.
 *
 * This routine works in much the same way as printf. See above for 
 * a list of the valid format codes and the expected argument types.
 */
SASAPI void SAS_XPS(
    const char* format_string,  /* The format string, null terminated */
    ...                         /* Any inserts into the message */
    ); 

/*======================================================================

  SAS_Z routines.

  ====================================================================*/

/*-------------------------*/
/* Error and Exit routines */
/*-------------------------*/

/*
 * Issues an internal message to the WPS log. This is for
 * issuing debug messages to aid in debugging your routines.
 * it is not intended for issuing normal user targetted messages
 */
SASAPI int SAS_XEBUG(
    const char* message /* message to issue in the log */
    );

/*
 * Exits from the current procedure or DATA step, and issues
 * a message if necessary
 */
SASAPI int SAS_XEXIT(
    int exit_code,    /* code indicating rason for exit */
    int reason_code  /* not currently used -- set to 0 */
    );

/*
 * The following are symbolic constants for valid return
 * codes that can be passed to SAS_XEXIT
 */ 
#define XEXITNORMAL   0
#define XEXITABEND    1
#define XEXITBUG      2
#define XEXITDATA     3
#define XEXITERROR    4
#define XEXITIO       5
#define XEXITMEMORY   6
#define XEXITPROBLEM  7
#define XEXITSEMANTIC 8
#define XEXITSYNTAX   9


/*--------------------------*/
/* String handling routines */
/*--------------------------*/

/*
 * Compares two areas of memory. The areas can either be
 * strings, or can be integers, or can be double floating 
 * point values, depending on the value of type_length.
 * Doubles are compared according to normal SAS rules, including
 * missing value handling.
 * The type_length field indicates the type of the areas and the length
 * of the character fields. The value can be
 *   >0  Indicating that the areas are character strings of this length
 *   =0  Indicating that the areas are 4 byte integer values.
 *   =-2 Indicating that the areas are double precision floating point
 *       values.
 *
 * The offset field gives the offset from the area1/area2 pointers to 
 * where the key field actually exists. 
 *
 * The return value is >0 if the value in area1 is greater than the 
 * value in area2, <0 if the value in area1 is less than the value in 
 * area2, and =0 if the values are the same.
 *
 * Note that integers and floats should be correctly aligned.
 */
SASAPI int SAS_ZCOMOFF(
    void* area1,       /* pointer to first area */
    void* area2,       /* pointer to second area */
    int   type_length, /* type and length of areas */
    int   offset       /* offset to key field to compare */
    );

/*
 * Compares two strings of equal length
 *
 * If length is 0, then 0 is returned, otherwise length indicates the 
 * number of bytes to compare.
 *
 * If area2 is NULL, then area1 is compared to blanks.
 *
 * The comparison is done simply on the numeric values of the 
 * characters, without any consideration of national collation order.
 *
 * Returns <0 if str1 compares less than str2, >0 if str1 compares equal
 * to str2, and ==0 if the two strings compare the same.
 */
SASAPI int SAS_ZCOMPAR(
    const char* str1,  /* pointer to first string to compare */
    const char* str2,  /* pointer to second string to compare, or NULL 
                        */
    int length         /* number of bytes to compare */
    );


/*
 * Compares two strings of equal length, case insensitively
 *
 * If length is 0, then 0 is returned, otherwise length indicates the 
 * number of bytes to compare.
 *
 * If area2 is NULL, then area1 is compared to blanks.
 *
 * The strings are compared as if they are both in upper case.
 * The comparison is done simply on the numeric values of the 
 * characters, without any consideration of national collation order.
 *
 * Returns <0 if str1 compares less than str2, >0 if str1 compares equal 
 * to str2, and ==0 if the two strings compare the same.
 */
SASAPI int SAS_ZCOMPUP(
    const char* str1,  /* pointer to first string to compare */
    const char* str2,  /* pointer to second string to compare, or NULL 
                        */
    int length         /* number of bytes to compare */
    );


/*
 * Converts any 8 byte character string to a valid SAS name.
 * Note that this does only work on 8 character names, only 
 * 8 characters of the buffer passed in value_ptr are converted.
 * It is not sensitive to VALIDVARNAME.
 *
 * The following changes are made to the name.
 *   * Lowercase letters are replaced with uppercase
 *   * If the name begins with a number, it is prefixed with 
 *     an underscore
 *   * Characters that are not leters or numbers are replaced
 *     with an underscore.
 *   * Any embeded null and any subsequent characters are converted
 *     to blanks.
 *   * In numeric string, replaces . with D, - with N and + with P
 *     The string must start with a +, - or digit, and consist only of
 *     digits, +, - and . for this change
 *     to occur. Any number of -, +, . in a string are replaced.
 *     
 * 
 */
SASAPI void SAS_ZNAME(
    char* value_ptr  /* Pointer to 8 character name to be converted */
    );

/* 
 * Creates a valid SAS name from a root and a numeric suffix.
 *
 * The root is truncated if necessary down to a minimum of 1 character
 * in order that the root and the suffix can fit in the supplied 
 * output buffer length.
 *
 * This function is sensitive to the value of VALIDVARNAME. 
 * If VALIDVARNAME is V6, then the maximum length of name generated will
 * be 8 characters, and the resulting name will be a valid V6 name. The 
 * suffix will be truncated on the left if it is longer than 7 digits.
 * 
 * For VALIDVARNAME=V7, the maximum length of name generated will be 32
 * characters. The name is made into a valid V7 name.
 *
 * For VALIDVARNAME=ANY, the maximum length of name generated is 
 * again 32 characters.
 *
 */
SASAPI void SAS_ZNAMFIX(
    const char*  root,      /* Pointer to the root for the name */
    int          rootlen,   /* Length of the root, or -1 if null 
                               terminated */
    long         suffix,    /* Suffix to apply. */
    int          mindigits, /* Min digits to use for the suffix. */
    char*        out_name,  /* Pointer to buffer to receive resulting 
                               name */
    int          out_length /* Name of out_name buffer. If this is 
                               negative then the out_name is to be null 
                               terminated, and the buffer length is 
                               given by the absolute value of out_length
                               */
    );

/*
 * Divides a SAS name into a root and numeric suffix.
 *
 * The routine returns the number of digits in the suffix.
 * If the name does not have a numeric suffix, 0 will be returned.
 */
SASAPI int SAS_ZNAMSUF(
    const char* name,      /* Pointer to the name to divide */
    int         namelen,   /* The length of the name, -1 if null 
                              terminated */
    char*       root,      /* Pointer to buffer to receive the root 
                              portion */
    int         root_len,  /* Length of the root output field. If this 
                              is negative then the string in root will 
                              be null terminated, and the length of the 
                              field is given by the absolute value of 
                              root_len */
    long*       suffix     /* Pointer to field to receive the suffix */
    );


/*
 * Determines whether a name is a legal SAS name, performing
 * a basic transformation on it in the process.
 *
 * This routine removes leading blanks form the supplied name.
 * If the VALIDVARNAME system option is V6, then the name is upper 
 * cased.
 * The name is validated according to the current setting of 
 * VALIDVARNAME. For VALIDVARNAME=V6, a name is valid if
 *  * It start with an A-Z or underscore
 *  * Subsequent characters are A-Z, 0-9 or underscore.
 *  * is no more than 8 characters.
 * 
 * For VALIDVARNAME=V7, a name is valid if
 *  * It starts with A-Z,a-z or underscore.
 *  * Subsequent characters are A-Z, a-z, 0-9 or underscore.
 *  * is no more than 32 characters.
 *
 * For VALIDVARNAME=ANY, and name is valid if does not consist
 * of all blanks.
 *
 * The return value is:
 *  0 : successful, the name is valid.
 *  1 : The name is all blanks.
 *  2 : The name is too long
 *  3 : The first character is invalid
 *  4 : A subsequent character is invalid
 *
 */
SASAPI int SAS_ZNAMVER(
    char*    name,    /* The name to validate */
    int      length  /* The length of the name, or -1 if null 
                        terminated */
    );

/*
 * Converts an integer value into a character string.
 *
 * This function returns 0 if successful, otherwise non zero.
 * 
 */
SASAPI int SAS_ZLTOS(
    long   value,  /* The value to convert */
    char*  target, /* The target buffer */
    int    length  /* The length of the target buffer */
    );

/*
 * Scans a character string for an integer and returns its value.
 *
 * Leading blanks are skipped in the input string. 
 * Then, if issigned is non-zero a sign ('+' or '-') is allowed.
 * Then a sequence of digits is expected.
 * Any trailing characters are ignored.
 *
 * The number of characters read is returned in the chars_read field.
 * This does not include any leading space, or any trailing characters.
 *
 * If the input string does not start with a number, then a non-zero
 * value is returned.
 * If a valid string is parsed but the string is outside the range of 
 * a long integer, then a nonzero value is returned.
 */
SASAPI int SAS_ZSTOL(
    const char* str,        /* Pointer to input string */
    int         length,     /* Length of input string, -1 if null 
                               terminated */
    int         issigned,   /* 0=require unsigned, 1=allow sign */
    int*        chars_read, /* Receives the number of characters read 
                             */
    long*       result      /* Receives the result integer */
    );

/*
 * Substitutes instances of one character within a string for another.
 * The substitution is performed in place.
 */
SASAPI void SAS_ZTRANC(
    char*   str,       /* The string in which to substitute characters 
                        */
    int     length,    /* The length of the string, -1 if null 
                          terminated */
    int     tochar,    /* The new character */
    int     fromchar   /* The character to be replaced */
    );

/*
 * Converts characters in a string.
 *
 * This routine takes each character in the source string, and if
 * that character is found in the from string, it is replaced by 
 * the corresponding character in the to string. The from string
 * and the to string should be the same length. The translation
 * occurs in place.
 */
SASAPI void SAS_ZTRANS(
    char*       str,           /* The string in which to substitute 
                                  characters */
    int         length,        /* The length of str, -1 if null 
                                  terminated */
    const char* to_string,     /* The string containing the new 
                                  characters */
    const char* from_string,   /* The string containing the old 
                                  characters */ 
    int         to_from_length /* The lengths of the from and to strings
                                */
    );

/*
 * Compares two strings with the shorter one padded with blanks
 * to the length of the longer.
 * Either string may be null, in which case it is takes as being all
 * blanks.
 *
 * The return value is >0 if string1 is ordered after string2, <0 if 
 * string1 is ordered before string2 and =0 if the two strings are the 
 * same.
 */
SASAPI int SAS_ZSTRCOM(
    const char* string1,  /* First string to compare */
    int         length1,  /* Length of first string, -1 if NULL 
                             terminated */
    const char* string2,  /* Second string to compare */
    int         length2   /* Length of second string, -1 if NULL 
                             terminated */
    );

/*
 * Deletes characters from a string.
 *
 * This routine deletes any instances of a set of characters from a 
 * string and returns the new length of the string. 
 * The string to be modified can be null terminated in which case the 
 * result will be null terminated. 
 * The returned value is the number of characters in the new string. 
 * This doesn't include any trailing blanks, or the null terminator.
 */
SASAPI int SAS_ZSTRDEL(
    char*       string,      /* The string from which to delete 
                                characters */
    int         length,      /* The length of string, -1 if null 
                                terminated */
    const char* delchars,    /* The list of characters to delete. */
    int         delchars_len /* The length delchars, -1 if null 
                                terminated */
    );

/*
 * Returns the length of a string without any trailing blanks
 */
SASAPI int SAS_ZSTRIP(
    const char* string,     /* The source string (may be NULL) */
    int         length      /* The length of string, -1 if null 
                               terminated */
    );

/*
 * Removes quotes from a null terminated string
 * 
 * The out_string parameter must point to a string buffer that is at 
 * least as long as the input string. The result string will be null 
 * terminated.
 *
 * The first character in the input string is the quote character that 
 * is removed, so in fact any character can be stripped.
 *
 * Two consecutive quote characters inside the string are replaced by a 
 * single quote.
 */
SASAPI void SAS_ZSTRIPQ(
    const char* in_string,  /* Pointer to the input string */
          char* out_string  /* Pointer to output string */
    );

/*
 * Justifies a string within a field.
 *
 * The type parameter indicates the type of justification to perform. It
 * can have one of the following values:
 * 'l'  : The string is left justified in the field
 * 'r'  : The string is right justified in the field
 * 'c'  : The string is centred in the field
 * 'n'  : No justification is performed, the string is unchanged.
 *
 * The result_length field receives the length of the string from the 
 * first non-blank character to the last non-blank character.
 * This can be null if the information is not required.
 *
 * The result_start field receives the position of the first
 * nonblank character in the output string.
 * This can be null if the information is not required.
 */
SASAPI void SAS_ZSTRJLS(
    char*    string,         /* Pointer to buffer containing string to 
                                justify */
    int      length,         /* Length of string, -1 if null terminated 
                              */
    int      type,           /* type of justification, 'l', 'r', 'c', or 
                                'n' */
    int*     result_length,  /* Receives the new length of the string */
    int*     result_start    /* Receives the start position of the 
                                string */
    );

/*
 * Returns the length of a null terminated string
 */
SASAPI int SAS_ZSTRLEN(const char* string);

/*
 * Converts a string to lower case in place
 */
SASAPI void SAS_ZSTRLO(
    char*  string,  /* The string to convert */
    int    length   /* The length of the string, or -1 if null 
                       terminated */
    );

/*
 * Moves a string, blank padding or truncating it to a new length if 
 * necessary
 *
 * The target area can overlap the source string. The string is moved
 * non-destructively in that case.
 *
 */
SASAPI int SAS_ZSTRMOV(
    const char* from_string, /* Source string to move */
    int         from_length, /* Length of from string, -1 if null 
                                terminated */
    char*       to_string,   /* Pointer to target field */
    int         to_length    /* Length of target field. If this is 
                                negative the resulting string will be 
                                null terminated and the length of the 
                                target field is the absolute value of 
                                to_length */
    );

/*
 * Searches for one string within another
 *
 * The return value is the 0-based position of the search string inside 
 * the source string, or -1 if the search string is not found
 */
SASAPI int SAS_ZSTRNDX(
    const char* source_string,/* The string to search. May be null */
    int         length,       /* Length of the string, -1 if null 
                                 terminated */
    const char* search_string,/* The string to search for. May be null 
                               */
    int         search_len    /* Length of search string, -1 if null 
                                 terminated */
    );

/*
 * Returns the position of the first character in a string that is 
 * not equal to a given character. If all the characters in the string
 * are the search character, then -1 is returned.
 *
 */
SASAPI int SAS_ZSTRNOT(
    const char* source_string, /* The string to search. May be null */
    int         length,        /* Length of the string, -1 if null 
                                  terminated */
    int         check_char     /* The character to validate the string
                                  with */
    );

/* 
 * Searches for a character inside another string
 * The return value is the 0-based position of the first instance
 * of the search character within the source string, or -1 if the 
 * character is not found.
 */
SASAPI int SAS_ZSTRPOS(
    const char* source_string,  /* The string to search. May be null */
    int         length,         /* Length of the string, -1 if null 
                                   terminated */
    int         search_char     /* The character to search for */
    );


/*
 * Converts a string to upper case in place
 */
SASAPI void SAS_ZSTRUP(
    char*  string,  /* The string to convert */
    int    length   /* The length of the string, or -1 if null 
                       terminated */
    );

/*
 * Searches a string for characters that are not in a second string.
 *
 * The valid_string parameter may not be null.
 *
 * The return value is the length of the starting substring of
 * source_string made up entirely of characters in valid_string, or -1
 * if all characters in source_string are in valid_string.
 */
SASAPI int SAS_ZSTRVER(
    const char* source_string, /* The string to search. May be null */
    int         length,        /* Length of the string, -1 if null 
                                  terminated */
    const char* valid_string,  /* Characters that are valid in the 
                                  string */
    int         valid_length   /* Length of valid_string. -1 if null 
                                  terminated */
    );

/*--------------------------*/
/* Data conversion routines */
/*--------------------------*/

/* 
 * Converts a floating point value into one that can be sorted
 * 
 * This routine modifies the value in place, creating a value that 
 * can be compared easily using memcmp. This includes handling
 * SAS missing values.
 *
 * The original value can be restored using the SAS_ZRSDBL routine.
 * If the length argument is less than the minimum then no conversion 
 * occurs.
 * Lengths greater than 8 are treated as length 8.
 * This routine always returns 0.
 */
SASAPI long SAS_ZCSDBL(
    void* value,  /* Pointer to double or float to convert in place */
    int length    /* Number of bytes in the float, 2 to 8 */
    );

/*
 * Restores the correct value of a floating point value that was
 * converted for sorting by SAS_ZCSDBL
 *
 * If the length argument is less than the minimum then no conversion 
 * occurs.
 * Lengths greater than 8 are treated as length 8.
 * This routine always returns 0.
 */
SASAPI long SAS_ZRSDBL(
    void* value,  /* Pointer to double or float to restore in place */
    int length    /* Number of bytes in the float, 2 to 8 */
    );

/* 
 * Converts an unsigned integer value into one that can be sorted
 * 
 * This routine modifies the value in place, creating a value that 
 * can be compared easily using memcmp.
 *
 * The original value can be restored using the SAS_ZRSINT routine.
 * This routine always returns 0.
 * If the length is not the length of an unsigned short, int or long
 * then no conversion is done, but 0 is returned.
 */
SASAPI long SAS_ZCSINT(
    void* value,  /* Pointer to an unsigned int, short or long to 
                     convert */
    int length    /* Number of bytes in the integer */
    );

/*
 * Restores the correct value of an integer value that was
 * converted for sorting by SAS_ZCSINT
 *
 * This routine always returns 0.
 * If the length is not the length of an unsigned short, int or long
 * then no conversion is done, but 0 is returned.
 */
SASAPI long SAS_ZRSINT(
    void* value,  /* Pointer to an unsigned int, short or long to 
                     convert */
    int length    /* Number of bytes in the float, 2 to 8 */
    );


/*
 * Converts a string into transport format.
 *
 * Transport format uses ASCII. The actual transformation
 * performed is defined by the relevant trantab in the TRANTAB system 
 * option.
 *
 * The transformation performed produces one output character for each 
 * input character, so the out_string parameter must point to a buffer
 * of the same length as the input string.
 *
 * This routine always returns 0.
 * 
 */
SASAPI int SAS_ZCTCHR(
    const char*  source,    /* String to be converted */
    int          length,    /* length of string in bytes */
    char*        out_string /* pointer to destination buffer */
    );

/*
 * Convert a string from transport format to local format.
 *
 * Transport format uses ASCII. The actual transformation
 * performed is defined by the relevant trantab in the TRANTAB system 
 * option.
 *
 * The transformation performed produces one output character for each 
 * input character, so the out_string parameter must point to a buffer
 * of the same length as the input string.
 *
 * This routine always returns 0.
 */
SASAPI int SAS_ZRTCHR(
    const char*  source,    /* String to be converted */
    int          length,    /* length of string in bytes */
    char*        out_string /* pointer to destination buffer */
    );

/*
 * Convert an integer to transport format.
 * Transport format uses big endian order for integer values.
 * 
 * The output integer can be of length 2 or 4.
 *
 * The routine always returns 0
 */
SASAPI int SAS_ZCTINT(
    long source,        /* The value to convert */
    void*  out_buffer,  /* Pointer to the output buffer */
    int    out_length   /* Length of output integer, 2 or 4 */
    );

/*
 * Convert an integer from transport format to local format.
 * Transport format uses big endian order for integer values.
 * 
 * The transport format integer can be of length 2 or 4.
 * The local format integer value is returned.
 *
 */
SASAPI long SAS_ZRTINT(
    void*  source,      /* The transport format integer to convert */
    int    length       /* The length of the transport integer, 2 or 4 
                         */
    );


/*
 * Convert a double to transport format.
 * Transport format uses IBM hexadecimal floating point format.
 * 
 * The output double can be of length 2 to 8.
 *
 * The routine returns 0 if successful, or one of the following
 * values:

 */
SASAPI int SAS_ZCTDBL(
    double source,      /* The double value to convert */
    void*  out_buffer,  /* Pointer to the output buffer */
    int    out_length   /* Length of output double, 2-8 */
    );

/*
 * Convert a double from transport format to local format.
 * Transport format uses IBM hexadecimal floating point format.
 * 
 * The transport format double can be of length 2 to 8.
 * The local format double value is returned.
 *
 * If the source value is too large to be represented in local format,
 * MACBIG or -MACBIG is returned. If the number is too small to be 
 * represented accurately in local format, MACSMALL or -MACSMALL 
 * is returned.
 */
SASAPI double SAS_ZRTDBL(
    void*  source,      /* The transport format double to convert */
    int    length       /* The length of the transport double */
    );


/*--------------------------*/
/* Date time routines       */
/*--------------------------*/

/*
 * Returns the month, day and year of the current date
 *
 * This routine always returns 0
 */
SASAPI int SAS_ZDATE(
    int*   month,  /* Pointer to integer to receive month (1-12) */
    int*   day,    /* Pointer to integer to receive day of month (1-31) 
                    */
    int*   year);  /* Pointer to integer to receive current year */

/*
 * Converts a Julian date to a SAS date
 *
 * If a two digit year is specified, then the YEARCUTOFF system option
 * is used to determine the century.
 *
 * Any fractional part of the input value is ignored.
 * If the input value is missing or invalid, then 
 * missing is returned.
 *
 * The SAS date value is returned.
 */
SASAPI double SAS_ZDATJUL(
    double julian_date  /* The Julian date value */
    );

/*
 * Returns the date portion of a SAS datetime value as a 
 * SAS date.
 *
 * If the datetime argument is a missing value, missing is returned.
 * If the datetime argument represents an invalid value, then 
 * missing is returned.
 */
SASAPI double SAS_ZDATPRT(
    double datetime    /* The datetime value to return the date part of
                        */
    );

/* 
 * Returns the current date and time as a SAS datetime value
 *
 */
SASAPI double SAS_ZDATTIM();

/*
 * Converts a SAS date into a Julian date
 *
 * If the SAS date vlaue doesn't represent a legal date,
 * then missing is returned.
 */
SASAPI double SAS_ZJULDAT(
    double sas_date  /* The SAS date to convert to Julian */
    );

/*
 * Convert a year, month, day triplet to a Julian date
 *
 * If the specified year/month/day is outside the range of valid dates,
 * then the missing value is returned. If any of the arguments are
 * missing, then missing is returned.
 * Any fractional part of the arguments is ignored.
 *
 * The year may be specified as either a 2 or a 4/5 digit value.
 */
SASAPI double SAS_ZJULYMD(
    double year,    /* The year number */
    double month,   /* The month number (1-12) */
    double day      /* The day of the month */
    );

/*
 * Returns the current machine time as a SAS time value
 */
SASAPI double SAS_ZTIME();

/*
 * Returns the current date as a SAS date value
 */
SASAPI double SAS_ZTODAY();

/*
 * Converts a Julian date value into a year month and day
 *
 * If the Julain date value is invalid or missing, then the
 * year, month and day are set to missing.
 *
 * This function always returns 0.
 */
SASAPI int SAS_ZYMDJUL(
          double*   out_year,   /* Pointer to receive the year value */
          double*   out_month,  /* Pointer to receive the month value */
          double*   out_day,    /* Pointer to receive the day value */
    const double*   julian_date /* Pointer to the julian date value to 
                                   convert */
    );

/*-----------------------------*/
/* Routines for filling memory */
/*-----------------------------*/

/*
 * Fills an area of memory with a specified character
 *
 */
SASAPI void SAS_ZFILLCI(
    char   fill_char,  /* Character to use to fill */
    void*  area_ptr,   /* Pointer to area to fill */
    int    length      /* length of area to fill */
    );

/*
 * Fills an array of doubles with a specified value
 *
 */
SASAPI void SAS_ZFILLDI(
    double   value,     /* Value to use to fill the array */
    double*  array_ptr, /* Pointer to the array to fill */
    int      count      /* Number of elements in the array */
    );

/*
 * Fills memory with copies of an arbitrary object
 */
SASAPI void SAS_ZFILLOI(
    const void* fill_ptr,     /* Pointer to the object with which to 
                                 fill the area */
    int         fill_length,  /* Length of the source object */
    void*       area_ptr,     /* Pointer to the target area to fill */
    int         count         /* Number of copies of the source object 
                                 to create */
    );

/*
 * Fills an area of memory with zeros
 */
SASAPI void SAS_ZZEROI(
    void* area_ptr,  /* Pointer to the area to fill */
    int   length     /* length of the area to fill */
    );

/*------------------------------------*/
/* Routines for copying/moving memory */
/*------------------------------------*/

/*
 * Copies a block of memory from one location to another
 *
 * If the two blocks of memory overlap, the results are undefined
 *
 * To copy potentially overlapping areas use SAS_ZNDMOVI
 *
 */
SASAPI void SAS_ZMOVEI(
    const void* from,  /* Pointer to source memory block */
          void* to,    /* Pointer to target memory block */
    int         length /* Number of bytes to copy */
    );

/*
 * Moves a block of memory from one location to another,
 * allowing for overlapping areas.
 *
 * This routine, unlike the SAS_ZMOVEI routine, 
 * operates correctly when the two areas of memory overlap.
 *
 */
SASAPI void SAS_ZNDMOVI(
    const void* from,  /* Pointer to source memory block */
          void* to,    /* Pointer to target memory block */
    int         length /* Number of bytes to move */
    );


/*---------------------------------*/
/* Missing value handling routines */
/*---------------------------------*/

/*
 * Tests whether a double is a missing value
 *
 * Returns 0 if the value is non-missing, and non-zero if the value is
 * missing
 */
SASAPI int SAS_ZMISS(
    double v /* The value to test */
    );


/*
 * Tests if any elements of an array are the missing value
 *
 * Returns 0 if all of the values in the array are non-missing, 
 * and non-zero if any missing values where found.
 */
SASAPI int SAS_ZMISSN(
    const double* arr,   /* The array of values to test */
    int           length /* The number of elements in the array */
    );

/*
 * Returns a missing value.
 * The normal missing value is returned, unless the argument is 
 * 'A'-'Z', 'a'-'z' or '_', in which case the relevant missing
 * is returned.
 */
SASAPI double SAS_ZMISSV(
    int type  /* The type of missing value to return, '.', 'A'-'Z' or 
                 '_' */
    );

/*------------------------------*/
/* Routines for formatting data */
/*------------------------------*/

/*
 * Pads a short floating point number to a full double precision number 
 * This routine returns 0 if successful, otherwise:
 * WPS_E_INVALIDARG if the length field is invalid.
 */
SASAPI int SAS_ZFPAD(
    const void*  value,  /* Pointer to the source data */
    int          length, /* Length of the input field */
    double*      number  /* Resultant double precision number */
    );

/*
 * Truncates a double precision number to a float of specified length.
 * This routine returns 0 if successful, otherwise:
 * WPS_E_INVALIDARG if the length field is invalid.
 */
SASAPI int SAS_ZFTRNC(
    double       number,  /* The number to truncate */
    void*        value,   /* Pointer to the output field */
    int          length   /* Length of the output field */
    );

/* 
* Determines the format requires for printing a number with
* a given number of significant digits.
*
* The supplied number may be a missing value.
* The value 99 is returned in the digits parameter if 
* max_width is too small to print the requested number of
* significant digits. 
* One space is always allowed for the sign.
*/
SASAPI void SAS_ZPSIG(
    double    number,     /* The number that is to be printed */
    int       sigdigits,  /* The number of significant digits required 
                             */
    int       max_width,  /* The maximum field width */
    int*      width,      /* Receives the necessary format width */
    int*      digits      /* Receives the necessary number of digits */
    );

/* 
* Determines the format requires for printing two numbers so 
* that each has the given number of significant digits.
*
* Either supplied number may be a missing value.
* The value 99 is returned in the digits parameter if 
* max_width is too small to print the requested number of
* significant digits. 
* One space is always allowed for the sign.
*/
SASAPI void SAS_ZPSIG2(
    double    number1,    /* The first number that is to be printed */
    double    number2,    /* The second number that is to be printed */
    int       sigdigits,  /* The number of significant digits required 
                           */
    int       max_width,  /* The maximum field width */
    int*      width,      /* Receives the necessary format width */
    int*      digits,     /* Receives the necessary number of digits */
    double*   smalll      /* Receives the smallest number that can be 
                             printed with width and decimals and still 
                             give sigdigits number of digits */
    );

/*======================================================================
 * Miscellaneous routines
  ====================================================================*/
struct WZ_ENV {
    const char*   model_name;       /* machine model name */
    const char*   model_num;        /* machine model number */
    const char*   serial;           /* machine serial number */
    char          os_name[8];       /* operating system name */
    char          os_family[8];     /* operating system family */
    char          os_num[16];       /* operating system number */
    char          jobid[16];        /* job or process id */
    char          sup_ver_long[16]; /* WPS version number */
};

#if 0
Not currently implemented
/*
 * Returns information about the system on which WPS is running.
 */
SASAPI int SAS_ZSYINF(
    struct WZ_ENV* environment   /* Pointer to a WZ_ENV structure to 
                                    fill */
    );
#endif


/*======================================================================
   SAS documented error constants
  ====================================================================*/
#define XHENOASN 10001
#define XHENOMBR 10002

/* Return codes from function routines */
#define F_OK 0
#define F_EMISS 1
#define F_EINTE 2
#define F_EIAF 3

/*======================================================================
   WPS specific error constants
  ====================================================================*/
#define WPS_E_TOOSHORT 1
#define WPS_E_TOOBIG 2
#define WPS_E_INVALIDARG 3
#define WPS_E_NOT_A_NUMBER 4
#define WPS_E_NOMEMORY 5
#define WPS_E_UNKNOWN_MACRO_VARNAME 6
#define WPS_E_INVALID_MACRO_VARNAME 7
#define WPS_E_SYSTEM_OPTION_NOT_KNOWN 8
#define WPS_E_SYSTEM_OPTION_BAD_TYPE 9
#define WPS_E_SYSTEM_OPTION_INVALID_VALUE 10
#define WPS_E_SYSTEM_OPTION_READONLY 11

#define WPC_E_INVALID_OPENMODE 12
#define WPC_E_XOPNSTR_TYPE_UNSUPPORTED 13
#define WPC_E_CLOSE_DISPOSITION_UNSUPPORTED 14
#define WPC_E_XOINFO_LABEL_TOOLONG 15
#define WPC_E_XOINFO_LIBNAME_TOOLONG 16

#endif
