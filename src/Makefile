OS =$(shell uname)

ifeq ($(OS), Darwin)
all: darwin
else
all: unix
endif

unix:
	mkdir -p ../lib
	$(CC) -c -O2 -Os -fPIC par_shapes.c
	$(AR) rcs ../lib/par_shapes.a par_shapes.o
	rm *.0

darwin:
    mkdir -p ../lib/darwin
    $(CC) -arch x86_64 -c -O2 -Os -fPIC par_shapes.c -o par_shapes-x86_64.o -mmacosx-version-min=10.12
    $(CC) -arch arm64 -c -O2 -Os -fPIC par_shapes.c -o par_shapes-arm64.o -mmacosx-version-min=10.12
    lipo -create par_shapes-x86_64.o par_shapes-arm64.o -output ../lib/darwin/par_shapes.a
