%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>

int flag_error=0;
int contador=0;

FILE* yyin;
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
// Operadores (no unarios)
%token OP_ACCESO_ATRIBUTO
%token OP_SIZEOF
%token OP_INC
%token OP_DEC
%token OP_DESPLAZAMIENTO_IZQ
%token OP_DESPLAZAMIENTO_DER
%token OP_MENOR_IGUAL
%token OP_MAYOR_IGUAL
%token OP_IGUALDAD
%token OP_DESIGUALDAD
%token OP_ASIG_SUMA
%token OP_ASIG_RESTA
%token OP_ASIG_MULTIPLICACION
%token OP_ASIG_DIVISION
%token OP_ASIG_RESTO
%token OP_ASIG_AND_BIT
%token OP_ASIG_POTENCIA
%token OP_ASIG_OR_BIT
%token OP_ASIG_DESPLAZAMIENTO_IZQ
%token OP_ASIG_DESPLAZAMIENTO_DER
%token OP_OR
%token OP_AND
%token OP_CONDICIONAL
%token OP_PARAMETROS_MULTIPLES 

%% /* A continuacion las reglas gramaticales y las acciones */

input:    TIPO_DE_DATO IDENTIFICADOR {printf("%s %s",$<strval>1,$<strval>2);} 
;


%%

/* Llamada por yyparse ante un error 
int  yyerror(char *s){
    printf("Error %s",s);
}
*/

int main(){
  yyin = fopen("archivo.c","r");

  #ifdef BISON_DEBUG
    yydebug = 1;
  #endif

  yyparse();
}
