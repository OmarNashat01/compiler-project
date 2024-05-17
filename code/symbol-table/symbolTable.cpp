#include "symbolTable.hpp"

const vector<string> symbolEntryType = {"int", "float", "char", "bool"};

int SymbolEntry::SymbolID = 0;
SymbolEntry::SymbolEntry(int type, bool isConst, bool isFunction, bool isSet, string name, int scopeNum, int lineNum)
{
    // Constructor
    // check if first instance of the class
    this->ID = SymbolID++;
    this->type = type;
    this->isConst = isConst;
    this->isFunctionSymbol = isFunction;
    this->isSet = isSet;
    this->name = name;
    this->scope = scopeNum;
    this->lineNum = lineNum;
}

SymbolEntry::~SymbolEntry()
{
    // Destructor
}

void SymbolEntry::setFunctionSymbol(vector<int> ArgTypes)
{
    this->isFunctionSymbol = true;
    this->argTypes = ArgTypes;
}
bool SymbolEntry::equalTo(string name, int scope)
{
    if (this->name == name && this->scope == scope)
        return true;
    return false;
}
void SymbolEntry::printSymbolEntry(FILE *fp)
{
    fprintf(fp, "%-10d|", this->ID);
    fflush(fp);
    fprintf(fp, "%-10s|", symbolEntryType[this->type].c_str());
    fflush(fp);
    fprintf(fp, "%-10s|", this->isConst ? "true" : "false");
    fflush(fp);
    fprintf(fp, "%-10s|", this->isUsed ? "true" : "false");
    fflush(fp);
    fprintf(fp, "%-10s|", this->isSet ? "true" : "false");
    fflush(fp);
    fprintf(fp, "%-10s|", this->isFunctionSymbol ? "true" : "false");
    fflush(fp);
    fprintf(fp, "%-10d|", this->scope);
    fflush(fp);
    fprintf(fp, "%-10s|", this->name.c_str());
    fflush(fp);
    fprintf(fp, "%-10d|", this->lineNum);
    fflush(fp);

    if (this->isFunctionSymbol)
    {
        fprintf(fp, "%-10d|(", this->argTypes.size());
        fflush(fp);
        // Print comma-separated ArgTypes with 2-space padding

        for (int i = 0; i < this->argTypes.size(); i++)
        {
            fprintf(fp, "%-2s", symbolEntryType[this->argTypes[i]].c_str());
            fflush(fp);
            if (i != this->argTypes.size() - 1)
            {
                fprintf(fp, ", "); // Use "%-2s" to print ", " with padding
                fflush(fp);
            }
        }
        fprintf(fp, ")");
        fflush(fp);
    }
    else
    {
        fprintf(fp, "%-10s|", "nil");
        fflush(fp);
        fprintf(fp, "%-10s", "nil");
        fflush(fp);
    }
    fprintf(fp, "\n");
    fflush(fp);
    for (int i = 0; i < 10; i++)
    {
        fprintf(fp, "----------|");
        fflush(fp);
    }
    fprintf(fp, "----------\n");
    fflush(fp);
}

//////////////////////////////////// SYMBOL TABLE //////////////////////////////////////////////
SymbolTable::SymbolTable()
{
    // Constructor
    this->scope = 0;
}

SymbolTable::~SymbolTable()
{
    // Destructor
    for (auto ptr : this->table)
    {
        delete ptr;
    }
}

int SymbolTable::getVarType(string name)
{
    // Get the type of the variable
    int searchingScope = this->scope;
    for (auto ptr : this->table)
    {
        if (ptr->scope < searchingScope)
            searchingScope = ptr->scope;

        if (ptr->scope != searchingScope)
            continue;

        if (ptr->equalTo(name, searchingScope))
            return ptr->type;
    }
    return 4;
}

SymbolEntry *SymbolTable::getSymbol(string name)
{
    // Check if the symbol is a function
    int searchingScope = this->scope;
    for (auto ptr : this->table)
    {
        if (ptr->scope < searchingScope)
            searchingScope = ptr->scope;

        if (ptr->scope != searchingScope)
            continue;

        if (ptr->equalTo(name, searchingScope) && ptr->isFunctionSymbol)
            return ptr;
    }
    return NULL;
}

SymbolEntry *SymbolTable::addSymbol(int type, bool isConstant, bool isFunction, bool isSet, string name, int lineNum)
{
    // check if symbol already exists
    for (auto ptr : this->table)
    {
        if (ptr->equalTo(name, this->scope))
        {
            fprintf(stderr, "Error:%d:  Symbol %s already exists in scope %d\n", ptr->lineNum, name.c_str(), this->scope);
            return NULL;
        }
    }
    // Add a symbol to the symbol table
    SymbolEntry *newSymbol = new SymbolEntry(type, isConstant, isFunction, isSet, name, this->scope, lineNum);
    this->table.insert(table.begin(), newSymbol);
    return newSymbol;
}

void SymbolTable::printSymbolTable(FILE *fp)
{
    // Print the symbol table
    fprintf(fp, "Symbol Table\n");
    fflush(fp);

    fprintf(fp, "%-10s|%-10s|%-10s|%-10s|%-10s|%-10s|%-10s|%-10s|%-10s|%-10s|%-10s\n",
            "ID", "Type", "Const", "Used", "Set", "Function", "Scope", "Name", "Line", "ArgNum", "ArgTypes");
    fflush(fp);
    for (int i = 0; i < 10; i++)
    {
        fprintf(fp, "==========|");
        fflush(fp);
    }
    fprintf(fp, "==========\n");
    fflush(fp);
    for (auto ptr : this->table)
    {
        ptr->printSymbolEntry(fp);
    }
    fprintf(fp, "End of Symbol Table\n");
    fflush(fp);
}

//////////////////////////////////// SYMBOL TABLES //////////////////////////////////////////////
SymbolTables::SymbolTables()
{
    // Constructor
    this->currentScope = "global";
    this->tables.insert(make_pair(this->currentScope, new SymbolTable()));
}

SymbolTables::~SymbolTables()
{
    // Destructor
    for (auto ptr : this->tables)
    {
        delete ptr.second;
    }
}

int SymbolTables::getVarType(string name)
{
    return this->tables[this->currentScope]->getVarType(name);
}

SymbolEntry *SymbolTables::getSymbol(string name)
{
    return this->tables[this->currentScope]->getSymbol(name);
}

SymbolEntry *SymbolTables::addSymbol(int type, bool isConstant, bool isFunction, bool isSet, string name, int lineNum)
{
    // Add a symbol to the symbol table
    return this->tables[this->currentScope]->addSymbol(type, isConstant, isFunction, isSet, name, lineNum);
}

void SymbolTables::addScope()
{
    // Add a new scope
    this->tables[this->currentScope]->addScope();
}
void SymbolTables::removeScope()
{
    // Remove the current scope
    this->tables[this->currentScope]->removeScope();
}

void SymbolTables::startFunction(string name)
{
    // Start a new function
    this->currentScope = name;
    this->tables.insert(make_pair(this->currentScope, new SymbolTable()));
}

vector<string> SymbolTables::getFunctionParams(string name, int argCount)
{
    // Get the parameters of the function
    vector<string> params;
    SymbolTable *funcTable = this->tables[name];
    // retrieve last argCount symbols
    for (int i = 0; i < argCount; i++)
    {
        SymbolEntry *param = funcTable->table[funcTable->table.size() - 1 - i];
        params.push_back(param->name);
    }
    return params;
}

void SymbolTables::printSymbolTables()
{
    // Print the symbol table
    FILE *fp = fopen("tests/symbolTable.txt", "w");
    if (fp == NULL)
    {
        printf("Error: Unable to open file\n");
        return;
    }

    for (auto ptr : this->tables)
    {
        fprintf(fp, "Table: %s\n", ptr.first.c_str());
        fflush(fp);
        ptr.second->printSymbolTable(fp);
    }
    fclose(fp);
}