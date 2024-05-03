#include "operationTable.h"

quadNode*TopPtr = NULL;		// (head) top of the list

void setQuad(int op, char* arg1, char* arg2, char* res, int id)
{
	// basically a constructor
	struct quadEntry *data = (struct quadEntry*) malloc(sizeof(struct quadEntry));
	data->op = op;
	data->arg1 = arg1;
	data->arg2 = arg2;
	data->res = res;
	pushQuad(id, data); 
	return ;
}

void pushQuad(int ID, quadEntry *data)
{

    // first node
    if (!TopPtr)
    {
        struct quadNode *myQuadlNode = (struct quadNode*) malloc(sizeof(struct quadNode));
        myQuadlNode->ID = ID;
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
    myQuadlNode->ID = ID;
    myQuadlNode->DATA = data;
    myQuadlNode->Next = NULL;
    ptr->Next = myQuadlNode; 
}