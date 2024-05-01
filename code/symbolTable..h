#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#include<string.h> 
#pragma warning (disable : 4996)			// disables warning for deprecated functions


// Structure for the symbol table
typedef struct symbolTable {
    int Type;	                     
	bool Initilzation;                
	bool Used;                         
	int BracesScope;                  
	char* Value;                     
    char* IdentifierName;           
	bool Modifiable;                  
	bool IsFunctionSymbol;           
	int ArgNum;                      
	int* ArrTypes;                    
	int LineNum;					 
} symbolTable;

typedef struct SymbolNode {
	struct SymbolData * DATA;
	int ID;                    // representing the ID of the Symbol 
	struct SymbolNode *Next;
} SymbolNode;

struct SymbolData* setSymbol(int type, int init, bool used, char * name,bool Modifiable, int ScopeNum, char* Value, int LineNum);
void pushSymbol(int ID, struct SymbolData* data);   