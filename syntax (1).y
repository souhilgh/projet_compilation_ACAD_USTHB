%{
#include <stdio.h>
#include <stdlib.h>
#include "symbol_table.h"
#include "quad.h"
extern int yylex(); 
extern int yylineno; 
extern int yycol; 
void yyerror(const char *s);

extern IDFNode* idfList;
IDFNode* idf = NULL;
IDFNode* idf2 = NULL;
extern SymbolNode* keywordList;
extern SymbolNode* separatorList;

extern int quadIndex;


extern Var var[100];
extern int varIndex;

%}
%locations

%token KW_PROGRAM KW_VAR KW_BEGIN KW_END

%token KW_TYPE KW_FLOAT KW_CONST KW_INTEGER
%token KW_IF KW_ELSE KW_FOR KW_WHILE
%token PVG VG OPEN_ACO CLOSE_ACO POINT DPOINT
%token ASSIGN ADD SUB MUL DIV OPEN_BRAC CLOSE_BRAC OPEN_CROCHE CLOSE_CROCHE
%token EQUAL NOTEQUAL LESS LESSEQUAL GREAT GREATEQUAL
%token KW_READLN KW_WRITELN TEXT
%token OR AND

%union {
    char *str;
    char chr;
    int intVal;
    float floatVal;
}

%token <str> IDENTIFIER
%token <intVal> SIGNEDINTEGER NOSIGNEDINTEGER
%token <floatVal> FLOAT

%type <str> expressionArithm expressionLogique expressionCompar
%type <floatVal> operand

%left OR
%left AND
%right NOT

%nonassoc EQUAL NOTEQUAL LESS LESSEQUAL GREAT GREATEQUAL

%left ADD SUB
%left MUL DIV
%nonassoc OPEN_BRAC CLOSE_BRAC
%right ASSIGN

%start program

%%
integer:   
    SIGNEDINTEGER
    |NOSIGNEDINTEGER
;

program:
    KW_PROGRAM IDENTIFIER variableDeclarationBlock codeBlock
    {
        idf = searchIDF($2);
        if (idf != NULL) { 
            printf("Erreur : le programme '%s' existe deja.\n", $2);
        } else {
            insertIDF($2, "PROGRAM", "global", 0.0);
        }
        displayQuad();
        traiterQuad();
        displayIDFTable(idfList);
        displaySymbolTable(keywordList, "Keyword");
        displaySymbolTable(separatorList, "Separator");
        YYACCEPT;
    }
;
variableDeclarationBlock:
    |KW_VAR OPEN_ACO variableList CLOSE_ACO
;
variableList:
    /*Epsilon*/
    |variableDeclaration variableList
    |KW_CONST constantList PVG variableList
;

constantList:
    constant
    |constant VG constantList

constant:
    IDENTIFIER ASSIGN SIGNEDINTEGER
    {
        idf = searchIDF($1);
        if (idf != NULL) { 
            printf("Erreur : IDF %s Existe.\n", $1);
            exit(1);
        } else {
            insertIDF($1, "CONST", "INTEGER", $3);
        }
    }
    |IDENTIFIER ASSIGN NOSIGNEDINTEGER
    {
        idf = searchIDF($1);
        if (idf != NULL) { 
            printf("Erreur : IDF %s Existe.\n", $1);
            exit(1);
        } else {
            insertIDF($1, "CONST", "INTEGER", $3);
        }
    }
    |IDENTIFIER ASSIGN FLOAT
    {
        idf = searchIDF($1);
        if (idfList != NULL) { 
            printf("Erreur : IDF %s Existe.\n", $1);
            exit(1);
        } else {
            insertIDF($1, "CONST", "FLOAT", $3);
        }
    }
;
variableDeclaration:
    KW_INTEGER integerList PVG
    | KW_FLOAT floatList PVG
;
integerList:
    integerDeclaration
    |integerDeclaration VG integerList
;
integerDeclaration:
    IDENTIFIER
    {
        idf = searchIDF($1);
        if (idf != NULL) { 
            printf("Erreur : IDF %s Existe.\n", $1);
            exit(1);
        } else {
            insertIDF($1, "VAR", "INTEGER", 0.0);
        }
    }
    | IDENTIFIER ASSIGN SIGNEDINTEGER
    {
        idf = searchIDF($1);
        if (idf != NULL) { 
            printf("Erreur : IDF %s Existe.\n", $1);
            exit(1);
        } else {
            insertIDF($1, "VAR", "INTEGER", $3);
        }
    }
    | IDENTIFIER ASSIGN NOSIGNEDINTEGER
    {
        idf = searchIDF($1);
        if (idf != NULL) { 
            printf("Erreur : IDF %s Existe.\n", $1);
            exit(1);
        } else {
            insertIDF($1, "VAR", "INTEGER", $3);
        }
    }
    | IDENTIFIER OPEN_CROCHE NOSIGNEDINTEGER CLOSE_CROCHE
;

floatList:
    floatDeclaration
    |floatDeclaration floatList
;
floatDeclaration:
    IDENTIFIER
    {
        idf = searchIDF($1);
        if (idf != NULL) { 
            printf("Erreur : IDF %s Existe.\n", $1);
            exit(1);
        } else {
            insertIDF($1, "VAR", "FLOAT", 0);
        }
    }
    | IDENTIFIER ASSIGN FLOAT
    {
        idf = searchIDF($1);
        if (idf != NULL) { 
            printf("Erreur : IDF %s Existe.\n", $1);
            exit(1);
        } else {
            insertIDF($1, "VAR", "FLOAT", $3);
        }
    }
    | IDENTIFIER OPEN_CROCHE NOSIGNEDINTEGER CLOSE_CROCHE
;

codeBlock:
    KW_BEGIN instructions KW_END POINT
;

instructions:
    /* Epsilon */
    |assignement instructions
    |ifElse instructions
    |forLoop instructions
    |whileLoop instructions
    |readln instructions
    |writeln instructions
;

assignement:
    IDENTIFIER ASSIGN expressionArithm PVG
    {
        idf = searchIDF($1);
        if (idf == NULL) { 
            printf("IDF %s DSNT Existe.\n", $1);
            exit(1);
        }
        addQuad("=",$3,"",$1);
    }
    | IDENTIFIER OPEN_CROCHE NOSIGNEDINTEGER CLOSE_CROCHE ASSIGN expressionArithm PVG
    
;
expressionArithm:
    operand 
    {
        $$ = ftos($1);//string
    }
    | OPEN_BRAC expressionArithm CLOSE_BRAC
    {
        $$ = $2; 
    }
    | expressionArithm MUL expressionArithm
    {

        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("*",$1 , $3, var[varIndex].name);

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
    | expressionArithm DIV expressionArithm
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("/",$1 , $3, var[varIndex].name);

        $$ = var[varIndex].name;

        varIndex ++ ;

    }
    | expressionArithm ADD expressionArithm
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("+",$1 , $3, var[varIndex].name);

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
    | expressionArithm SUB expressionArithm
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("-",$1 , $3, var[varIndex].name);

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
;


operand:
    SIGNEDINTEGER { $$ = $1; }
    | FLOAT  { $$ = $1; }
    | NOSIGNEDINTEGER {
        
        $$ = $1;
    }
    | IDENTIFIER
    {
        idf = searchIDF($1);
        if (idf == NULL) {
            printf("Erreur : L'identifiant '%s' n'existe pas.\n", $1);
            exit(1); 
        } else {
            $$ = idf->val;
        }
    }
    | IDENTIFIER OPEN_CROCHE NOSIGNEDINTEGER CLOSE_CROCHE
    { }
;



ifElse:
    KW_IF OPEN_BRAC expressionLogique CLOSE_BRAC OPEN_ACO instructions CLOSE_ACO elseCondition
;
elseCondition:
    |KW_ELSE OPEN_ACO instructions CLOSE_ACO
;
expressionLogique:
    OPEN_BRAC expressionLogique CLOSE_BRAC
    { $$ = $2 ;}
    | NOT expressionLogique
    { 
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("!",$2 , "", var[varIndex].name);

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
    | expressionLogique AND expressionLogique
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("&&",$1 , $3, var[varIndex].name);

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
    | expressionLogique OR expressionLogique
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("||",$1 , $3, var[varIndex].name);

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
	| expressionCompar
    {
        $$ = $1;
    }
;

expressionCompar:
    expressionArithm EQUAL expressionArithm
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("==",$1 , $3, "Etiq");

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
    |expressionArithm LESSEQUAL expressionArithm
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("<=",$1 , $3, "Etiq");

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
    |expressionArithm GREATEQUAL expressionArithm
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad(">=",$1 , $3, "Etiq");

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
    |expressionArithm LESS expressionArithm
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("<",$1 , $3, "Etiq");

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
    |expressionArithm GREAT expressionArithm
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad(">",$1 , $3, "Etiq");

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
    |expressionArithm NOTEQUAL expressionArithm
    {
        sprintf(var[varIndex].name,"V%d",varIndex);

        addQuad("!=",$1 , $3, "Etiq");

        $$ = var[varIndex].name;

        varIndex ++ ;
    }
;


whileLoop:
    KW_WHILE OPEN_BRAC expressionLogique CLOSE_BRAC OPEN_ACO instructions CLOSE_ACO
;

forLoop:
    KW_FOR OPEN_BRAC forCondition CLOSE_BRAC OPEN_ACO instructions CLOSE_ACO
;
forCondition:
    IDENTIFIER DPOINT integer DPOINT NOSIGNEDINTEGER DPOINT expressionLogique
;

readln:
    KW_READLN OPEN_BRAC IDENTIFIER CLOSE_BRAC PVG
    |KW_READLN OPEN_BRAC IDENTIFIER OPEN_CROCHE NOSIGNEDINTEGER CLOSE_CROCHE CLOSE_BRAC PVG
;
writeln:
    KW_WRITELN OPEN_BRAC write CLOSE_BRAC PVG
;
write:
    /* Epsilon */
    |TEXT write
    |IDENTIFIER write
    |integer write
    |FLOAT write
    |IDENTIFIER OPEN_BRAC NOSIGNEDINTEGER CLOSE_CROCHE write
;


%%
void yyerror(const char *s) {
    fprintf(stderr, "Syntax error at line %d :%s\n", yylineno,s);
}

int main() {
    return yyparse();
}
