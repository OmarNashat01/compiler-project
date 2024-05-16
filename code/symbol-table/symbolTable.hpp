#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <string>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

// Structure for the symbol table
struct
{
	int Type;
	bool isConst;
	bool Used;
	bool isSet;
	bool IsFunctionSymbol;
	int BracesScope;
	string ID;
	int ArgNum;
	vector<int> ArgTypes;
	int LineNum;
} symbolEntry;

struct
{
	struct symbolEntry *DATA;
	int ID; // representing the ID of the Symbol
	struct symbolNode *Next;
} symbolNode;

class SymbolTable
{
public:
	SymbolTable();
	~SymbolTable();
	static SymbolTable *setSymbol(int type, bool isConstant, bool isFunction, bool isSet, string name, int ScopeNum, int LineNum);
	void pushSymbol();
	void setFunctionSymbol(vector<int> ArgTypes);
	static void printSymbolTable();

private:
	static const vector<string> symbolEntryType;
	static vector<SymbolTable *> AllSymbols;
	static int SymbolID;

	int ID;
	int type;
	bool isConst;
	bool isUsed;
	bool isSet;
	bool isFunctionSymbol;
	int scope;
	string name;
	vector<int> argTypes;
	int lineNum;
};

#endif
