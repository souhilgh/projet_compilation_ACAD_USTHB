// symbol_table.c
#include "symbol_table.h"

// Déclaration des listes globales
IDFNode* idfList = NULL;
SymbolNode* keywordList = NULL;
SymbolNode* separatorList = NULL;

// Fonction pour initialiser les listes
void initializeLists() {
    idfList = NULL;
    keywordList = NULL;
    separatorList = NULL;
}

// Fonction pour insérer un identifiant
void insertIDF(char name[], char code[], char type[], float val) {
    IDFNode* newNode = (IDFNode*)malloc(sizeof(IDFNode));
    strcpy(newNode->name, name);
    strcpy(newNode->code, code);
    strcpy(newNode->type, type);
    newNode->val = val;
    newNode->next = idfList;
    idfList = newNode;
}

// Fonction pour insérer un mot clé ou un séparateur
void insertSymbol(SymbolNode** list, char name[], char code[]) {
    SymbolNode* newNode = (SymbolNode*)malloc(sizeof(SymbolNode));
    strcpy(newNode->name, name);
    strcpy(newNode->code, code);
    newNode->next = *list;
    *list = newNode;
}

// Fonction pour rechercher un identifiant
IDFNode* searchIDF(char name[]) {
    IDFNode* current = idfList;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

// Fonction pour rechercher un identifiant
void modifyIDF(char name[],float val) {
    IDFNode* current = idfList;
    while (current != NULL) {
        if (strcmp(current->name,name) == 0) {
            //modify
            current->val = val;
            return;
        }
        current = current->next;
    }
    return;
}

// Fonction pour rechercher un mot clé ou un séparateur
SymbolNode* searchSymbol(SymbolNode* list, char name[]) {
    SymbolNode* current = list;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

// Fonction pour afficher la table des identifiants
void displayIDFTable(IDFNode* idf) {
    printf("/*************** Table des Symboles IDF ***************/\n");
    printf("___________________________________________________________\n");
    printf("| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite\n");
    printf("___________________________________________________________\n");

    IDFNode* current = idf;
    while (current != NULL) {
        printf("|%10s |%15s | %12s | %12f\n", current->name, current->code, current->type, current->val);
        current = current->next;
    }
}

// Fonction pour afficher une table de symboles (mots clés ou séparateurs)
void displaySymbolTable(SymbolNode* list, const char* tableName) {
    printf("\n/********** %s **********/\n", tableName);
    printf("____________________________\n");
    printf("| NomEntite |  Code_Entite |\n");
    printf("____________________________\n");

    SymbolNode* current = list;
    while (current != NULL) {
        printf("|%10s |%12s |\n", current->name, current->code);
        current = current->next;
    }
}
