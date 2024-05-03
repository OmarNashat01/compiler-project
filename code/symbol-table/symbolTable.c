#include "symbolTable.h"

struct symbolNode *ListTop = NULL;
struct symbolEntry* setSymbol(int rType, bool isConst, bool rUsed,char* Identifier,bool rModifiable,int ScopeNum, char* Value, int LineNum)
{
    // basically a constructor
	struct symbolEntry *data = (struct symbolEntry*) malloc(sizeof(struct symbolEntry));
	data->Type = rType;                         // type of the variable from our defines
    data->isConst = isConst;                    // constant or not
	data->Used = rUsed;                         // used or not
	data->IdentifierName = Identifier;          // name of the variable
	data->Modifiable=rModifiable;               // constant = not modifiable, otherwise modifiable
	data->BracesScope = ScopeNum;               // The scope to which it belongs (where it is declared)
	data->IsFunctionSymbol = false;             // initially assume nothing is a function (can be modified later in another function (setFuncArg))
	data->Value = Value;                        // value of the variable
	data->LineNum = LineNum;                    // line number where it is declared
	
	return data;
}

void pushSymbol(int index, struct symbolEntry *data)
{
	// Insert from Begining in the linked list
	// This makes checking the variable faster, as we start from the innermost scope
	struct symbolNode *mySymbolNode = (struct symbolNode *)malloc(sizeof(struct symbolNode));
	mySymbolNode->ID = index;
	mySymbolNode->DATA = data;
	mySymbolNode->Next = ListTop;
	ListTop = mySymbolNode;
}

void setFunctionSymbol(struct symbolEntry *data, int ArgNum, int* ArgTypes)
{
    // This function is used to set the function symbol
    data->IsFunctionSymbol = true;
    data->ArgNum = ArgNum;
    data->ArgTypes = ArgTypes;
}
