=======================================================================

  Quick Start Guide for Developing WPS SDK DLLs on UNIX platforms
 
=======================================================================


1. Introduction
=======================================================================

This is a quick start guide giving basic information about how to 
develop a DLL using the WPS SDK. It is not a tutorial on the coding
required to develop WPS SDK modules, or a user guide to the WPS SDK 
API. There is reference documentation for the WPS SDK API included
seperately in the WPS product.

The WPS SDK supports developing DLLs that contain DATA step 
functions and CALL routines, formats, and informats. Informats, formats, 
functions and call routines are collectively known as IFFCs. 
Currently the WPS SDK cannot be used to develop PROCs or library engines.

It is the intention of the WPS SDK that it be source code compatible
with equivalent modules developed for use with the SAS WPS SDK product.


2. Supported Development Environments
=======================================================================
WPS SDK DLLs can be developed in either C or C++.
Currently the only supported compiler is GCC version 4.3.2, though it 
is possible that other versions of GCC and other compilers will also 
work. No specific development environment is necessary. If using GCC 
then any development environment based on the GCC toolchain can be used,
such as Eclipse CDT, Bloodshed Dev-C++, Emacs or Vi can be used.


3. Development Considerations
=======================================================================
DLL Naming Conventions
----------------------
There are strict naming conventions for DLLs written using the WPS SDK
depending on the contents of the DLL. The name of the IFFC determines 
the name of the DLL in which the implementation must be found. The 
required DLL name is constructed using a three letter prefix determined
by the contents of the DLL followed by the common five letter prefix 
of all the IFFCs contained in the module. 

The three letter prefix is determined by the contents of the DLL:
  uwf  for DLLs that contain formats
  uwi  for DLLs that contain informats
  uwu  for DLLs that contain functions and call routines. 
  
These rules imply that one single WPS SDK DLL can only contain DATA step 
functions and CALL routines, or formats or informats. Also IFFCs must be 
grouped together into DLLs based on the first five letters of their name. 
This also implies that there is a potential for conflict amongst WPS SDK
DLL names provided from different sources, so it may be necessary to name
IFFCs written using the WPS SDK with a common 5 letter prefix in order
that they can all be implemented in a single DLL, or to avoid namespace
collisions.


4. Build Requirements
=======================================================================

In order to successfully build a WPS SDK DLL using GCC the following
steps must be taken. 

  1. In order to compile the code the tolkit/include directory needs
     to be included in the include path, either by way of the INCLUDE
	 environment varialbe or using the -I compiler command line option.
	 
  2. The output file name from the link step must conform to the correct
     naming conventions for WPS SDK DLLs. The correct name must be 
	 specified using the -o linker command line option.
	 
  3. The link step needs to include references to the static library
     WPS SDK/WPS SDK.a and the object WPS SDK/iffcmain.o.
	 The WPS SDK.a file contains the stub implementations of all of the 
	 SAS_ routines that are defined in the uwproc.h header file.
	 The iffcmain.o object file contains the required implementation 
	 of the main entry point of a WPS SDK DLL.
	 
See the makefiles provided with the WPS SDK samples for a complete 
example of the options necessary to build a WPS SDK DLL.

     
5. Debugging Considerations
=======================================================================
It is possible to use gdb (or a suitable gdb front-end) to step through 
the implementation of your informat, format, function or call routine 
in order to resolve problems. In order to this, the DLL must be compiled 
with the relevant options to enable the inclusion of debug information 
(i.e the -g option should be specified on compile and link steps).


WPS SDK Trace Facility
--------------------------
As well as attaching a debugger to the process and stepping through code,
there is an alternative method of debugging WPS SDK modules using the WPS
SDK trace facility. This is initiated by setting the DEBUG system option
to the value

  TLKTDBG=n

where n is a number between 1 and 3. This can be done using the OPTIONS 
statement as follows:

  OPTIONS DEBUG="TLKTDBG=3";

Trace level 0 produces no output.
Trace level 1 traces the entry and exit to all of the WPS SDK API functions
(those functions defined in uwproc.h), except the FMTxxx routines, FNCxxx 
routines and the SAS_XPSLOG, SAS_XPSPRN and SAS_XPS routines.
Trace level 2 traces the arguments passed to the WPS SDK API functions
Trace level 3 additional dereferences any pointer values on output from the 
API functions.

Setting TLKTDBG to a higher value also causes output from the lower levels 
to be produced, so setting it to the value 3 will produce all available 
trace output.

Note that the TLKTDBG value needs to be set at the start of a step boundary
to have any effect during that step. You cannot, for example, use the 
WPS SDK API functions to turn tracing on part way through a DATA step 
if it wasn't on when the step started.
  

6. Examples
=======================================================================
The WPS SDK/samples directory has a Visual Studio solution file containing
three projects, one containing some sample formats, one containing some
sample informats and one containing some sample DATA step functions and
CALL routines. 

The examples are documented and show the basics necessary for writing
functions, formats and informats using the WPS SDK.