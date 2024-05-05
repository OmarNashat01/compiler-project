#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#pragma warning(disable : 4996) // disables warning for deprecated functions

#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

// Structure for the symbol table
typedef struct symbolEntry
{
	int Type;
	bool isConst;
	bool Used;
	bool isSet;
	bool IsFunctionSymbol;
	int BracesScope;
	char *ID;
	int ArgNum;
	int *ArgTypes;
	int LineNum;
} symbolEntry;

typedef struct symbolNode
{
	struct symbolEntry *DATA;
	int ID; // representing the ID of the Symbol
	struct symbolNode *Next;
} symbolNode;

void setSymbol(int type, bool isConstant, bool isFunction, bool isSet, char *name, int ScopeNum, int LineNum);
void pushSymbol(struct symbolEntry *data);
void setFunctionSymbol(int ArgNum, int *ArgTypes);
void printSymbolTable();
#endif
