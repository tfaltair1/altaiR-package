
all : libuwusdkxm.dylib libuwisdkxm.dylib libuwfsdkxm.dylib
.DEFAULT_GOAL := all
.PHONY: all

%.o:%.c
	gcc -fPIC -m64 -c -o $@ -I ../include $^

libuwusdkxm.dylib : funcc.o
	gcc -o $@ -shared -ldl -m64 $^ ../lib/iffcmain.o ../lib/sdk.a

libuwisdkxm.dylib : infmtc.o
	gcc -o $@ -shared -ldl -m64 $^ ../lib/iffcmain.o ../lib/sdk.a

libuwfsdkxm.dylib : fmtc.o
	gcc -o $@ -shared -ldl -m64 $^ ../lib/iffcmain.o ../lib/sdk.a

