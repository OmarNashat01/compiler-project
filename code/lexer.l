%{
    #include "parser.h"
    #include <stdlib.h>
    #include <stdio.h>
    #include<string.h>
    int yyerror(const char *s);
    extern int yylineno;
%}

%%

    /* Keywords */
"if"                            { return IF;        }
"else"                          { return ELSE;      }
"for"                           { return FOR;       }
"while"                         { return WHILE;     }
"do"                            { return DO;        }
"return"                        { return RETURN;    }
"void"                          { return VOID;      }
"break"                         { return BREAK;     }
"continue"                      { return CONTINUE;  }
"switch"                        { return SWITCH;    }
"case"                          { return CASE;      }
"default"                       { return DEFAULT;   }
"const"                         { return CONST;     }
"static"                        { return STATIC;    }
"class"                         { return CLASS;     }

"true"                          { yylval.bval = 1; return BOOL_LITERAL; }
"false"                         { yylval.bval = 0; return BOOL_LITERAL; }

    /* Types */
"char"	                        { return CHAR;      }
"int"	                        { return INT;       }
"float"	                        { return FLOAT;     }
"bool"                          { return BOOL;      }

    /* unary comparators */
"!"                             { return NOT;       }

    /* binary comparators */
">"                             { yylval.opnum= 0; return LOGICAL_OP; }
"<"                             { yylval.opnum= 1; return LOGICAL_OP; }
">="                            { yylval.opnum= 2; return LOGICAL_OP; } 
"<="                            { yylval.opnum= 3; return LOGICAL_OP; }
"=="                            { yylval.opnum= 4; return LOGICAL_OP; }
"!="                            { yylval.opnum= 5; return LOGICAL_OP; }
"&&"                            { yylval.opnum= 6; return LOGICAL_OP; }
"||"                            { yylval.opnum= 7; return LOGICAL_OP; }

    /* Bitwise Operators */
"&"                             { yylval.opnum= 8; return BITWISE_OP; }
"|"                             { yylval.opnum= 9; return BITWISE_OP; }
"^"                             { yylval.opnum= 10; return BITWISE_OP; }
"~"                             { yylval.opnum= 11; return BITWISE_OP; }
">>"                            { yylval.opnum= 12; return BITWISE_OP; }
"<<"                            { yylval.opnum= 13; return BITWISE_OP; }

    /* unary operators */
"++"                            { return INC; } /*op = 25*/
"--"                            { return DEC; } /*op = 26*/

    /* binary Operators */
"+"                             { yylval.opnum= 14; return MATH_OP; }
"-"                             { yylval.opnum= 15; return MATH_OP; }
"*"                             { yylval.opnum= 16; return MATH_OP; }
"/"                             { yylval.opnum= 17; return MATH_OP; }
"%"                             { yylval.opnum= 18; return MATH_OP; }

    /* Assignment Operators */
"="                             { yylval.opnum= 19; return ASSIGN; }
"+="                            { yylval.opnum= 20; return ASSIGN_OP; }
"-="                            { yylval.opnum= 21; return ASSIGN_OP; }
"*="                            { yylval.opnum= 22; return ASSIGN_OP; }
"/="                            { yylval.opnum= 23; return ASSIGN_OP; }
"%="                            { yylval.opnum= 24; return ASSIGN_OP; }


    /* Brackets */
[(){}\[\]]                      { return yytext[0]; }

    /* Delimiters */
[;\.,\?:]                       { return yytext[0]; }

    /* Variable */
[a-zA-z][_a-zA-Z0-9]*           { yylval.id = strdup(yytext); return VARIABLE;} 


    /* literals */
0|([1-9][0-9]*)                 { yylval.sval = strdup(yytext); return INT_LITERAL; }
[0-9]+\.[0-9]+                  { yylval.sval = strdup(yytext); return FLOAT_LITERAL; }

    /* [0-9]+[eE][+-]?[0-9]+           { return EXPONENT_LITERAL; } */

    /* \"[^\"]*\"                      { yylval.sval = strdup(yytext); return STRING_LITERAL; } */
\'[^\']\'                       { yylval.sval = strdup(yytext); return CHAR_LITERAL; }

    /* Comments */
"//".*                          {;}
"/*"[\s\S]*"*/"                 {;}

    /* Whitespace */
[ \t]                           {;}
\n                              { yylineno++; }

    /* Syntax Error */
.                               yyerror("Unknown character");
%%

int yywrap(void) {
    return 1;
}
