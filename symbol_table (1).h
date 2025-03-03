// symbol_table.h
#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// Structure pour les identifiants
typedef struct IDFNode {
    char name[20];
    char code[20];
    char type[20];
    float val;
    struct IDFNode* next;
} IDFNode;

// Structure pour les mots clés et séparateurs
typedef struct SymbolNode {
    char name[20];
    char code[20];
    struct SymbolNode* next;
} SymbolNode;

// Pointeurs globaux pour les différentes listes externes
extern IDFNode* idfList;
extern SymbolNode* keywordList;
extern SymbolNode* separatorList;

// Prototypes des fonctions
void initializeLists();
void insertIDF(char name[], char code[], char type[], float val);
void insertSymbol(SymbolNode** list, char name[], char code[]);
IDFNode* searchIDF(char name[]);
SymbolNode* searchSymbol(SymbolNode* list, char name[]);
void displayIDFTable(IDFNode* idf);
void displaySymbolTable(SymbolNode* list, const char* tableName);
void modifyIDF(char name[],float val);
#endif