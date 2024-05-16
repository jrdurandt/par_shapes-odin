OS =$(shell uname)

all: unix

unix:
	mkdir -p ../lib
	$(CC) -c -O2 -Os -fPIC par_shapes.c
	$(AR) rcs ../lib/par_shapes.a par_shapes.o

