#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <string>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

// Structure for the symbol table
class SymbolEntry
{
public:
	SymbolEntry(int type, bool isConstant, bool isFunction, bool isSet, string name, int ScopeNum, int LineNum);
	~SymbolEntry();
	void setFunctionSymbol(vector<int> ArgTypes);
	void printSymbolEntry(FILE *fp);

	// private:
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
class SymbolTable
{
public:
	SymbolTable();
	~SymbolTable();
	SymbolEntry *addSymbol(int type, bool isConstant, bool isFunction, bool isSet, string name, int ScopeNum, int LineNum);
	void printSymbolTable();

private:
	vector<SymbolEntry *> table;
};
#endif
