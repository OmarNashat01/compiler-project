@ECHO OFF
call build.bat
type tests\input.cpp | call code\build\c_compiler.exe > tests\output.asm
@ECHO ON
