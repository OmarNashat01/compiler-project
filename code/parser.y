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
%token AND_BITWISE OR_BITWISE XOR_BITWISE NOT_BITWISE RIGHT_SHIFT LEFT_SHIFT

// unary operators
%token INC DEC

// binary operators
%token PLUS MINUS MULT DIV MOD ASSIGN PLUS_ASSIGN MINUS_ASSIGN MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN


// delimiters
%token LBRACE RBRACE LBRACKET RBRACKET SEMICOLON COMMA COLON DOT QUESTION

// variable
%token VARIABLE


// literals
%token INT_LITERAL FLOAT_LITERAL STRING_LITERAL CHAR_LITERAL BOOL_LITERAL


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
// - [ ] Block structure.
STMT_LIST: '{' STMT_LIST '}' STMT_LIST_EPS
    | STMT_LIST '{' STMT_LIST '}'
    | STMT ';'
    | STMT_LIST STMT ';'
  
STMT_LIST_EPS: STMT_LIST | 

// STMT: error { yyerrok;}

// - [ ] Variables and Constants declaration.
STMT: DATA_TYPE VARIABLE
    | DATA_TYPE VARIABLE ASSIGN EXPR
    | CONST DATA_TYPE VARIABLE ASSIGN EXPR
    | BREAK

// - [ ] Assign stataments.
STMT: VARIABLE ASSIGN_OP EXPR
    | VARIABLE INC
    | VARIABLE DEC


// - [ ] Mathematical and logical expressions.
STMT: EXPR
EXPR: EXPR MATH_OP EXPR
    | EXPR BITWISE_OP EXPR
    | BOOL_EXPR
    | '(' EXPR ')'
    | VARIABLE
    | VARIABLE INC
    | VARIABLE DEC
    | DATA_LITERALS

BOOL_EXPR: BOOL_LITERAL
    | '(' BOOL_EXPR ')'
    | EXPR LOGICAL_OP EXPR

//- [ ] If-then-else statement, while loops, repeat-until loops, for loops, switch statement.
STMT: IF '(' BOOL_EXPR ')' '{' STMT_LIST '}'
    | IF '(' BOOL_EXPR ')' '{' STMT_LIST '}' ELSE '{' STMT_LIST '}'
    | WHILE '(' BOOL_EXPR ')' '{' STMT_LIST '}'
    | DO '{' STMT_LIST '}' WHILE '(' BOOL_EXPR ')' ';'
    | FOR '(' STMT ';' BOOL_EXPR ';' STMT ')' '{' STMT_LIST '}'
    | SWITCH '(' VARIABLE ')' '{' CASES '}'

CASES: CASE_STMT
     | CASE_STMT CASES

CASE_STMT: DEFAULT ':' '{' STMT_LIST '}'
    | CASE DATA_LITERALS ':' '{' STMT_LIST '}'

// - [ ] Functions.
STMT: DATA_TYPE VARIABLE '(' PARAMS ')' '{' STMT_LIST RETURN EXPR ';' '}' STMT_LIST_EPS

PARAMS: DATA_TYPE VARIABLE
    | PARAMS ',' DATA_TYPE VARIABLE | 

MATH_OP: PLUS
    | MINUS
    | MULT
    | DIV
    | MOD

BITWISE_OP: AND_BITWISE
    | OR_BITWISE
    | XOR_BITWISE
    | NOT_BITWISE
    | RIGHT_SHIFT
    | LEFT_SHIFT

LOGICAL_OP: AND
    | OR
    | NOT
    | GT
    | LT
    | GE
    | LE
    | EQ
    | NE

ASSIGN_OP: ASSIGN
    | PLUS_ASSIGN
    | MINUS_ASSIGN
    | MULT_ASSIGN
    | DIV_ASSIGN
    | MOD_ASSIGN

DATA_LITERALS: INT_LITERAL
    | FLOAT_LITERAL
    | STRING_LITERAL
    | CHAR_LITERAL
    | BOOL_LITERAL

DATA_TYPE: INT
    | FLOAT
    | DOUBLE
    | LONG
    | BOOL
    | CHAR

%%

int main(int argc, char **argv) {
    yyparse();
    return 0;
}
