%{
    #include "parser.h"
    #include <string.h>
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


    /* Types */
"char"	                        { return CHAR;      }
"int"	                        { return INT;       }
"float"	                        { return FLOAT;     }
"double"	                    { return DOUBLE;    }
"long"                          { return LONG;      }
"bool"                          { return BOOL;      }

    /* unary comparators */
"!"                             { return NOT;       }

    /* binary comparators */
">"                             { return GT;        }
"<"                             { return LT;        }
">="                            { return GE;        } 
"<="                            { return LE;        }
"=="                            { return EQ;        }
"!="                            { return NE;        }
"&&"                            { return AND;       }
"||"                            { return OR;        }

    /* Bitwise Operators */
"&"                             { return AND_BITWISE; }
"|"                             { return OR_BITWISE; }
"^"                             { return XOR_BITWISE; }
"~"                             { return NOT_BITWISE; }
">>"                            { return RIGHT_SHIFT; }
"<<"                            { return LEFT_SHIFT; }

    /* unary operators */
"++"                            { return INC;       }
"--"                            { return DEC;       }

    /* binary Operators */
"+"                             { return PLUS; }
"-"                             { return MINUS; }
"*"                             { return MULT; }
"/"                             { return DIV; }
"%"                             { return MOD; }
"="                             { return ASSIGN; }
"+="                            { return PLUS_ASSIGN; }
"-="                            { return MINUS_ASSIGN; }
"*="                            { return MULT_ASSIGN; }
"/="                            { return DIV_ASSIGN; }
"%="                            { return MOD_ASSIGN; }


    /* Brackets */
[(){}\[\]]                      { return yytext[0]; }

    /* Delimiters */
[;\.,\?:]                       { return yytext[0]; }

    /* Variable */
[a-zA-z][\w]*                   { return VARIABLE;} 


    /* literals */
0|([1-9][0-9]*)                 { return INT_LITERAL; }
[0-9]+\.[0-9]+                  { return FLOAT_LITERAL; }
"true"                          { return BOOL_LITERAL; }
"false"                         { return BOOL_LITERAL; }

    /* [0-9]+[eE][+-]?[0-9]+           { return EXPONENT_LITERAL; } */

\"[^\"]*\"                      { return STRING_LITERAL; }
\'[^\']\'                       { return CHAR_LITERAL; }

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
