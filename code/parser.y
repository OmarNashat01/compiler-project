%{
    #include <stdio.h>
	#include <string.h>	

    int yyerror(const char *s) {
        fprintf(stderr, "%s\n", s);
        return 0;
    }
    int yylex(void);
	int yylineno;
%}

%union {
    int ival;
    char *sval;
}


// keywords
%token IF ELSE FOR WHILE DO RETURN VOID BREAK CONTINUE SWITCH CASE DEFAULT CONST STATIC CLASS
 
// types
%token CHAR INT FLOAT DOUBLE LONG BOOL

// unary comparators
%token NOT

// binary comparators
%token GT LT GE LE EQ NE AND OR


// bitwise operators
// %token xor right_shift left_shift

// unary operators
%token INC DEC

// binary operators
%token PLUS MINUS MULT DIV MOD ASSIGN PLUS_ASSIGN MINUS_ASSIGN MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN


// delimiters
%token LBRACE RBRACE LBRACKET RBRACKET SEMICOLON COMMA COLON DOT QUESTION

// variable
%token VARIABLE


// literals
%token INT_LITERAL FLOAT_LITERAL STRING_LITERAL CHAR_LITERAL


// associativity rules
%left INC DEC
%left ASSIGN
%left GT LT
%left GE LE
%left EQ NE
%left AND OR NOT
%left PLUS MINUS 
%left MULT DIV MOD

%start PROGRAM

%type <ival> INT
%type <sval> STRING_LITERAL


%%
PROGRAM: STMT_LIST

STMT_LIST: STMT
    | STMT_LIST STMT

STMT: EXPR ';'
    
EXPR: EXPR PLUS EXPR
    | EXPR MINUS EXPR
    | EXPR MULT EXPR
    | EXPR DIV EXPR
    | '(' EXPR ')'
    | VARIABLE
    | INT_LITERAL
    | FLOAT_LITERAL
    | STRING_LITERAL
    | CHAR_LITERAL
    | EXPR INC
    | EXPR DEC
%%

int main(int argc, char **argv) {
    yyparse();
    return 0;
}
