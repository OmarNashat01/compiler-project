#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#include<string.h> 
#pragma warning (disable : 4996)			// disables warning for deprecated functions

// Structure for the symbol table
typedef struct symbolEntry {
    int Type;	                     
    bool isConst;
	bool Used;                         
	int BracesScope;                  
	char* Value;                     
    char* IdentifierName;           
	bool Modifiable;                  
	bool IsFunctionSymbol;           
	int ArgNum;                      
	int* ArgTypes;                    
	int LineNum;					 
} symbolEntry;

typedef struct symbolNode {
	struct symbolEntry * DATA;
	int ID;                    // representing the ID of the Symbol 
	struct symbolNode *Next;
} symbolNode;

const char *symbolEntryType[6] = {"int", "float", "char", "string", "bool", "void"};
enum symbolEntryType {INT, FLOAT, CHAR, STRING, BOOL, VOID};

struct symbolEntry* setSymbol(int type, bool isConstant, bool used, char * name,bool Modifiable, int ScopeNum, char* Value, int LineNum);
void pushSymbol(int ID, struct symbolEntry* data);   
void setFunctionSymbol(struct symbolEntry *data, int ArgNum, int* ArgTypes);
