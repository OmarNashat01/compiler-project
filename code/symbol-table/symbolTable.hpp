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
	int scope;
	int type;
	bool isFunctionSymbol;
	vector<int> argTypes;
	string name;

private:
	static int SymbolID;

	int ID;
	bool isConst;
	bool isUsed;
	bool isSet;
};

class SymbolTable
{
public:
	SymbolTable();
	~SymbolTable();
	SymbolEntry *addSymbol(int type, bool isConstant, bool isFunction, bool isSet, string name, int LineNum);

	int getVarType(string name);
	SymbolEntry *getSymbol(string name);

	void addScope() { scope++; }
	void removeScope() { scope--; }

	void printSymbolTable(FILE *fp);

	vector<SymbolEntry *> table;

private:
	int scope;
};

class SymbolTables
{
public:
	SymbolTables();
	~SymbolTables();

	SymbolEntry *addSymbol(int type, bool isConstant, bool isFunction, bool isSet, string name, int LineNum);

	int getVarType(string name);
	SymbolEntry *getSymbol(string name);

	vector<string> getFunctionParams(string name, int argCount);

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
