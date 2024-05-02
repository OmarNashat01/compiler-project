#include"symbolTable.h"


char* idtype[11] = { "Integer", "Float", "Char", "String", "Bool", "ConstIntger", "ConstFloat", "ConstChar", "ConstString", "ConstBool","void" };
struct SymbolNode * ListTop = NULL;
struct SymbolData* setSymbol(int rType, int rValue, bool rUsed,char* Identifier,bool rModifiable,int ScopeNum, char* Value, int LineNum)
{
    // basically a constructor
	struct SymbolData *data = (struct SymbolData*) malloc(sizeof(struct SymbolData));
	data->Type = rType;                         // type of the variable from our defines
	data->Initilzation = rValue;                // initial value
	data->Used = rUsed;                         // used or not
	data->IdentifierName = Identifier;          // name of the variable
	data->Modifiable=rModifiable;               // constant = not modifiable, otherwise modifiable
	data->BracesScope = ScopeNum;               // The scope to which it belongs (where it is declared)
	data->IsFunctionSymbol = false;             // initially assume nothing is a function (can be modified later in another function (setFuncArg))
	data->Value = Value;                        // value of the variable
	data->LineNum = LineNum;                    // line number where it is declared
	
	return data;
}

void pushSymbol(int index, struct SymbolData *data) {
	// Insert from Begining in the linked list
    // This makes checking the variable faster, as we start from the innermost scope
	struct SymbolNode *mySymbolNode = (struct SymbolNode*) malloc(sizeof(struct SymbolNode));
	mySymbolNode->ID = index;
	mySymbolNode->DATA = data;
	mySymbolNode->Next = ListTop;
	ListTop = mySymbolNode;
}