@echo off

if  not exist "..\lib" mkdir ..\lib

cl -nologo -MT -TC -O2 -c par_shapes.c
lib -nologo par_shapes.obj -out:..\lib\par_shapes.lib

del *.obj
