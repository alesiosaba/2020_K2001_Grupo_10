%option noyywrap

%{
// librerias incluidas    
#include <stdio.h>
#include "funciones_tp3.h"

// variables globales
int acum = 0;
%}

DIGITO_DECIMAL [0-9] 
DIGITO_OCTAL [0-7] 
DIGITO_HEXADECIMAL [a-fA-F0-9] 
LETRA [a-zA-Z] 
SUFIJO_REAL [FfLlDd]

TIPOS_DE_DATO [char,int,float,double,long,short,signed,unsigned,void,enum ,struct,typedef,union]
ESTRUCTURAS_DE_CONTROL [switch,case,break,default,continue,do,while,if,else,fo,return,goto]
OTRAS_PALABRAS_RESERVADAS [volatile, goto,extern,static,auto,register]

-- Secuencias de escape
SECUENCIA_DE_ESCAPE_SIMPLE          [\'\"\?\\\a\b\f\n\r\t\v]        (\'|\"|\?|\\|\a|\b|\f|\n|\r|\t|\v)
SECUENCIA_DE_ESCAPE_OCTAL           \[0-7]{1,3}
SECUENCIA_DE_ESCAPE_HEXADECIMAL     \x[a-fA-F0-9]{1,2}

CARACTERES_DE_PUNTUACION (;|,|(|){|})
OPERADORES (++|*|&|!|sizeof|/|%|<|<=|>|>=|==|!=|&&| || |?|:|=|+=|-=|/=)

%%

Constante Entera decimal
[1-9]{DIGITO_DECIMAL}* {}

Constante entera octal
0{DIGITO_OCTAL}* {}

Constante entera hexadecimal
0[xX]{DIGITO_HEXADECIMAL}+ {}

Constante real 
{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([eE][\+\-]?{DIGITO_DECIMAL}+)?{SUFIJO_REAL}?|{DIGITO_DECIMAL}+\.([eE][\+\-]?{DIGITO_DECIMAL}+)?{SUFIJO_REAL}?|{DIGITO_DECIMAL}+([eE][\+\-]?{DIGITO_DECIMAL}+) {}

Constante caracter
\'.\' {}

Literal cadena
\"([^\"]|{SECUENCIA_DE_ESCAPE_SIMPLE}|{SECUENCIA_DE_ESCAPE_OCTAL}|{SECUENCIA_DE_ESCAPE_HEXADECIMAL})*\" {}

Palabras reservadas
{TIPOS_DE_DATO} {}
{ESTRUCTURAS_DE_CONTROL} {}
{OTRAS_PALABRAS_RESERVADAS} {}

Identificadores
({LETRA}|_)({LETRA}|{DIGITO_DECIMAL}|_)* {}

Caracteres de puntuación y operadores de C
{CARACTERES_DE_PUNTUACION}
{OPERADORES}

Comentarios (en realidad son reconocidos por el PRECOMPILADOR)
Comentarios de una línea
\/\/[.]*

NuevaLinea
\\n {}

Comentarios de múltiples líneas
\/*[^]**\/
Desafío opcional: Adicionar al analizador léxico el reconocimiento de las directivas del
precompilador #Include #Define.

%%

int main(){
    /* Acciones previas a la invocación den analizador léxico */
    yyin = fopen("archivo.c","r");
    yyout = 

    /* Invocación del analizador léxico */
    yylex();

    /* Acciones posteriores a la ejecución del analizador léxico */
    /* Mandar data al archivo de reporte */
    return 0;
}