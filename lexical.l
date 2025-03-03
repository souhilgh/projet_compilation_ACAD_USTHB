%{
#include "syntax.tab.h"
#include "symbol_table.h"
#include <stdlib.h>
#include <stdio.h>
int nb_ligne = 1;
int yycol = 1;

extern SymbolNode* keywordList;
extern SymbolNode* separatorList;

%}
%option yylineno

number [0-9]+
letterMin [a-z]
letterMaj [A-Z]
letter {letterMin}|{letterMaj}
idf {letter}({number}|{letterMin}|[_])*

text \'[^\"]*\'
noSignedInteger [1-9][0-9]*

signedInteger \([+-]?[1-9][0-9]*\)
integer {noSignedInteger}|{signedInteger}
float [+/-]?{number}(\.[0-9]+)?
cst {integer}|{float}

%%

"PROGRAM"   {
                insertSymbol(&keywordList, yytext, "MotCle");
                yycol += yyleng; return KW_PROGRAM ;
            }
"VAR"       {
                insertSymbol(&keywordList, yytext, "MotCle");
                yycol += yyleng; return KW_VAR ;
            }
"BEGIN"     {
                insertSymbol(&keywordList, yytext, "MotCle");
                yycol += yyleng; return KW_BEGIN ;
                }
"END"       {
                insertSymbol(&keywordList, yytext, "MotCle");
                yycol += yyleng; return KW_END ;
            }

"TYPE"      {
                insertSymbol(&keywordList, yytext, "MotCle");
                yycol += yyleng; return KW_TYPE ;
            }
"INTEGER"   {insertSymbol(&keywordList, yytext, "MotCle");yycol += yyleng; return KW_INTEGER ;}
"FLOAT"     {insertSymbol(&keywordList, yytext, "MotCle");yycol += yyleng; return KW_FLOAT ;}
"CONST"     {insertSymbol(&keywordList, yytext, "MotCle");yycol += yyleng; return KW_CONST;}

"IF"        {insertSymbol(&keywordList, yytext, "MotCle");yycol += yyleng; return KW_IF;}
"ELSE"      {insertSymbol(&keywordList, yytext, "MotCle");yycol += yyleng; return KW_ELSE;}
"WHILE"     {insertSymbol(&keywordList, yytext, "MotCle");yycol += yyleng; return KW_WHILE;}
"FOR"       {insertSymbol(&keywordList, yytext, "MotCle");yycol += yyleng; return KW_FOR;}

"readln"    {
                insertSymbol(&keywordList, yytext, "MotCle");
                yycol += yyleng; return KW_READLN;
            }
"writeln"   {
                insertSymbol(&keywordList, yytext, "MotCle");
                yycol += yyleng; return KW_WRITELN;
            }

{idf}       {
                if(yyleng+1 > 7){
                    printf("Erreur de definition d'un IDF\n");
                }else{
                    yylval.str = strdup(yytext);
                    yycol += yyleng;
                    return IDENTIFIER;
                }
            }
{noSignedInteger} {yycol += yyleng;
                int val = atoi(yytext);
                if(val >= 0 && val <= 32767){
                    yylval.intVal = val;
                }
                return NOSIGNEDINTEGER;
            }

{signedInteger}   {yycol += yyleng;
                int val = atoi(yytext+1);
                if(val >= -32768 && val <= 32767){
                    yylval.intVal = val;
                    return SIGNEDINTEGER;
                }
            }

{float}     {yycol += yyleng;
             yylval.floatVal = atof(yytext);
             return FLOAT;
            }


{text}      {yycol += yyleng; return TEXT;}

"{"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return OPEN_ACO;}
"}"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return CLOSE_ACO;}
";"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return PVG;}
","         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return VG;}
"."         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return POINT;}
":"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return DPOINT;}

"="         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return ASSIGN;}
"+"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return ADD;}
"-"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return SUB;}
"*"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return MUL;}
"/"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return DIV;}
"("         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return OPEN_BRAC;}
")"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return CLOSE_BRAC;}
"["         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return OPEN_CROCHE;}
"]"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return CLOSE_CROCHE;}

"!"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return NOT;}
"&&"        {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return AND;}
"||"        {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return OR;}
"=="        {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return EQUAL;}
"<="        {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return LESSEQUAL;}
">="        {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return GREATEQUAL;}
"<"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return LESS;}
">"         {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return GREAT;}
"!="        {insertSymbol(&separatorList, yytext, "Separator");yycol += yyleng; return NOTEQUAL;}
"//".*              { /* One ligne comment */ }
"/*"([^*]|\*+[^*/])*\*+"/" { 
                                for(int i = 0;yytext[i] != '\0';i++){
                                    if(yytext[i] == '\n'){
                                        nb_ligne++;
                                    }
                                }
                            }


[ \t]       {yycol += yyleng;}
\n          {nb_ligne++; yycol = 1;}
.           { printf("lexical error in line %d ,Colonne %d: unexpected '%s'\n", nb_ligne,yycol, yytext); }

%%

int yywrap() {
    return 1;
}
