%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>

int flag_error=0;
int contador=0;

int yylex();
int yyerror (char *s);
int yywrap(){
    return(1);
}

%}

%union
{
    int ival; 
    double dval;
    char* strval;
}

// axioma
%start input

// Constantes enteras (decimales,octales,hexadecimales)
%token <ival> ENTERO              
// Constantes reales
%token <dval> NUM                 
// Constantes Caracter 
%token <strval> CONST_CARACTER    
// Literales Cadena 
%token <strval> LITERAL_CADENA    
// Palabras Reservadas
%token <strval> TIPO_DE_DATO 
%token <strval> ESTRUCTURA_DE_CONTROL
%token <strval> OTRA_PALABRA_RESERVADA
// Identificadores
%token <strval> IDENTIFICADOR     
// Cadenas de NO reconocidos
%token <strval> CARAC_NO_RECONOCIDO

// %type <real> input

// %left TKN_MAS TKN_MENOS
// %left TKN_MULT TKN_DIV

%% /* A continuacion las reglas gramaticales y las acciones */

input:    /* vacio */
        | "int" IDENTIFICADOR {printf("%s",$<strval>2);}
;

%%

/* Llamada por yyparse ante un error */
int  yyerror(char *s){
    printf("Error %s",s);
}


int main(){
  yyin = fopen("archivo.c","r");

  #ifdef BISON_DEBUG
    yydebug = 1;
  #endif

  yyparse();
}
