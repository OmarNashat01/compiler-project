#include "symbolTable.h"

struct symbolNode *ListTop = NULL;
int symbolID = 0;
const char *symbolEntryType[4] = {"int", "float", "char", "bool"};

void setSymbol(int rType, bool isConst, bool isFunction, bool isSet, char *Identifier, int ScopeNum, int LineNum)
{
    // Check if the variable is already declared in the current scope
    struct symbolNode *ptr = ListTop;
    while (ptr)
    {
        if (strcmp(ptr->DATA->ID, Identifier) == 0 && ptr->DATA->BracesScope == ScopeNum)
        {
            printf("Error: Variable %s already declared in the current scope\n", Identifier);
            return;
            // exit(1);
        }
        ptr = ptr->Next;
    }

    // basically a constructor
    struct symbolEntry *data = (struct symbolEntry *)malloc(sizeof(struct symbolEntry));
    data->Type = rType;                  // type of the variable from our defines
    data->isConst = isConst;             // constant or not
    data->Used = false;                  // used or not
    data->ID = Identifier;               // name of the variable
    data->BracesScope = ScopeNum;        // The scope to which it belongs (where it is declared)
    data->IsFunctionSymbol = isFunction; // initially assume nothing is a function (can be modified later in another function (setFuncArg))
    data->isSet = isSet;                 // value of the variable
    data->LineNum = LineNum;             // line number where it is declared
    pushSymbol(data);                    // push the symbol to the symbol table
}

void pushSymbol(struct symbolEntry *data)
{
    // Insert from Begining in the linked list
    // This makes checking the variable faster, as we start from the innermost scope
    struct symbolNode *mySymbolNode = (struct symbolNode *)malloc(sizeof(struct symbolNode));
    mySymbolNode->ID = symbolID;
    mySymbolNode->DATA = data;
    mySymbolNode->Next = ListTop;
    ListTop = mySymbolNode;

    symbolID++;
}

void setFunctionSymbol(int ArgNum, int *ArgTypes)
{
    struct symbolEntry *data = ListTop->DATA;

    int *ArgTypesCopy = (int *)malloc(ArgNum * sizeof(int));
    for (int i = 0; i < ArgNum; i++)
        ArgTypesCopy[i] = ArgTypes[i];

    // This function is used to set the function symbol
    data->IsFunctionSymbol = true;
    data->ArgNum = ArgNum;
    data->ArgTypes = ArgTypesCopy;
}
void printSymbolTable()
{
    // Print the symbol table
    FILE *fp = fopen("tests/symbolTable.txt", "w");

    struct symbolNode *ptr = ListTop;
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
    while (ptr)
    {
        fprintf(fp, "%-10d|", ptr->ID);
        fflush(fp);
        fprintf(fp, "%-10s|", symbolEntryType[ptr->DATA->Type]);
        fflush(fp);
        fprintf(fp, "%-10s|", ptr->DATA->isConst ? "true" : "false");
        fflush(fp);
        fprintf(fp, "%-10s|", ptr->DATA->Used ? "true" : "false");
        fflush(fp);
        fprintf(fp, "%-10s|", ptr->DATA->isSet ? "true" : "false");
        fflush(fp);
        fprintf(fp, "%-10s|", ptr->DATA->IsFunctionSymbol ? "true" : "false");
        fflush(fp);
        fprintf(fp, "%-10d|", ptr->DATA->BracesScope);
        fflush(fp);
        fprintf(fp, "%-10s|", ptr->DATA->ID);
        fflush(fp);
        fprintf(fp, "%-10d|", ptr->DATA->LineNum);
        fflush(fp);

        if (ptr->DATA->IsFunctionSymbol)
        {
            fprintf(fp, "%-10d|(", ptr->DATA->ArgNum);
            fflush(fp);
            // Print comma-separated ArgTypes with 2-space padding

            for (int i = 0; i < ptr->DATA->ArgNum; i++)
            {
                fprintf(fp, "%-2s", symbolEntryType[ptr->DATA->ArgTypes[i]]);
                fflush(fp);
                if (i != ptr->DATA->ArgNum - 1)
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
        ptr = ptr->Next;
    }
    fprintf(fp, "End of Symbol Table\n");
    fflush(fp);
    fclose(fp);
}
