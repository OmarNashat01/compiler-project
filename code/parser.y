%{
    #include <stdio.h>
	#include <string.h>	
    #include "operation-table/operationTable.h"
    #include "symbol-table/symbolTable.h"


    int yyerror(const char *s) {
        fprintf(stdout, "%s\n", s);
        return 0;
    }
    int yylex(void);
	int yylineno = 1;
    int scopeNum = 0;

    // function variables
    int argNum = 0;
    int argTypes[20];

    // operation table
    int tempCount = 0;
    char *tempVars[16] = {"t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9", "t10", "t11", "t12", "t13", "t14", "t15", "t16"};

    #define IS_CONST 1
    #define IS_FUNC 1
    #define IS_SET 1

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
%token CHAR INT FLOAT BOOL

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


// Type of data
%type <ival> DATA_TYPE
%type <sval> EXPR BOOL_EXPR DATA_LITERALS


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


PROGRAM: STMT_LIST                                       { fprintf(stdout, "============END OF PROGRAM===========\n"); }
// - [ ] Block structure.
STMT_LIST: BLOCK STMT_LIST_EPS
    | STMT_LIST BLOCK
    | STMT
    | STMT_LIST STMT
  
BLOCK: OPENSCOPE STMT_LIST CLOSESCOPE

STMT_LIST_EPS: STMT_LIST | 

STMT_LIST: error ';'                                      { fprintf(stdout, "Syntax error in line: %d\n", yylineno); }
    | error CLOSESCOPE                                           { fprintf(stdout, "Syntax error in line: %d\n", yylineno); }


STMT: NON_SCOPED_STMT ';'
    | SCOPED_STMT
// - [ ] Variables and Constants declaration.
NON_SCOPED_STMT: DATA_TYPE VARIABLE                       { 
            fprintf(stdout, "Variable declaration\n");
            setSymbol($1, !IS_CONST, !IS_FUNC, !IS_SET, $2, scopeNum, yylineno);
        }
    | DATA_TYPE VARIABLE ASSIGN EXPR                      { 
            fprintf(stdout, "Variable declaration with assignment\n", $1);
            setSymbol($1, !IS_CONST, !IS_FUNC, IS_SET, $2, scopeNum, yylineno);
        }
    | CONST DATA_TYPE VARIABLE ASSIGN EXPR                { 
            fprintf(stdout, "Constant declaration with assignment\n");
            setSymbol($2, IS_CONST, !IS_FUNC, IS_SET, $3, scopeNum, yylineno);
        }
    | BREAK

// - [ ] Assign stataments.
NON_SCOPED_STMT: VARIABLE ASSIGN_OP EXPR                  { fprintf(stdout, "(%s) statement\n", $1); }
    | VARIABLE ASSIGN EXPR                                { fprintf(stdout, "Assignment statement\n"); }

// - [ ] Mathematical and logical expressions.
NON_SCOPED_STMT: EXPR

EXPR: VARIABLE INC                            { 
            fprintf(stdout, "%s INC\n", $1);
            setQuad(25, $1, NULL, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | VARIABLE DEC                            {
            fprintf(stdout, "%s DEC\n", $1);
            setQuad(26, $1, NULL, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }

    | EXPR MATH_OP EXPR                       { 
            fprintf(stdout, "EXPR (%d) EXPR \n", $2); 
            setQuad($2, $1, $3, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | EXPR BITWISE_OP EXPR                    { 
            fprintf(stdout, "EXPR (%d) EXPR\n", $2);
            setQuad($2, $1, $3, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | BOOL_EXPR                               { fprintf(stdout, "BOOL_EXPR \n"); $$ = $1;}
    | '(' EXPR ')'                            { fprintf(stdout, "(EXPR)\n"); $$ = $2;}
    | VARIABLE                                { fprintf(stdout, "VARIABLE\n"); $$ = $1;}
    | DATA_LITERALS                           { fprintf(stdout, "DATA_LITERALS\n"); $$ = $1;}

    // | INC VARIABLE                            { fprintf(stdout, "Prefix INC\n"); }
    // | DEC VARIABLE                            { fprintf(stdout, "Prefix DEC\n"); }

BOOL_EXPR: BOOL_LITERAL                       { 
            fprintf(stdout, "BOOL_LITERAL\n");
            setQuad(19, NULL, $1, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | '(' BOOL_EXPR ')'                       { fprintf(stdout, "(BOOL_EXPR)\n"); $$ = $2; }
    | EXPR LOGICAL_OP EXPR                    { 
            fprintf(stdout, "EXPR (%d) EXPR\n", $2);
            setQuad($2, $1, $3, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }

//- [ ] If-then-else statement, while loops, repeat-until loops, for loops, switch statement.
SCOPED_STMT: IF '(' BOOL_EXPR ')' BLOCK                                 { fprintf(stdout, "IF statement\n"); }
    | IF '(' BOOL_EXPR ')' BLOCK ELSE BLOCK                             { fprintf(stdout, "IF-ELSE statement\n"); }
    | WHILE '(' BOOL_EXPR ')' BLOCK                                     { fprintf(stdout, "WHILE statement\n"); }
    | DO BLOCK WHILE '(' BOOL_EXPR ')' ';'                              { fprintf(stdout, "DO-WHILE statement\n"); }
    | FOR '(' STMT ';' BOOL_EXPR ';' STMT ')' BLOCK                     { fprintf(stdout, "FOR loop statement\n"); }
    | SWITCH '(' VARIABLE ')' OPENSCOPE CASES CLOSESCOPE                             { fprintf(stdout, "SWITCH statement\n"); }

CASES: CASE_STMT
    | CASE_STMT CASES

CASE_STMT: DEFAULT ':' BLOCK
    | CASE DATA_LITERALS ':' BLOCK

// - [ ] Functions.
SCOPED_STMT: FUNCTION STMT_LIST_EPS 

FUNCTION: DATA_TYPE VARIABLE '(' PARAMS ')' OPENSCOPE STMT_LIST_EPS RETURN EXPR ';' CLOSESCOPE       { 
        fprintf(stdout, "Function declaration\n"); 
        setSymbol($1, !IS_CONST, IS_FUNC, !IS_SET, $2, scopeNum, yylineno);
        setFunctionSymbol(argNum, argTypes);
        argNum = 0;
    }

EXPR: VARIABLE '(' PASSED_PARAMS ')'        { fprintf(stdout, "Function call\n"); }

PASSED_PARAMS: EXPR
    | PASSED_PARAMS ',' EXPR

PARAMS: DATA_TYPE VARIABLE                  { 
            argTypes[argNum++] = $1;
            setSymbol($1, !IS_CONST, !IS_FUNC, IS_SET, $2, scopeNum + 1, yylineno);
        }
    | PARAMS ',' DATA_TYPE VARIABLE         { 
            argTypes[argNum++] = $3;
            setSymbol($3, !IS_CONST, !IS_FUNC, IS_SET, $4, scopeNum + 1, yylineno);
        }
    |



<<<<<<< HEAD
DATA_LITERALS: INT_LITERAL                  {
            fprintf(stdout, "INT_LITERAL\n");
            setLiteralQuad(0, &$1, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | FLOAT_LITERAL                         {
            fprintf(stdout, "FLOAT_LITERAL\n");
            setLiteralQuad(1, &$1, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | CHAR_LITERAL                          {
            fprintf(stdout, "CHAR_LITERAL\n");
            setLiteralQuad(2, &$1, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | BOOL_LITERAL                          {
            fprintf(stdout, "BOOL_LITERAL\n");
            setLiteralQuad(3, &$1, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
=======
DATA_LITERALS: INT_LITERAL                  { fprintf(stdout, "INT_LITERAL\n"); $$ = $1; }
    | FLOAT_LITERAL                         { fprintf(stdout, "FLOAT_LITERAL\n"); $$ = $1;}
    | STRING_LITERAL                        { fprintf(stdout, "STRING_LITERAL\n"); $$ = $1;}
    | CHAR_LITERAL                          { fprintf(stdout, "CHAR_LITERAL\n"); $$ = $1;}
    | BOOL_LITERAL                          { fsssprintf(stdout, "BOOL_LITERAL\n"); $$ = $1;}
>>>>>>> dfd78234eb2cea8a0cc651b130ab997aa910a482

DATA_TYPE: INT                              { $$ = 0;     }
    | FLOAT                                 { $$ = 1;     }
    | CHAR                                  { $$ = 2;     } 
    | BOOL                                  { $$ = 3;     }

OPENSCOPE: '{'                               { scopeNum++; }
CLOSESCOPE: '}'                              { scopeNum--; }

%%

int main(int argc, char **argv) {
    printf("============START OF PROGRAM===========\n");

    yyparse();

    printSymbolTable(); 

    return 0;
}
