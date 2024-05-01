%{
    #include <stdio.h>
	#include <string.h>	

    int yyerror(const char *s) {
        fprintf(stdout, "%s\n", s);
        return 0;
    }
    int yylex(void);
	int yylineno = 1;
%}

%union {
    int ival;
    int bval;
    int opnum;
    float fval;
    char *sval;
    char *cval;
	char *id ;                    	/* IDENTIFIER Value */
}


// keywords
%token IF ELSE FOR WHILE DO RETURN VOID BREAK CONTINUE SWITCH CASE DEFAULT CONST STATIC CLASS
 
// types
%token CHAR INT FLOAT DOUBLE LONG BOOL

// unary comparators
%token NOT

// binary comparators
%token <opnum> LOGICAL_OP


// bitwise operators
%token <opnum> BITWISE_OP

// unary operators
%token INC DEC

// binary operators
%token <opnum> MATH_OP

// assignment operators
%token <opnum> ASSIGN_OP ASSIGN


// delimiters
%token LBRACE RBRACE LBRACKET RBRACKET SEMICOLON COMMA COLON DOT QUESTION

// variable
%token <id> VARIABLE


// literals
%token <ival> INT_LITERAL
%token <bval> BOOL_LITERAL
%token <fval> FLOAT_LITERAL
%token <sval> STRING_LITERAL
%token <cval> CHAR_LITERAL


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

%%

PROGRAM: STMT_LIST
// - [ ] Block structure.
STMT_LIST: BLOCK STMT_LIST_EPS
    | STMT_LIST BLOCK
    | STMT
    | STMT_LIST STMT
  
BLOCK: '{' STMT_LIST '}'

STMT_LIST_EPS: STMT_LIST | 

STMT_LIST: error ';'                                      { fprintf(stdout, "Syntax error in line: %d\n", yylineno); }
    | error '}'                                           { fprintf(stdout, "Syntax error in line: %d\n", yylineno); }

STMT: NON_SCOPED_STMT ';'
    | SCOPED_STMT
// - [ ] Variables and Constants declaration.
NON_SCOPED_STMT: DATA_TYPE VARIABLE                       { fprintf(stdout, "Variable declaration\n"); }
    | DATA_TYPE VARIABLE ASSIGN EXPR                      { fprintf(stdout, "Variable declaration with assignment\n"); }
    | CONST DATA_TYPE VARIABLE ASSIGN EXPR                { fprintf(stdout, "Constant declaration with assignment\n"); }
    | BREAK

// - [ ] Assign stataments.
NON_SCOPED_STMT: VARIABLE ASSIGN_OP EXPR                  { fprintf(stdout, "(%s) statement\n", $1); }
    | VARIABLE ASSIGN EXPR                                { fprintf(stdout, "Assignment statement\n"); }

// - [ ] Mathematical and logical expressions.
NON_SCOPED_STMT: EXPR

EXPR: VARIABLE INC                            { fprintf(stdout, "%s INC\n", $1); }
    | VARIABLE DEC                            { fprintf(stdout, "Postfix DEC--\n"); }

    | EXPR MATH_OP EXPR                       { fprintf(stdout, "EXPR (%d) EXPR \n", $2); }
    | EXPR BITWISE_OP EXPR                    { fprintf(stdout, "EXPR (%d) EXPR\n", $2); }
    | BOOL_EXPR                               { fprintf(stdout, "BOOL_EXPR \n"); }
    | '(' EXPR ')'                            { fprintf(stdout, "(EXPR)\n"); }
    | VARIABLE                                { fprintf(stdout, "VARIABLE\n"); }
    | DATA_LITERALS                           { fprintf(stdout, "DATA_LITERALS\n"); }

    | INC VARIABLE                            { fprintf(stdout, "Prefix INC\n"); }
    | DEC VARIABLE                            { fprintf(stdout, "Prefix DEC\n"); }

BOOL_EXPR: BOOL_LITERAL                       { fprintf(stdout, "BOOL_LITERAL\n"); }
    | '(' BOOL_EXPR ')'                       { fprintf(stdout, "(BOOL_EXPR)\n"); }
    | EXPR LOGICAL_OP EXPR                    { fprintf(stdout, "EXPR (%d) EXPR\n", $2); }

//- [ ] If-then-else statement, while loops, repeat-until loops, for loops, switch statement.
SCOPED_STMT: IF '(' BOOL_EXPR ')' BLOCK                                 { fprintf(stdout, "IF statement\n"); }
    | IF '(' BOOL_EXPR ')' BLOCK ELSE BLOCK                             { fprintf(stdout, "IF-ELSE statement\n"); }
    | WHILE '(' BOOL_EXPR ')' BLOCK                                     { fprintf(stdout, "WHILE statement\n"); }
    | DO BLOCK WHILE '(' BOOL_EXPR ')' ';'                              { fprintf(stdout, "DO-WHILE statement\n"); }
    | FOR '(' STMT ';' BOOL_EXPR ';' STMT ')' BLOCK                     { fprintf(stdout, "FOR loop statement\n"); }
    | SWITCH '(' VARIABLE ')' '{' CASES '}'                             { fprintf(stdout, "SWITCH statement\n"); }

CASES: CASE_STMT
    | CASE_STMT CASES

CASE_STMT: DEFAULT ':' BLOCK
    | CASE DATA_LITERALS ':' BLOCK

// - [ ] Functions.
SCOPED_STMT: FUNCTION STMT_LIST_EPS 

FUNCTION: DATA_TYPE VARIABLE '(' PARAMS ')' '{' STMT_LIST_EPS RETURN EXPR ';' '}'       { fprintf(stdout, "Function declaration\n"); }

EXPR: VARIABLE '(' PASSED_PARAMS ')'                                                           { fprintf(stdout, "Function call\n"); }

PASSED_PARAMS: EXPR
    | PASSED_PARAMS ',' EXPR

PARAMS: DATA_TYPE VARIABLE
    | PARAMS ',' DATA_TYPE VARIABLE | 

// MATH_OP: PLUS
//     | MINUS
//     | MULT
//     | DIV
//     | MOD

// BITWISE_OP: AND_BITWISE
//     | OR_BITWISE
//     | XOR_BITWISE
//     | NOT_BITWISE
//     | RIGHT_SHIFT
//     | LEFT_SHIFT

// LOGICAL_OP: AND
//     | OR
//     | NOT
//     | GT
//     | LT
//     | GE
//     | LE
//     | EQ
//     | NE


DATA_LITERALS: INT_LITERAL                  { fprintf(stdout, "INT_LITERAL\n"); }
    | FLOAT_LITERAL                         { fprintf(stdout, "FLOAT_LITERAL\n"); }
    | STRING_LITERAL                        { fprintf(stdout, "STRING_LITERAL\n"); }
    | CHAR_LITERAL                          { fprintf(stdout, "CHAR_LITERAL\n"); }
    | BOOL_LITERAL                          { fprintf(stdout, "BOOL_LITERAL\n"); }

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
