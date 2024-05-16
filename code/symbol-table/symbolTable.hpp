#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <string>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <unordered_map>
using namespace std;

// Structure for the symbol table
class SymbolEntry
{
public:
	SymbolEntry(int type, bool isConstant, bool isFunction, bool isSet, string name, int ScopeNum, int LineNum);
	~SymbolEntry();
	void setFunctionSymbol(vector<int> ArgTypes);
	void printSymbolEntry(FILE *fp);
	bool equalTo(string name, int scope);

	int lineNum;

private:
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
};

class SymbolTable
{
public:
	SymbolTable();
	~SymbolTable();
	SymbolEntry *addSymbol(int type, bool isConstant, bool isFunction, bool isSet, string name, int ScopeNum, int LineNum);

	void addScope() { scope++; }
	void removeScope() { scope--; }

	void printSymbolTable(FILE *fp);

private:
	vector<SymbolEntry *> table;
	int scope;
};

class SymbolTables
{
public:
	SymbolTables();
	~SymbolTables();

	SymbolEntry *addSymbol(int type, bool isConstant, bool isFunction, bool isSet, string name, int ScopeNum, int LineNum);

	void addScope();
	void removeScope();

	void startFunction(string name);
	void endFunction() { currentScope = "global"; }

	void printSymbolTables();

private:
	unordered_map<string, SymbolTable *> tables;
	string currentScope;
};
#endif
