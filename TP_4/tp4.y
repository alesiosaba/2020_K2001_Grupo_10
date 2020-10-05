%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>

int flag_error=0;
int contador=0;
char* tipoSentencia = NULL;

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
// Estructuras de control
%token TKN_SWITCH
%token TKN_CASE
%token TKN_BREAK
%token TKN_DEFAULT
%token TKN_CONTINUE
%token TKN_DO
%token TKN_WHILE
%token TKN_IF
%token TKN_ELSE
%token TKN_FOR
%token TKN_RETURN
%token TKN_GOTO

%% /* A continuacion las reglas gramaticales y las acciones */

input:    sentencia {printf("Se detecto una sentencia de tipo: %s\n\n",tipoSentencia);} 
;

sentencia:  sentenciaExpresion {tipoSentencia = "expresion";}
          | sentenciaCompuesta {tipoSentencia = "compuesta";}
          | sentenciaDeSeleccion {tipoSentencia = "de seleccion";} 
          | sentenciaDeIteracion {tipoSentencia = "de iteracion";}
          | sentenciaEtiquetada {tipoSentencia = "etiquetada";}
          | sentenciaDeSalto {tipoSentencia = "de salto";}   
;

sentenciaExpresion: /* vacio */ ';' {printf("Se detecto una sentencia vacia\n\n");}
                    | expresion ';'        
;

sentenciaCompuesta:   '{' /* vacio */ '}'
                    | '{' listaDeDeclaraciones '}'
                    | '{' listaDeSentencias '}'
                    | '{' listaDeDeclaraciones listaDeSentencias '}'
;

listaDeDeclaraciones:   declaracion
                      | listaDeDeclaraciones declaracion 
;

declaracion: TIPO_DE_DATO IDENTIFICADOR
;

listaDeSentencias:    sentencia
                    | listaDeSentencias sentencia
;

sentenciaDeSeleccion:   TKN_IF '(' expresion ')' sentencia                    {printf("1.");}
                      | TKN_IF '(' expresion ')' sentencia TKN_ELSE sentencia {printf("2.");}
                      | TKN_SWITCH '(' IDENTIFICADOR ')' sentencia            {printf("3.");}
;

sentenciaDeIteracion:   TKN_WHILE '(' expresion ')' sentencia                           {printf("1.");}
                      | TKN_DO sentencia TKN_WHILE '(' expresion ')' ';'                {printf("2.");}
                      | TKN_FOR '(' ';' ';' ')' sentencia                               {printf("3.");}
                      | TKN_FOR '(' expresion ';' ';' ')' sentencia                     {printf("4.");}
                      | TKN_FOR '(' expresion ';' expresion ';' ')' sentencia           {printf("5.");}
                      | TKN_FOR '(' expresion ';' expresion ';' expresion ')' sentencia {printf("6.");}
;

sentenciaEtiquetada:    TKN_CASE expresionConstante ':' sentencia {printf("1.");}
                      | TKN_DEFAULT ':' sentencia                 {printf("2.");}
                      | IDENTIFICADOR ':' sentencia               {printf("3.");}
; 

sentenciaDeSalto:   TKN_CONTINUE ';'            {printf("1.");}
                  | TKN_BREAK ';'               {printf("2.");}
                  | TKN_RETURN ';'              {printf("3.");}
                  | TKN_RETURN expresion ';'    {printf("4.");}
                  | TKN_GOTO IDENTIFICADOR ';'  {printf("5.");}
;

/*CAMBIAR PARA DESPUES*/
expresion: IDENTIFICADOR '=' ENTERO
           | IDENTIFICADOR
           | IDENTIFICADOR OP_INC
;

expresionConstante: ENTERO
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
