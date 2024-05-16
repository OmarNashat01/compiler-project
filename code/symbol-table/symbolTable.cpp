#include "symbolTable.hpp"

const vector<string> SymbolTable::symbolEntryType = {"int", "float", "char", "bool"};
int SymbolTable::SymbolID = 0;
vector<SymbolTable *> SymbolTable::AllSymbols;
SymbolTable::SymbolTable()
{
    // Constructor
    // check if first instance of the class
    AllSymbols.insert(AllSymbols.begin(), this);
}

SymbolTable *SymbolTable::setSymbol(int type, bool isConst, bool isFunction, bool isSet, string name, int scopeNum, int lineNum)
{
    // Check if the variable is already declared in the current scope
    for (auto var : AllSymbols)
    {
        if (var->name == name && var->scope == scopeNum)
        {
            printf("Error: Variable %s already declared in the current scope\n", name);
            return NULL;
            // exit(1);
        }
    }
    SymbolTable *newSymbol = new SymbolTable();
    newSymbol->ID = SymbolID++;
    newSymbol->type = type;
    newSymbol->isConst = isConst;
    newSymbol->isFunctionSymbol = isFunction;
    newSymbol->isSet = isSet;
    newSymbol->name = name;
    newSymbol->scope = scopeNum;
    newSymbol->lineNum = lineNum;

    return newSymbol;
}

void SymbolTable::setFunctionSymbol(vector<int> ArgTypes)
{
    this->isFunctionSymbol = true;
    this->argTypes = ArgTypes;
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
    for (auto ptr : AllSymbols)
    {
        fprintf(fp, "%-10d|", ptr->ID);
        fflush(fp);
        fprintf(fp, "%-10s|", symbolEntryType[ptr->type].c_str());
        fflush(fp);
        fprintf(fp, "%-10s|", ptr->isConst ? "true" : "false");
        fflush(fp);
        fprintf(fp, "%-10s|", ptr->isUsed ? "true" : "false");
        fflush(fp);
        fprintf(fp, "%-10s|", ptr->isSet ? "true" : "false");
        fflush(fp);
        fprintf(fp, "%-10s|", ptr->isFunctionSymbol ? "true" : "false");
        fflush(fp);
        fprintf(fp, "%-10d|", ptr->scope);
        fflush(fp);
        fprintf(fp, "%-10s|", ptr->name.c_str());
        fflush(fp);
        fprintf(fp, "%-10d|", ptr->lineNum);
        fflush(fp);

        if (ptr->isFunctionSymbol)
        {
            fprintf(fp, "%-10d|(", ptr->argTypes.size());
            fflush(fp);
            // Print comma-separated ArgTypes with 2-space padding

            for (int i = 0; i < ptr->argTypes.size(); i++)
            {
                fprintf(fp, "%-2s", symbolEntryType[ptr->argTypes[i]].c_str());
                fflush(fp);
                if (i != ptr->argTypes.size() - 1)
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
    fprintf(fp, "End of Symbol Table\n");
    fflush(fp);
    fclose(fp);
}
