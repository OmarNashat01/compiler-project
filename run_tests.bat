@ECHO OFF
type tests\input.cpp | call run.bat > tests\output.asm
@ECHO ON
