#include<stdio.h>
#include<stdlib.h>
#pragma warning (disable : 4996)			// disables warning for deprecated functions
typedef struct quadEntry {
    int op;
    char* arg1, arg2, res;
}quadEntry;

typedef struct quadNode {
    quadEntry* DATA;
    int ID;
    struct quadList* Next;
}quadNode;

void setQuad(int op, char* arg1, char* arg2, char* res, int id);
void pushQuad(int ID, quadEntry *data);
