%{
    #include <stdio.h>
	#include <string.h>	

    int yyerror(const char *s) {
        // fprintf(stdout, "%s\n", s);
        return 0;
    }
    int yylex(void);
	int yylineno = 1;
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
NON_SCOPED_STMT: VARIABLE ASSIGN_OP EXPR                  { fprintf(stdout, "Assignment statement\n"); }

// - [ ] Mathematical and logical expressions.
NON_SCOPED_STMT: EXPR

EXPR: VARIABLE INC                            { fprintf(stdout, "Postfix INC\n"); }
    | VARIABLE DEC                            { fprintf(stdout, "Postfix DEC--\n"); }

    | EXPR MATH_OP EXPR                       // { fprintf(stdout, "EXPR (MATH OP) EXPR \n"); }
    | EXPR BITWISE_OP EXPR                    // { fprintf(stdout, "EXPR (BITWISE OP) EXPR\n"); }
    | BOOL_EXPR                               // { fprintf(stdout, "BOOL_EXPR \n"); }
    | '(' EXPR ')'                            // { fprintf(stdout, "(EXPR)\n"); }
    | VARIABLE                                // { fprintf(stdout, "VARIABLE\n"); }
    | DATA_LITERALS                           // { fprintf(stdout, "DATA_LITERALS\n"); }

    | INC VARIABLE                            { fprintf(stdout, "Prefix INC\n"); }
    | DEC VARIABLE                            { fprintf(stdout, "Prefix DEC\n"); }

BOOL_EXPR: BOOL_LITERAL                       { fprintf(stdout, "BOOL_LITERAL\n"); }
    | '(' BOOL_EXPR ')'                       { fprintf(stdout, "(BOOL_EXPR)\n"); }
    | EXPR LOGICAL_OP EXPR                    { fprintf(stdout, "EXPR (LOGICAL OP) EXPR\n"); }

//- [ ] If-then-else statement, while loops, repeat-until loops, for loops, switch statement.
SCOPED_STMT: IF '(' BOOL_EXPR ')' BLOCK                                 { fprintf(stdout, "IF statement\n"); }
    | IF '(' BOOL_EXPR ')' BLOCK ELSE BLOCK                 { fprintf(stdout, "IF-ELSE statement\n"); }
    | WHILE '(' BOOL_EXPR ')' BLOCK                                     { fprintf(stdout, "WHILE statement\n"); }
    | DO BLOCK WHILE '(' BOOL_EXPR ')' ';'                              { fprintf(stdout, "DO-WHILE statement\n"); }
    | FOR '(' STMT ';' BOOL_EXPR ';' STMT ')' BLOCK                     { fprintf(stdout, "FOR loop statement\n"); }
    | SWITCH '(' VARIABLE ')' '{' CASES '}'                                         { fprintf(stdout, "SWITCH statement\n"); }

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
