%{
    #include <stdio.h>
	#include <string.h>	
    #include "operation-table/operationTable.hpp"
    #include "symbol-table/symbolTable.hpp"

    SymbolTables symbolTables;
    OperationTables opTables;


    int yyerror(const char *s) {
        fprintf(stdout, "%s\n", s);
        return 0;
    }
    int yylex(void);
	int yylineno = 1;
    std::string s;

    // function variables
    vector<int> argTypes(0);

    // operation table
    int tempCount = 0;
    string tempVars[] = {"t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9", "t10", "t11", "t12", "t13", "t14", "t15", "t16",
        "t17", "t18", "t19", "t20", "t21", "t22", "t23", "t24", "t25", "t26", "t27", "t28", "t29", "t30", "t31", "t32"
    };
    vector<int> tempVarsType(32, -1);

    string stringTrue = "true";



    #define IS_CONST 1
    #define IS_FUNC 1
    #define IS_SET 1

%}


%union {
    int ival;
    int bval;
    int opnum;
    float fval;
    char* sval;
    char* cval;
	char* id ;                    	/* IDENTIFIER Value */
    void *ptr;
    struct block {
        int open;
        int close;
    } block;

    struct functionHead{
        int type;
        char* name;
        void* symbol;
    } functionHead;

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
%type <ptr> IF_COND ELSE_TOK WHILE_COND 
%type <forLoop> FOR_HEAD FOR_COND
%type <functionHead> FUNCTION_START

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
            symbolTables.addSymbol($1, !IS_CONST, !IS_FUNC, !IS_SET, $2, yylineno);
        }
    | DATA_TYPE VARIABLE ASSIGN EXPR                      { 
            fprintf(stdout, "Variable declaration with assignment\nvar :%d:%s \nres: %s\n", $1,$2, $4);
            symbolTables.addSymbol($1, !IS_CONST, !IS_FUNC, IS_SET, $2, yylineno);
            opTables.addQuad($3, $4, "NULL", $2);
            // value of all temp registers is reset
            tempCount = 0;
        }
    | CONST DATA_TYPE VARIABLE ASSIGN EXPR                { 
            fprintf(stdout, "Constant declaration with assignment\n");
            symbolTables.addSymbol($2, IS_CONST, !IS_FUNC, IS_SET, $3, yylineno);
            opTables.addQuad($4, $5, "NULL", $3);
            // value of all temp registers is reset
            tempCount = 0;
        }
    | BREAK

// - [ ] Assign stataments.
NON_SCOPED_STMT: VARIABLE ASSIGN_OP EXPR                  { 
            fprintf(stdout, "(%s) statement\n", $1);
            opTables.addQuad($2, $3, "NULL", $1);
            // value of all temp registers is reset
            tempCount = 0;
        }
    | VARIABLE ASSIGN EXPR                                { 
            fprintf(stdout, "Assignment statement\n");
            opTables.addQuad($2, $3, "NULL", $1);    
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
            opTables.addQuad(25, $1, "NULL", tempVars[tempCount]);
            $$ = tempVars[tempCount++].data();
        }
    | VARIABLE DEC                            {
            fprintf(stdout, "%s DEC\n", $1);
            opTables.addQuad(26, $1, "NULL", tempVars[tempCount]);
            $$ = tempVars[tempCount++].data();
        }

    | EXPR MATH_OP EXPR                       { 
            fprintf(stdout, "EXPR (%d) EXPR \n", $2); 
            opTables.addQuad($2, $1, $3, tempVars[tempCount]);
            $$ = tempVars[tempCount++].data();
        }
    | EXPR BITWISE_OP EXPR                    { 
            fprintf(stdout, "EXPR (%d) EXPR\n", $2);
            opTables.addQuad($2, $1, $3, tempVars[tempCount]);
            $$ = tempVars[tempCount++].data();
        }
    | BOOL_EXPR                               { fprintf(stdout, "BOOL_EXPR \n"); $$ = $1;}
    | '(' EXPR ')'                            { fprintf(stdout, "(EXPR)\n"); $$ = $2;}
    | VARIABLE                                { fprintf(stdout, "VARIABLE\n"); $$ = $1;}
    | DATA_LITERALS                           { fprintf(stdout, "DATA_LITERALS\n"); $$ = $1;}

    // | INC VARIABLE                            { fprintf(stdout, "Prefix INC\n"); }
    // | DEC VARIABLE                            { fprintf(stdout, "Prefix DEC\n"); }

BOOL_EXPR: BOOL_LITERAL                       { 
            fprintf(stdout, "BOOL_LITERAL\n");
            opTables.addQuad(29, $1, "NULL", tempVars[tempCount]);
            $$ = tempVars[tempCount++].data();
        }
    | '(' BOOL_EXPR ')'                       { fprintf(stdout, "(BOOL_EXPR)\n"); $$ = $2; }
    | EXPR LOGICAL_OP EXPR                    { 
            fprintf(stdout, "EXPR (%d) EXPR\n", $2);
            opTables.addQuad($2, $1, $3, tempVars[tempCount]);
            $$ = tempVars[tempCount++].data();
        }

//- [ ] If-then-else statement, while loops, repeat-until loops, for loops, switch statement.
SCOPED_STMT: IF_COND BLOCK                                 {
            fprintf(stdout, "IF statement\n");
            // value of all temp registers is reset
            tempCount = 0;
            opTables.editJumpQuad(reinterpret_cast<OperationEntry*>($1), $2.close);
        }
    
    | IF_COND BLOCK ELSE_TOK BLOCK                             {
            fprintf(stdout, "IF-ELSE statement\n");
            // value of all temp registers is reset
            tempCount = 0;
            opTables.editJumpQuad(reinterpret_cast<OperationEntry*>($1), $4.open);
            opTables.editJumpQuad(reinterpret_cast<OperationEntry*>($3), $4.close);
        }
    | WHILE_TOK WHILE_COND BLOCK                                     {
            fprintf(stdout, "WHILE statement\n"); 
            // value of all temp registers is reset
            tempCount = 0;
            // jump to start of while loop
            OperationEntry* q = opTables.addQuad(27, stringTrue, "NULL", "NULL");
            opTables.editJumpQuad(q, $1);
            // create new label and jump to it if false
            opTables.editJumpQuad(reinterpret_cast<OperationEntry*>($2), opTables.createLabelQuad());
        }
        
    | DO BLOCK WHILE '(' BOOL_EXPR ')' ';'                              {
            fprintf(stdout, "DO-WHILE statement\n");
            // value of all temp registers is reset
            tempCount = 0;
            // jump to start of do-while loop
            OperationEntry* q = opTables.addQuad(27, $5, "NULL", "NULL");
            opTables.editJumpQuad(q, $2.open);
        }
    | FOR_HEAD BLOCK {
            fprintf(stdout, "FOR loop statement\n");
            // value of all temp registers is reset
            symbolTables.removeScope();
            tempCount = 0;
            // jump to start of for loop
            OperationEntry* q = opTables.addQuad(27, stringTrue, "NULL", "NULL");
            opTables.editJumpQuad(q, $1.beforeUpdate);

            // jump to  start scope to skip the update part
            opTables.editJumpQuad(reinterpret_cast<OperationEntry*>($1.jmpStart), $2.open);

            // jump to end if false
            opTables.editJumpQuad(reinterpret_cast<OperationEntry*>($1.jmpEnd), opTables.createLabelQuad());
        }
    | SWITCH '(' VARIABLE ')' OPENSCOPE CASES CLOSESCOPE                            { fprintf(stdout, "SWITCH statement\n"); }

FOR_HEAD :  FOR_STMT FOR_COND NON_SCOPED_STMT ')'                                            {
            OperationEntry* ptr = opTables.addQuad(27, stringTrue, "NULL", "NULL");
            opTables.editJumpQuad(ptr, $$.beforeExpr);
            $$.jmpEnd = $2.jmpEnd;
            $$.jmpStart = $2.jmpStart;
            $$.beforeExpr = $1;
            $$.beforeUpdate = $2.beforeUpdate;
         }

FOR_STMT : FOR {symbolTables.addScope();}'(' NON_SCOPED_STMT ';' {$$ = opTables.createLabelQuad();}
FOR_COND : BOOL_EXPR ';'                                                            {
            $$.jmpEnd = opTables.addQuad(28, $1, "NULL", "NULL");
            $$.jmpStart = opTables.addQuad(27, stringTrue, "NULL", "NULL");
            $$.beforeUpdate = opTables.createLabelQuad(); 
        }

WHILE_COND : '(' BOOL_EXPR ')'                                          { $$ = opTables.addQuad(28, $2, "NULL", "NULL"); }

WHILE_TOK: WHILE                                                        { $$ = opTables.createLabelQuad(); }

IF_COND: IF '(' BOOL_EXPR ')'                                           {
            fprintf(stdout, "IF_COND\n");
            // jump if false
            $$ = opTables.addQuad(28, $3, "NULL", "NULL");
        }

ELSE_TOK: ELSE                                                          {
            fprintf(stdout, "ELSE_TOK\n");
            // jump if true
            $$ = opTables.addQuad(27, stringTrue, "NULL", "NULL");
        }
CASES: CASE_STMT
    | CASE_STMT CASES

CASE_STMT: DEFAULT ':' BLOCK
    | CASE DATA_LITERALS ':' BLOCK

// - [ ] Functions.
SCOPED_STMT: FUNCTION STMT_LIST_EPS 

FUNCTION: FUNCTION_START '(' PARAMS ')' OPENSCOPE STMT_LIST_EPS RETURN EXPR ';' CLOSESCOPE       { 
            fprintf(stdout, "Function declaration\n"); 
            // addSymbol($1, !IS_CONST, IS_FUNC, !IS_SET, $2, yylineno);
            if ($1.symbol != NULL)
                reinterpret_cast<SymbolEntry*>($1.symbol)->setFunctionSymbol(argTypes);
            argTypes.clear();
            symbolTables.endFunction();
            opTables.endFunction();
        }
    
FUNCTION_START : DATA_TYPE VARIABLE         {
            // jump if true
            $$.type = $1;
            $$.name = $2;
            $$.symbol = symbolTables.addSymbol($1, !IS_CONST, IS_FUNC, !IS_SET, $2, yylineno);
            if ($$.symbol != NULL){
                symbolTables.startFunction($2);
                opTables.startFunction($2);
            }
            else{
                symbolTables.startFunction("error");
                opTables.startFunction($2);
            }
        }     

EXPR: VARIABLE '(' PASSED_PARAMS ')'        { fprintf(stdout, "Function call\n"); }

PASSED_PARAMS: EXPR
    | PASSED_PARAMS ',' EXPR

PARAMS: DATA_TYPE VARIABLE                  { 
            argTypes.push_back($1);
            symbolTables.addSymbol($1, !IS_CONST, !IS_FUNC, IS_SET, $2, yylineno);
        }
    | PARAMS ',' DATA_TYPE VARIABLE         { 
            argTypes.push_back($3);
            symbolTables.addSymbol($3, !IS_CONST, !IS_FUNC, IS_SET, $4, yylineno);
        }
    |



DATA_LITERALS: INT_LITERAL                  {
            fprintf(stdout, "INT_LITERAL \n");
            opTables.addQuad(29, $1, "NULL", tempVars[tempCount]);
            tempVarsType[tempCount] = 0;
            $$ = tempVars[tempCount++].data();
        }
    | FLOAT_LITERAL                         {
            fprintf(stdout, "FLOAT_LITERAL\n");
            opTables.addQuad(29, $1, "NULL", tempVars[tempCount]);
            tempVarsType[tempCount] = 1;
            $$ = tempVars[tempCount++].data();
        }
    | CHAR_LITERAL                          {
            fprintf(stdout, "CHAR_LITERAL\n");
            opTables.addQuad(29, $1, "NULL", tempVars[tempCount]);
            tempVarsType[tempCount] = 2;
            $$ = tempVars[tempCount++].data();
        }
    | BOOL_LITERAL                          {
            fprintf(stdout, "BOOL_LITERAL\n");
            opTables.addQuad(29, $1, "NULL", tempVars[tempCount]);
            tempVarsType[tempCount] = 3;
            $$ = tempVars[tempCount++].data();
        }

DATA_TYPE: INT                              { $$ = 0;     }
    | FLOAT                                 { $$ = 1;     }
    | CHAR                                  { $$ = 2;     } 
    | BOOL                                  { $$ = 3;     }

OPENSCOPE: '{'                               { symbolTables.addScope(); $$ = opTables.createLabelQuad(); fprintf(stdout, "Lbl_%d\n", $$); }
CLOSESCOPE: '}'                              { symbolTables.removeScope(); $$ = opTables.createLabelQuad(); fprintf(stdout, "Lbl_%d\n", $$); }

%%

int main(int argc, char **argv) {
    printf("============START OF PROGRAM===========\n");
    yyparse();

    symbolTables.printSymbolTables(); 
    opTables.printFunctionsTables();
    return 0;
}
