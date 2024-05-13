#include "operationTable.h"

quadNode *TopPtr = NULL; // (head) top of the list
int quadID = 0;          // ID of the quad
int labelID = 0;         // ID of the label
// TODO: write todo message
// TODO:
char *operationType[] = {
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
    "SetLabel"};

struct quadEntry *setQuad(int op, char *arg1, char *arg2, char *res)
{
    // basically a constructor
    struct quadEntry *data = (struct quadEntry *)malloc(sizeof(struct quadEntry));
    data->op = op;
    data->arg1 = arg1;
    data->arg2 = arg2;
    data->res = res;
    data->type = -1;
    pushQuad(data);
    return data;
}

void editJumpQuad(struct quadEntry *data, int jmpID)
{
    data->res = (char *)malloc(10);
    sprintf(data->res, "LBL_%d", jmpID);
    return;
}

int createLabelQuad()
{
    char *label = (char *)malloc(10);
    sprintf(label, "LBL_%d", labelID);
    setQuad(30, NULL, NULL, label);
    return labelID++;
}
int createLabelQuad(char *name)
{
    // get length of the string
    char *label = malloc(4 + strlen(name));
    sprintf(label, "LBL_%s", name);
    setQuad(30, NULL, NULL, label);
    return labelID++;
}

void setLiteralQuad(int type, char *arg1, char *res)
{

    struct quadEntry *data = (struct quadEntry *)malloc(sizeof(struct quadEntry));
    data->op = 29;
    data->arg1 = arg1;
    data->arg2 = NULL;
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
        struct quadNode *myQuadlNode = (struct quadNode *)malloc(sizeof(struct quadNode));
        myQuadlNode->ID = quadID;
        myQuadlNode->DATA = data;
        myQuadlNode->Next = NULL;
        TopPtr = myQuadlNode;

        quadID++;
        return;
    }

    // get last node
    struct quadNode *ptr = TopPtr;
    while (ptr->Next)
        ptr = ptr->Next;

    struct quadNode *myQuadlNode = (struct quadNode *)malloc(sizeof(struct quadNode));
    myQuadlNode->ID = quadID;
    myQuadlNode->DATA = data;
    myQuadlNode->Next = NULL;
    ptr->Next = myQuadlNode;

    quadID++;
}

void printQuadTable()
{
    FILE *fp = fopen("tests/quadTable.txt", "w");
    if (!fp)
    {
        fprintf(stderr, "Error: Unable to open file\n");
        return;
    }
    fprintf(fp, "Quad Table\n");
    fflush(fp);

    // Print the symbol table
    struct quadNode *ptr = TopPtr;

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
    while (ptr)
    {
        fprintf(fp, "%-10s|%-10s|%-10s|%-10s",
                operationType[ptr->DATA->op],
                ptr->DATA->arg1 ? ptr->DATA->arg1 : "nil",
                ptr->DATA->arg2 ? ptr->DATA->arg2 : "nil",
                ptr->DATA->res ? ptr->DATA->res : "nil");
        fflush(fp);
        fprintf(fp, "\n");
        fflush(fp);

        for (int i = 0; i < 3; i++)
        {
            fprintf(fp, "----------|");
            fflush(fp);
        }
        fprintf(fp, "----------\n");
        fflush(fp);
        ptr = ptr->Next;
    }
    fprintf(fp, "End of Quad Table\n");
    fclose(fp);
}
