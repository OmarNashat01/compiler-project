%{
    #include <stdio.h>
	#include <string.h>	
    #include "operation-table/operationTable.hpp"
    #include "symbol-table/symbolTable.hpp"

    SymbolTables symbolTables;
    OperationTables opTables;

    vector<string> dataTypes = {"int", "float", "char", "bool", "undefined"};
    vector<string> switchVars(0);
    vector<int> switchVarsTypes(0);


    int yyerror(const char *s) {
        fprintf(stdout, "%s\n", s);
        return 0;
    }
    int yylex(void);
	int yylineno = 1;

    // function variables
    vector<int> argTypes(0);
    vector<string> passedArgs(0);
    vector<int> passedArgsTypes(0);

    // operation table
    int tempCount = 0;
    vector<string> tempVars = {"t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9", "t10", "t11", "t12", "t13", "t14", "t15", "t16",
        "t17", "t18", "t19", "t20", "t21", "t22", "t23", "t24", "t25", "t26", "t27", "t28", "t29", "t30", "t31", "t32"
    };

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

    struct exprType {
        int type;
        char* var;
    } exprType;

}



// keywords
%token IF ELSE FOR WHILE DO RETURN BREAK SWITCH CASE CONST VOID CONTINUE DEFAULT STATIC CLASS
 
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
/* %token LBRACE RBRACE LBRACKET RBRACKET SEMICOLON COMMA COLON DOT QUESTION */

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
%type <exprType> EXPR BOOL_EXPR DATA_LITERALS

%type <block> BLOCK
%type <ival> OPENSCOPE CLOSESCOPE WHILE_TOK FOR_STMT
%type <ptr> IF_COND ELSE_TOK WHILE_COND CASE_STMT_COND
%type <forLoop> FOR_HEAD FOR_COND
%type <functionHead> FUNCTION_START

// associativity rules
%left INC DEC
%left ASSIGN
/* %left GT LT
%left GE LE
%left EQ NE
%left AND OR NOT
%left PLUS MINUS 
%left MULT DIV MOD */

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

STMT_LIST: error ';'                                      { fprintf(stderr, "Syntax error in line: %d\n", yylineno); }
    | error CLOSESCOPE                                    { fprintf(stderr, "Syntax error in line: %d\n", yylineno); }


STMT: NON_SCOPED_STMT ';'
    | SCOPED_STMT
// - [ ] Variables and Constants declaration.
NON_SCOPED_STMT: DATA_TYPE VARIABLE                       { 
            fprintf(stdout, "Variable declaration\n");
            symbolTables.addSymbol($1, !IS_CONST, !IS_FUNC, !IS_SET, $2, yylineno);
        }
    | DATA_TYPE VARIABLE ASSIGN EXPR                      { 
            fprintf(stdout, "Variable declaration with assignment\nvar :%d:%s \nres: %s\n", $1,$2,$4.var);

            if ($1 != $4.type){
                fprintf(stderr, "Error:%d: Type mismatch in variable declaration\n", yylineno);
            }

            symbolTables.addSymbol($1, !IS_CONST, !IS_FUNC, IS_SET, $2, yylineno);
            opTables.addQuad($3, $4.var, "NULL", $2);

            // value of all temp registers is reset
            tempCount = 0;
        }
    | CONST DATA_TYPE VARIABLE ASSIGN EXPR                { 
            fprintf(stdout, "Constant declaration with assignment\n");
            
            if ($2 != $5.type){
                fprintf(stderr, "Error:%d: Type mismatch in constant declaration\n", yylineno);
            }

            symbolTables.addSymbol($2, IS_CONST, !IS_FUNC, IS_SET, $3, yylineno);
            opTables.addQuad($4, $5.var, "NULL", $3);
            // value of all temp registers is reset
            tempCount = 0;
        }
    /* | BREAK */

// - [ ] Assign stataments.
NON_SCOPED_STMT: VARIABLE ASSIGN_OP EXPR                  { 
            fprintf(stdout, "(%s) statement\n", $1);
            int type = symbolTables.getVarType($1);
            if (type == 4){
                fprintf(stderr, "Error:%d: variable %s not declared\n", yylineno, $1);
            }
            else if (type != $3.type){
                fprintf(stderr, "Error:%d: Type mismatch in assignment\n", yylineno);
            }

            opTables.addQuad($2, $3.var, "NULL", $1);
            // value of all temp registers is reset
            tempCount = 0;
        }
    | VARIABLE ASSIGN EXPR                                { 
            fprintf(stdout, "Assignment statement\n");
            int type = symbolTables.getVarType($1);
            if (type == 4){
                fprintf(stderr, "Error:%d: variable %s not declared\n", yylineno, $1);
            }
            else if (type != $3.type){
                fprintf(stderr, "Error:%d: Type mismatch in assignment\n", yylineno);
            }
            
            opTables.addQuad($2, $3.var, "NULL", $1);    
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
            $$.var = tempVars[tempCount++].data();

            int type = symbolTables.getVarType($1);
            if (type == 4){
                fprintf(stderr, "Error:%d: variable %s not declared\n", yylineno, $1);
            }
            else if (type > 1){
                fprintf(stderr, "Error:%d: increment not available for type %s\n", yylineno, dataTypes[type].c_str());
            }
            $$.type = type;

        }
    | VARIABLE DEC                            {
            fprintf(stdout, "%s DEC\n", $1);
            opTables.addQuad(26, $1, "NULL", tempVars[tempCount]);
            $$.var = tempVars[tempCount++].data();
            
            int type = symbolTables.getVarType($1);
            if (type == 4){
                fprintf(stderr, "Error:%d: variable %s not declared\n", yylineno, $1);
            }
            else if (type > 1){
                fprintf(stderr, "Error:%d: decrement not available for type %s\n", yylineno, dataTypes[type].c_str());
            }
            $$.type = type;
        }

    | EXPR MATH_OP EXPR                       { 
            fprintf(stdout, "EXPR (%d) EXPR \n", $2); 
            opTables.addQuad($2, $1.var, $3.var, tempVars[tempCount]);
            $$.var = tempVars[tempCount++].data();

            if ($1.type != $3.type){
                fprintf(stderr, "Error:%d: Type mismatch in mathematical operation between %s and %s\n",
                 yylineno, dataTypes[$1.type].c_str(), dataTypes[$3.type].c_str());
            }
            $$.type = $1.type;
        }
    | EXPR BITWISE_OP EXPR                    { 
            fprintf(stdout, "EXPR (%d) EXPR\n", $2);
            opTables.addQuad($2, $1.var, $3.var, tempVars[tempCount]);
            $$.var = tempVars[tempCount++].data();
            
            if ($1.type != $3.type){
                fprintf(stderr, "Error:%d: Type mismatch in bitwise operation between %s and %s\n",
                 yylineno, dataTypes[$1.type].c_str(), dataTypes[$3.type].c_str());
            }
            $$.type = $1.type;
        }

    | BOOL_EXPR                               { fprintf(stdout, "BOOL_EXPR \n"); $$.var = $1.var; $$.type = 3;}
    | '(' EXPR ')'                            { fprintf(stdout, "(EXPR)\n"); $$.var = $2.var; $$.type = $2.type;}
    | VARIABLE                                { 
            fprintf(stdout, "VARIABLE\n");
            $$.var = $1;
            $$.type = symbolTables.getVarType($1);
            if ($$.type == 4){
                fprintf(stderr, "Error:%d: variable %s not declared\n", yylineno, $1);
            }
        }
    | DATA_LITERALS                           { fprintf(stdout, "DATA_LITERALS\n"); $$.var = $1.var; $$.type = $1.type;}

    // | INC VARIABLE                            { fprintf(stdout, "Prefix INC\n"); }
    // | DEC VARIABLE                            { fprintf(stdout, "Prefix DEC\n"); }

BOOL_EXPR: BOOL_LITERAL                       { 
            fprintf(stdout, "BOOL_LITERAL\n");
            opTables.addQuad(29, $1, "NULL", tempVars[tempCount]);
            $$.var = tempVars[tempCount++].data();
            $$.type = 3;
        }
    | '(' BOOL_EXPR ')'                       { fprintf(stdout, "(BOOL_EXPR)\n"); $$.var = $2.var; $$.type = 3;}
    | EXPR LOGICAL_OP EXPR                    { 
            fprintf(stdout, "EXPR (%d) EXPR\n", $2);
            opTables.addQuad($2, $1.var, $3.var, tempVars[tempCount]);
            $$.var = tempVars[tempCount++].data();
            $$.type = 3;
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
            OperationEntry* q = opTables.addQuad(27, $5.var, "NULL", "NULL");
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
    | SWITCH_HEAD OPENSCOPE CASES CLOSESCOPE                            { fprintf(stdout, "SWITCH statement\n"); }

SWITCH_HEAD: SWITCH '(' VARIABLE ')'                                    {
            int type = symbolTables.getVarType($3);
            if (type == 4){
                fprintf(stderr, "Error:%d: variable %s not declared\n", yylineno, $3);
            }
            switchVars.push_back($3);
            switchVarsTypes.push_back(type);
        }

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
            $$.jmpEnd = opTables.addQuad(28, $1.var, "NULL", "NULL");
            $$.jmpStart = opTables.addQuad(27, stringTrue, "NULL", "NULL");
            $$.beforeUpdate = opTables.createLabelQuad(); 
        }

WHILE_COND : '(' BOOL_EXPR ')'                                          { $$ = opTables.addQuad(28, $2.var, "NULL", "NULL"); }

WHILE_TOK: WHILE                                                        { $$ = opTables.createLabelQuad(); }

IF_COND: IF '(' BOOL_EXPR ')'                                           {
            fprintf(stdout, "IF_COND\n");
            // jump if false
            $$ = opTables.addQuad(28, $3.var, "NULL", "NULL");
        }

ELSE_TOK: ELSE                                                          {
            fprintf(stdout, "ELSE_TOK\n");
            // jump if true
            $$ = opTables.addQuad(27, stringTrue, "NULL", "NULL");
        }
CASES: CASE_STMT
    | CASE_STMT CASES

CASE_STMT: CASE_STMT_COND BLOCK                                 {
            fprintf(stdout, "CASE_STMT\n");

            opTables.editJumpQuad(reinterpret_cast<OperationEntry*>($1), $2.close);
        }

CASE_STMT_COND: CASE DATA_LITERALS ':' {
            int type = switchVarsTypes[switchVarsTypes.size()-1];
            if (type != $2.type){
                fprintf(stderr, "Error:%d: Type mismatch in switch case\n", yylineno);
            }

            opTables.addQuad(4, $2.var, switchVars[switchVars.size()-1], tempVars[tempCount]);
            // jump if false
            $$ = opTables.addQuad(28, tempVars[tempCount], "NULL", "NULL");
        }
// - [ ] Functions.
SCOPED_STMT: FUNCTION STMT_LIST_EPS 

FUNCTION: FUNCTION_START '(' PARAMS ')' OPENSCOPE STMT_LIST_EPS  RETURN EXPR ';' CLOSESCOPE       { 
            fprintf(stdout, "Function declaration\n"); 
            // addSymbol($1, !IS_CONST, IS_FUNC, !IS_SET, $2, yylineno);
            if ($1.symbol != NULL)
                reinterpret_cast<SymbolEntry*>($1.symbol)->setFunctionSymbol(argTypes);
            
            opTables.addQuad(32, "NULL", "NULL", "NULL");
            argTypes.clear();
            symbolTables.endFunction();
            opTables.endFunction();

            if ($8.type != $1.type){
                fprintf(stderr, "Error:%d: Return type of function %s does not match expected %s, got %s\n ",
                    yylineno, $1.name, dataTypes[$1.type].c_str(), dataTypes[$8.type].c_str());
            }
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

EXPR: VARIABLE '(' PASSED_PARAMS ')'        { 
    fprintf(stdout, "Function call\n");
    // check if function exists
    SymbolEntry* func = symbolTables.getSymbol($1);
    bool valid = true;
    if (func == NULL){
        fprintf(stderr, "Error:%d: Function %s not declared\n", yylineno, $1);
        valid = false;
    }
    else{
        // check if number of arguments match
        if (passedArgs.size() != func->argTypes.size()){
            fprintf(stderr, "Error:%d: Number of arguments in function call to %s does not match\n", yylineno, $1);
            valid = false;
        }
        else{
            // check if types of arguments match
            for (int i = 0; i < passedArgs.size(); i++){
                if (passedArgsTypes[i] != func->argTypes[i]){
                    valid = false;
                    fprintf(stderr, "Error:%d: Type of argument %d in function call to %s does not match\n", yylineno, i+1, $1);
                }
            }
        }
    }
    if (valid){
        vector<string> args = symbolTables.getFunctionParams($1, passedArgs.size());
        opTables.setFunctionParams(args, passedArgs, $1);
        string name = $1;
        opTables.addQuad(31, $1, "NULL", "LBL:" + name + ":0");
    }
    passedArgs.clear();
    passedArgsTypes.clear();
}

PASSED_PARAMS: EXPR                         {
            passedArgs.push_back($1.var);
            passedArgsTypes.push_back($1.type);
        }
    | PASSED_PARAMS ',' EXPR                {
            passedArgs.push_back($3.var);
            passedArgsTypes.push_back($3.type);
        }

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
            $$.var = tempVars[tempCount++].data();
            $$.type = 0;
        }
    | FLOAT_LITERAL                         {
            fprintf(stdout, "FLOAT_LITERAL\n");
            opTables.addQuad(29, $1, "NULL", tempVars[tempCount]);
            $$.var = tempVars[tempCount++].data();
            $$.type = 1;
        }
    | CHAR_LITERAL                          {
            fprintf(stdout, "CHAR_LITERAL\n");
            opTables.addQuad(29, $1, "NULL", tempVars[tempCount]);
            $$.var = tempVars[tempCount++].data();
            $$.type = 2;
        }
    | BOOL_LITERAL                          {
            fprintf(stdout, "BOOL_LITERAL\n");
            opTables.addQuad(29, $1, "NULL", tempVars[tempCount]);
            $$.var = tempVars[tempCount++].data();
            $$.type = 3;
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
