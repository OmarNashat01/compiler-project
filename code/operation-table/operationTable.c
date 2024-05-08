#include "operationTable.h"


quadNode* TopPtr = NULL;		// (head) top of the list
int quadID = 0;					// ID of the quad
//TODO: write todo message
//TODO:
char* operationType[] = {"+", "-", "*", "/", ">", "<", ">=", "<=", "==", "!="};

void setQuad(int op, char* arg1, char* arg2, char* res)
{
	// basically a constructor
	struct quadEntry *data = (struct quadEntry*) malloc(sizeof(struct quadEntry));
	data->op = op;
	data->arg1 = arg1;
	data->arg2 = arg2;
	data->res = res;
    data->type = -1;
	pushQuad(data); 
	return ;
}

void setLiteralQuad(int type, void *arg1, char *res)
{
	struct quadEntry *data = (struct quadEntry*) malloc(sizeof(struct quadEntry));
	data->op = 29;
	data->arg1 = arg1;
	data->res = res;
    data->type = type;
	pushQuad(data); 
    return;
}


void pushQuad(quadEntry *data)
{

    // first node
    if (!TopPtr)
    {
        struct quadNode *myQuadlNode = (struct quadNode*) malloc(sizeof(struct quadNode));
        myQuadlNode->ID = quadID;
        myQuadlNode->DATA = data;
        myQuadlNode->Next = NULL;
        TopPtr = myQuadlNode;
        return;
    }

    // get last node
    struct quadNode *ptr = TopPtr;
    while (ptr->Next)
        ptr = ptr->Next;
    
    struct quadNode *myQuadlNode = (struct quadNode*) malloc(sizeof(struct quadNode));
    myQuadlNode->ID = quadID;
    myQuadlNode->DATA = data;
    myQuadlNode->Next = NULL;
    ptr->Next = myQuadlNode; 

    quadID++;
}

void printQuadTable(){

    // Print the symbol table
    struct quadNode *ptr = TopPtr;
    printf("Quad Table\n");

    printf("%-10s|%-10s|%-10s|%-10s",
           "OP", "arg1", "arg2", "Result");

    for (int i = 0; i < 3; i++)
    {
        printf("==========|");
    }
    printf("==========\n");
    while (ptr)
    {
        printf("%-10s|%-10s|%-10s|%-10s",
               operationType[ptr->DATA->op], ptr->DATA->arg1, ptr->DATA->arg2, ptr->DATA->res);
        printf("\n");
        for (int i = 0; i < 3; i++)
        {
            printf("----------|");
        }
        printf("----------\n");
        ptr = ptr->Next;
    }
    printf("\n");
}
