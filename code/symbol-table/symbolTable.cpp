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
}

SymbolTable::~SymbolTable()
{
    // Destructor
    for (auto ptr : this->table)
    {
        delete ptr;
    }
}

SymbolEntry *SymbolTable::addSymbol(int type, bool isConstant, bool isFunction, bool isSet, string name, int scopeNum, int lineNum)
{
    // check if symbol already exists
    for (auto ptr : this->table)
    {
        if (ptr->name == name && ptr->scope == scopeNum)
        {
            fprintf(stderr, "Error:%d:  Symbol %s already exists in scope %d\n", ptr->lineNum, name.c_str(), scopeNum);
            return NULL;
        }
    }
    // Add a symbol to the symbol table
    SymbolEntry *newSymbol = new SymbolEntry(type, isConstant, isFunction, isSet, name, scopeNum, lineNum);
    this->table.insert(table.begin(), newSymbol);
    return newSymbol;
}

void SymbolTable::printSymbolTable()
{
    // Print the symbol table
    FILE *fp = fopen("tests/symbolTable.txt", "w");
    if (fp == NULL)
    {
        printf("Error: Unable to open file\n");
        return;
    }

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
    fclose(fp);
}
