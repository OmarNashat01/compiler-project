@ECHO OFF
del bin\*.exe

bison --yacc code\parser.y -o bin\parser.c -d
flex -obin\lexer.c code\lexer.l 
gcc bin\parser.c bin\lexer.c -o bin\compiler.exe

del bin\*.c
del bin\*.h

type tests\input.cpp | bin\compiler.exe > tests\output.asm
@ECHO ON
