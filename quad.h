#ifndef QUAD_H
#define QUAD_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structure pour représenter un quadruplet
typedef struct Quad {
    char operator[10];
    char operand1[30];
    char operand2[30];
    char result[30];
} Quad;

typedef struct Var{
    char name[15];
    float val;
}Var;

extern Var var[100];
extern int varIndex;


extern Quad quad[1000];  // Tableau pour stocker les quadruplets
extern int quadIndex;          // Compteur de quadruplets

void traiterQuad();
void displayQuad();
char* ftos(float value);
void addQuad(char* operator, char* operand1, char* operand2, char* result);
#endif // QUAD_H
