#include "operationTable.hpp"

// quadNode *TopPtr = NULL; // (head) top of the list
// int quadID = 0;          // ID of the quad
// int labelID = 0;         // ID of the label
// quadNode *currentFunction = NULL;
// functionsTable *functionsTop = NULL;

vector<string> operationType = {
    ">",
    "<",
    ">=",
    "<=",
    "==",
    "!=",
    "&&",
    "||",
    "&",
    "|",
    "^",
    "~",
    ">>",
    "<<",
    "+",
    "-",
    "*",
    "/",
    "%%",
    "=",
    "+=",
    "-=",
    "*=",
    "/=",
    "%%=",
    "++",
    "--",
    "JMP",
    "JMPF",
    "SETLiteral",
    "SetLabel",
    "CALL",
    "RET"};

OperationEntry::OperationEntry(int op, string arg1, string arg2, string res)
{
    this->op = op;
    this->arg1 = arg1;
    this->arg2 = arg2;
    this->res = res;
}
OperationEntry::~OperationEntry()
{
    // destructor
}

void OperationEntry::editJumpQuad(string scope, int jmpID)
{
    this->res = "LBL:" + scope + ":" + to_string(jmpID);
}

void OperationEntry::createLabelQuad(string scope, int labelID)
{
    this->res = "LBL:" + scope + ":" + to_string(labelID);
    labelID++;
}

void OperationEntry::printOperationEntry(FILE *fp)
{
    fprintf(fp, "%-10s|%-10s|%-10s|%-10s",
            operationType[this->op].c_str(),
            this->arg1.c_str(),
            this->arg2.c_str(),
            this->res.c_str());
    fflush(fp);
    fprintf(fp, "\n");
    fflush(fp);
    fprintf(fp, "----------|----------|----------|----------\n");
    fflush(fp);
}

///////////////////// OperationTable //////////////////////
OperationTable::OperationTable()
{
    labelCounter = 0;
}

OperationTable::~OperationTable()
{
    // destructor
    for (auto &entry : table)
    {
        delete entry;
    }
}

int OperationTable::createLabelQuad(string scope)
{
    this->addQuad(30, "", "", "LBL:" + scope + ":" + to_string(this->labelCounter));
    return this->labelCounter++;
}

OperationEntry *OperationTable::addQuad(int op, string arg1, string arg2, string res)
{
    OperationEntry *entry = new OperationEntry(op, arg1, arg2, res);
    table.push_back(entry);
    return entry;
}

void OperationTable::printOperationTable(FILE *fp)
{
    fprintf(fp, "Operation Table\n");
    fflush(fp);

    fprintf(fp, "%-10s|%-10s|%-10s|%-10s\n",
            "OP", "arg1", "arg2", "Result");
    fflush(fp);

    for (int i = 0; i < 3; i++)
    {
        fprintf(fp, "==========|");
        fflush(fp);
    }
    fprintf(fp, "==========\n");
    fflush(fp);

    for (auto &entry : table)
    {
        entry->printOperationEntry(fp);
    }

    fprintf(fp, "End of Operation Table\n");
    fflush(fp);
}

///////////////////// OperationTables //////////////////////
OperationTables::OperationTables()
{
    currentFunction = "global";
    tables[currentFunction] = new OperationTable();
}

OperationTables::~OperationTables()
{
    // destructor
    for (auto &table : tables)
    {
        delete table.second;
    }
}

OperationEntry *OperationTables::addQuad(int op, string arg1, string arg2, string res)
{
    return tables[currentFunction]->addQuad(op, arg1, arg2, res);
}

void OperationTables::editJumpQuad(OperationEntry *entry, int jmpID)
{
    entry->editJumpQuad(this->currentFunction, jmpID);
}

int OperationTables::createLabelQuad()
{
    return tables[currentFunction]->createLabelQuad(this->currentFunction);
}

void OperationTables::startFunction(string name)
{
    currentFunction = name;
    tables[currentFunction] = new OperationTable();
}

void OperationTables::setFunctionParams(vector<string> args, vector<string> params, string funcName)
{
    for (int i = 0; i < args.size(); i++)
    {
        tables[currentFunction]->addQuad(19, params[i], "NULL", args[i]);
    }
}

void OperationTables::endFunction()
{
    currentFunction = "global";
}

void OperationTables::printFunctionsTables()
{
    FILE *fp = fopen("tests/operationTable.txt", "w");
    for (auto &table : tables)
    {
        fprintf(fp, "Function: %s\n", table.first.c_str());
        fflush(fp);
        table.second->printOperationTable(fp);
    }
    fclose(fp);
}