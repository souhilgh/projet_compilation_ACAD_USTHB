#include "quad.h"
#include <string.h> 
#include "symbol_table.h"


Quad quad[1000]; 
int quadIndex = 0; 

Var var[100];
int varIndex = 0;

int searchVar(char* varName){
    for(int i = 0; i < varIndex ; i++){
        if(strcmp(varName,var[i].name) == 0){
            return i;
        }
    }
    return -1;
}

void addQuad(char* operator, char* operand1, char* operand2, char* result) {
    if (quadIndex >= 100) {
        printf("Erreur : La table des quadruplés est pleine.\n");
        return;
    }
    strcpy(quad[quadIndex].operator, operator);
    strcpy(quad[quadIndex].operand1 , operand1);
    strcpy(quad[quadIndex].operand2 , operand2);
    strcpy(quad[quadIndex].result , result);

    quadIndex++;
}

char* ftos(float value) {
    char* result = malloc(50 * sizeof(char));if (result == NULL) {
        printf("Memory allocation failed\n");
        exit(1);
    }
    snprintf(result, 50, "%.2f", value); 
    return result;
}

void traiterQuad(){
    for(int i = 0 ; i<quadIndex; i++){
        if(strcmp(quad[i].operator,"=") == 0){
            IDFNode* idf = NULL;
            idf = searchIDF(quad[i].result);

            int ind =  searchVar(quad[i].operand1);
            
            float f = var[ind].val;

            modifyIDF(quad[i].result,f);
        }/*else if(strcmp(quad[i].operator,"*") == 0){
            int ind1 = searchVar(quad[i].operand1);
            int ind2 = searchVar(quad[i].operand2);
            int ind3 = searchVar(quad[i].result);
            var[ind3].val = var[ind1].val * var[ind2].val;
            
        }else if(strcmp(quad[i].operator,"/") == 0){
            int ind1 = searchVar(quad[i].operand1);
            int ind2 = searchVar(quad[i].operand2);
            int ind3 = searchVar(quad[i].result);
            var[ind3].val = var[ind1].val / var[ind2].val;
            
        }else if(strcmp(quad[i].operator,"+") == 0){
            int ind1 = searchVar(quad[i].operand1);
            int ind2 = searchVar(quad[i].operand2);
            int ind3 = searchVar(quad[i].result);
            var[ind3].val = var[ind1].val + var[ind2].val;

        }else if(strcmp(quad[i].operator,"-") == 0){
            int ind1 = searchVar(quad[i].operand1);
            int ind2 = searchVar(quad[i].operand2);
            int ind3 = searchVar(quad[i].result);
            var[ind3].val = var[ind1].val - var[ind2].val;

        }else if(strcmp(quad[i].operator,"==") == 0){
            int ind1 = searchVar(quad[i].operand1);
            int ind2 = searchVar(quad[i].operand2);
            
            if(var[ind1].val == var[ind2].val){
                //jump to etiquette
            }

        }else if(strcmp(quad[i].operator,"!=") == 0){
            int ind1 = searchVar(quad[i].operand1);
            int ind2 = searchVar(quad[i].operand2);
            
            if(var[ind1].val != var[ind2].val){
                //jump to etiquette
            }
        }else if(strcmp(quad[i].operator,"<") == 0){
            int ind1 = searchVar(quad[i].operand1);
            int ind2 = searchVar(quad[i].operand2);
            
            if(var[ind1].val < var[ind2].val){
                //jump to etiquette
            }
        }else if(strcmp(quad[i].operator,">") == 0){
            int ind1 = searchVar(quad[i].operand1);
            int ind2 = searchVar(quad[i].operand2);
            
            if(var[ind1].val > var[ind2].val){
                //jump to etiquette
            }
        }else if(strcmp(quad[i].operator,"<=") == 0){
            int ind1 = searchVar(quad[i].operand1);
            int ind2 = searchVar(quad[i].operand2);
            
            if(var[ind1].val <= var[ind2].val){
                //jump to etiquette
            }
        }else if(strcmp(quad[i].operator,">=") == 0){
            int ind1 = searchVar(quad[i].operand1);
            int ind2 = searchVar(quad[i].operand2);
            
            if(var[ind1].val >= var[ind2].val){
                //jump to etiquette
            }
        }*/
    }
}

void displayQuad(){
    printf("----Quadruples----\n");
    for(int i = 0;i<quadIndex;i++){
        printf("%d.(%s,%s,%s,%s)\n",i+1,
                            quad[i].operator
                            ,quad[i].operand1
                            ,quad[i].operand2
                            ,quad[i].result
                            );
    }
}
