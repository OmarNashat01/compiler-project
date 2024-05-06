#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#pragma warning(disable : 4996) // disables warning for deprecated functions

#ifndef OPERATION_TABLE_H
#define OPERATION_TABLE_H

typedef struct quadEntry
{
    int op;
    char *arg1, *arg2, *res;
    int type;
} quadEntry;

typedef struct quadNode
{
    quadEntry *DATA;
    int ID;
    struct quadNode *Next;
} quadNode;


void setQuad(int op, char *arg1, char *arg2, char *res);
void pushQuad(quadEntry *data);
void printQuadTable();

#endif
