@echo off

if  not exist "..\lib\windows" mkdir ..\lib\windows

cl -nologo -MT -TC -O2 -c par_shapes.c
lib -nologo par_shapes.obj -out:..\lib\windows\par_shapes.lib

del *.obj
