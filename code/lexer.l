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
">"                             { yylval.opnum = 1; return LOGICAL_OP; }
"<"                             { yylval.opnum = 1; return LOGICAL_OP; }
">="                            { yylval.opnum = 1; return LOGICAL_OP; } 
"<="                            { yylval.opnum = 1; return LOGICAL_OP; }
"=="                            { yylval.opnum = 1; return LOGICAL_OP; }
"!="                            { yylval.opnum = 1; return LOGICAL_OP; }
"&&"                            { yylval.opnum = 1; return LOGICAL_OP; }
"||"                            { yylval.opnum = 1; return LOGICAL_OP; }

    /* Bitwise Operators */
"&"                             { yylval.opnum = 0; return BITWISE_OP; }
"|"                             { yylval.opnum = 1; return BITWISE_OP; }
"^"                             { yylval.opnum = 2; return BITWISE_OP; }
"~"                             { yylval.opnum = 3; return BITWISE_OP; }
">>"                            { yylval.opnum = 4; return BITWISE_OP; }
"<<"                            { yylval.opnum = 5; return BITWISE_OP; }

    /* unary operators */
"++"                            { return INC;       }
"--"                            { return DEC;       }

    /* binary Operators */
"+"                             { yylval.opnum = 6; return MATH_OP; }
"-"                             { yylval.opnum = 7; return MATH_OP; }
"*"                             { yylval.opnum = 8; return MATH_OP; }
"/"                             { yylval.opnum = 9; return MATH_OP; }
"%"                             { yylval.opnum = 10; return MATH_OP; }

    /* Assignment Operators */
"="                             { yylval.opnum = 11; return ASSIGN; }
"+="                            { yylval.opnum = 11; return ASSIGN_OP; }
"-="                            { yylval.opnum = 11; return ASSIGN_OP; }
"*="                            { yylval.opnum = 11; return ASSIGN_OP; }
"/="                            { yylval.opnum = 11; return ASSIGN_OP; }
"%="                            { yylval.opnum = 11; return ASSIGN_OP; }


    /* Brackets */
[(){}\[\]]                      { return yytext[0]; }

    /* Delimiters */
[;\.,\?:]                       { return yytext[0]; }

    /* Variable */
[a-zA-z][_a-zA-Z0-9]*           { yylval.id = strdup(yytext); return VARIABLE;} 


    /* literals */
0|([1-9][0-9]*)                 { yylval.ival = atoi(yytext); return INT_LITERAL; }
[0-9]+\.[0-9]+                  { yylval.fval = atof(yytext); return FLOAT_LITERAL; }

    /* [0-9]+[eE][+-]?[0-9]+           { return EXPONENT_LITERAL; } */

\"[^\"]*\"                      { yylval.sval = strdup(yytext); return STRING_LITERAL; }
\'[^\']\'                       { yylval.cval = strdup(yytext); return CHAR_LITERAL; }

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
