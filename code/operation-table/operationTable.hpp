#ifndef OPERATION_TABLE_H
#define OPERATION_TABLE_H
#include <string>
#include <unordered_map>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

class OperationEntry
{
public:
    static int OperationID;
    OperationEntry(int op, string arg1, string arg2, string res);
    ~OperationEntry();

    void editJumpQuad(string scope, int jmpID);
    void createLabelQuad(string scope, int labelID);

    void printOperationEntry(FILE *fp);

private:
    int op;
    string arg1;
    string arg2;
    string res;
};

class OperationTable
{
public:
    OperationTable();
    ~OperationTable();

    OperationEntry *addQuad(int op, string arg1, string arg2, string res);
    void printOperationTable(FILE *fp);

    int createLabelQuad(string scope);

private:
    vector<OperationEntry *> table;
    int labelCounter;
};

class OperationTables
{
public:
    OperationTables();
    ~OperationTables();

    OperationEntry *addQuad(int op, string arg1, string arg2, string res);
    void editJumpQuad(OperationEntry *entry, int jmpID);
    int createLabelQuad();

    void startFunction(string name);
    void endFunction();
    void printFunctionsTables();

private:
    unordered_map<string, OperationTable *> tables;
    string currentFunction;
};

#endif