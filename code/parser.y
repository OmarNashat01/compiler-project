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
    char *tempVars[32] = {"t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9", "t10", "t11", "t12", "t13", "t14", "t15", "t16",
        "t17", "t18", "t19", "t20", "t21", "t22", "t23", "t24", "t25", "t26", "t27", "t28", "t29", "t30", "t31", "t32"
    };
    int tempVarsType[32] = {0};

    char *stringTrue = "true";



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
    void *ptr;
    struct block {
        int open;
        int close;
    } block;

    struct forLoop {
        int beforeExpr, beforeUpdate;
        void *jmpStart, *jmpEnd;
    } forLoop;

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
/* %token <ival> INT_LITERAL */
/* %token <bval> BOOL_LITERAL */
/* %token <fval> FLOAT_LITERAL */
%token <sval> CHAR_LITERAL
%token <sval> INT_LITERAL BOOL_LITERAL FLOAT_LITERAL

// Type of data
%type <ival> DATA_TYPE
%type <sval> EXPR BOOL_EXPR DATA_LITERALS

%type <block> BLOCK
%type <ival> OPENSCOPE CLOSESCOPE WHILE_TOK FOR_STMT
%type <ptr> IF_COND ELSE_TOK WHILE_COND FUNCTION_START
%type <forLoop> FOR_HEAD FOR_COND

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
  
BLOCK: OPENSCOPE STMT_LIST CLOSESCOPE { $$.open = $1; $$.close = $3; }

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
            fprintf(stdout, "Variable declaration with assignment\nvar :%d:%s \nres: %s\n", $1,$2, $4);
            setSymbol($1, !IS_CONST, !IS_FUNC, IS_SET, $2, scopeNum, yylineno);
            setQuad($3, $4, NULL, $2);
            // value of all temp registers is reset
            tempCount = 0;
        }
    | CONST DATA_TYPE VARIABLE ASSIGN EXPR                { 
            fprintf(stdout, "Constant declaration with assignment\n");
            setSymbol($2, IS_CONST, !IS_FUNC, IS_SET, $3, scopeNum, yylineno);
            setQuad($4, $5, NULL, $3);
            // value of all temp registers is reset
            tempCount = 0;
        }
    | BREAK

// - [ ] Assign stataments.
NON_SCOPED_STMT: VARIABLE ASSIGN_OP EXPR                  { 
            fprintf(stdout, "(%s) statement\n", $1);
            setQuad($2, $3, NULL, $1);
            // value of all temp registers is reset
            tempCount = 0;
        }
    | VARIABLE ASSIGN EXPR                                { 
            fprintf(stdout, "Assignment statement\n");
            setQuad($2, $3, NULL, $1);    
            // value of all temp registers is reset
            tempCount = 0;
        }

// - [ ] Mathematical and logical expressions.
NON_SCOPED_STMT: EXPR                                     { 
            fprintf(stdout, "Floating EXPR statement\n");
            // value of all temp registers is reset
            tempCount = 0;
        }

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
            setLiteralQuad(3, $1, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | '(' BOOL_EXPR ')'                       { fprintf(stdout, "(BOOL_EXPR)\n"); $$ = $2; }
    | EXPR LOGICAL_OP EXPR                    { 
            fprintf(stdout, "EXPR (%d) EXPR\n", $2);
            setQuad($2, $1, $3, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }

//- [ ] If-then-else statement, while loops, repeat-until loops, for loops, switch statement.
SCOPED_STMT: IF_COND BLOCK                                 {
            fprintf(stdout, "IF statement\n");
            // value of all temp registers is reset
            tempCount = 0;
            editJumpQuad($1, $2.close);
        }
    
    | IF_COND BLOCK ELSE_TOK BLOCK                             {
            fprintf(stdout, "IF-ELSE statement\n");
            // value of all temp registers is reset
            tempCount = 0;
            editJumpQuad($1, $4.open);
            editJumpQuad($3, $4.close);
        }
    | WHILE_TOK WHILE_COND BLOCK                                     {
            fprintf(stdout, "WHILE statement\n"); 
            // value of all temp registers is reset
            tempCount = 0;
            // jump to start of while loop
            struct quadEntry* q = setQuad(27, stringTrue, NULL, NULL);
            editJumpQuad(q, $1);
            // create new label and jump to it if false
            editJumpQuad($2, createLabelQuad());
        }
        
    | DO BLOCK WHILE '(' BOOL_EXPR ')' ';'                              {
            fprintf(stdout, "DO-WHILE statement\n");
            // value of all temp registers is reset
            tempCount = 0;
            // jump to start of do-while loop
            struct quadEntry* q = setQuad(27, $5, NULL, NULL);
            editJumpQuad(q, $2.open);
        }
    | FOR_HEAD BLOCK {
            fprintf(stdout, "FOR loop statement\n");
            // value of all temp registers is reset
            scopeNum--;
            tempCount = 0;
            // jump to start of for loop
            struct quadEntry* q = setQuad(27, stringTrue, NULL, NULL);
            editJumpQuad(q, $1.beforeUpdate);

            // jump to  start scope to skip the update part
            editJumpQuad($1.jmpStart, $2.open);

            // jump to end if false
            editJumpQuad($1.jmpEnd, createLabelQuad());
        }
    | SWITCH '(' VARIABLE ')' OPENSCOPE CASES CLOSESCOPE                            { fprintf(stdout, "SWITCH statement\n"); }

FOR_HEAD :  FOR_STMT FOR_COND NON_SCOPED_STMT ')'                                            {
            void* ptr = setQuad(27, stringTrue, NULL, NULL);
            editJumpQuad(ptr, $$.beforeExpr);
            $$.jmpEnd = $2.jmpEnd;
            $$.jmpStart = $2.jmpStart;
            $$.beforeExpr = $1;
            $$.beforeUpdate = $2.beforeUpdate;
         }

FOR_STMT : FOR {scopeNum++;}'(' NON_SCOPED_STMT ';' {$$ = createLabelQuad();}
FOR_COND : BOOL_EXPR ';'                                                            {
            $$.jmpEnd = setQuad(28, $1, NULL, NULL);
            $$.jmpStart = setQuad(27, stringTrue, NULL, NULL);
            $$.beforeUpdate = createLabelQuad(); 
        }

WHILE_COND : '(' BOOL_EXPR ')'                                          { $$ = setQuad(28, $2, NULL, NULL); }

WHILE_TOK: WHILE                                                        { $$ = createLabelQuad(); }

IF_COND: IF '(' BOOL_EXPR ')'                                           {
            fprintf(stdout, "IF_COND\n");
            // jump if false
            $$ = setQuad(28, $3, NULL, NULL);
        }

ELSE_TOK: ELSE                                                          {
            fprintf(stdout, "ELSE_TOK\n");
            // jump if true
            $$ = setQuad(27, stringTrue, NULL, NULL);
        }
CASES: CASE_STMT
    | CASE_STMT CASES

CASE_STMT: DEFAULT ':' BLOCK
    | CASE DATA_LITERALS ':' BLOCK

// - [ ] Functions.
SCOPED_STMT: FUNCTION STMT_LIST_EPS 

FUNCTION: FUNCTION_START '(' PARAMS ')' OPENSCOPE STMT_LIST_EPS RETURN EXPR ';' CLOSESCOPE       { 
            fprintf(stdout, "Function declaration\n"); 
            setSymbol($1, !IS_CONST, IS_FUNC, !IS_SET, $2, scopeNum, yylineno);
            setFunctionSymbol(argNum, argTypes);
            argNum = 0;
        }
    
FUNCTION_START : DATA_TYPE VARIABLE         {
            // jump if true
            $$ = setQuad(27, stringTrue, NULL, NULL);
            setLabelQuad($2);
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



DATA_LITERALS: INT_LITERAL                  {
            fprintf(stdout, "INT_LITERAL\n");
            setLiteralQuad(0, $1, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | FLOAT_LITERAL                         {
            fprintf(stdout, "FLOAT_LITERAL\n");
            setLiteralQuad(1, $1, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | CHAR_LITERAL                          {
            fprintf(stdout, "CHAR_LITERAL\n");
            setLiteralQuad(2, $1, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }
    | BOOL_LITERAL                          {
            fprintf(stdout, "BOOL_LITERAL\n");
            setLiteralQuad(3, $1, tempVars[tempCount]);
            $$ = tempVars[tempCount++];
        }

DATA_TYPE: INT                              { $$ = 0;     }
    | FLOAT                                 { $$ = 1;     }
    | CHAR                                  { $$ = 2;     } 
    | BOOL                                  { $$ = 3;     }

OPENSCOPE: '{'                               { scopeNum++; $$ = createLabelQuad(); fprintf(stdout, "Lbl_%d\n", $$); }
CLOSESCOPE: '}'                              { scopeNum--; $$ = createLabelQuad(); fprintf(stdout, "Lbl_%d\n", $$); }

%%

int main(int argc, char **argv) {
    printf("============START OF PROGRAM===========\n");

    yyparse();

    printSymbolTable(); 
    printQuadTable();
    return 0;
}
