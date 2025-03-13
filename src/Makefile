OS=$(shell uname)

ifeq ($(OS), Darwin)
all: darwin
else
all: unix
endif

unix:
	mkdir -p ../lib/linux
	$(CC) -c -O2 -Os -fPIC par_shapes.c
	$(AR) rcs ../lib/linux/libpar_shapes.a par_shapes.o
	rm *.o

darwin:
	mkdir -p ../lib/darwin
	$(CC) -arch x86_64 -c -O2 -Os -fPIC par_shapes.c -o par_shapes-x86_64.o -mmacosx-version-min=10.12
	$(CC) -arch arm64 -c -O2 -Os -fPIC par_shapes.c -o par_shapes-arm64.o -mmacosx-version-min=10.12
	lipo -create par_shapes-x86_64.o par_shapes-arm64.o -output ../lib/darwin/libpar_shapes.a
	rm *.o
