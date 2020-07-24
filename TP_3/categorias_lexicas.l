%option noyywrap

%{
// librerias incluidas    
#include <stdio.h>
#include "funciones_tp3.h"
// variables globales
int cont = 0;
int acum = 0;
%}

DIGITO_DECIMAL [0-9] 
DIGITO_OCTAL [0-7] 
DIGITO_HEXADECIMAL [a-fA-F0-9] 

LETRA [a-zA-Z] 
SUFIJO_REAL [FfLlDd]
SECUENCIA_DE_ESCAPE_SIMPLE (\\\?|\\'|\\\\|\\a|\\b|\\f|\\n|\\r|\\t|\\v)

TIPO_DE_DATO (char|int|float|double|long|short|signed|unsigned|void|enum|struct|typedef|union)
ESTRUCTURA_DE_CONTROL (switch|case|break|default|continue|do|while|if|else|fo|return|goto)
OTRA_PALABRA_RESERVADA (volatile|goto|extern|static|auto|register)

CARACTER_DE_PUNTUACION (;|,|\(|\)|\{|\}|:|\.\.\.)
OPERADOR (\[|\]|\.|->|sizeof|\+\+|--|~|!|-|\+|&|\*|\/|%|<<|>>|<|<=|>|>=|=|==|!=|\+=|-=|\*=|\/=|%=|&=|^=|\|=|>>=|<<=|^|\||&&|\|\||\?:)


%% 
    /*Constante Entera Decimal*/
[1-9]{DIGITO_DECIMAL}*      {printf("Constante entera decimal: %s\n",yytext);}
    /*Constante Entera Octal*/
0{DIGITO_OCTAL}*            {printf("Constante entera octal: %s\n",yytext);}
    /*Constante Entera Hexadecimal*/
0[xX]{DIGITO_HEXADECIMAL}+  {printf("Constante entera hexadecimal: %s\n",yytext);}
    /*Constante Real*/
[\+\-]?{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([eE][\+\-]?{DIGITO_DECIMAL}+)?{SUFIJO_REAL}?|[\+\-]?{DIGITO_DECIMAL}+\.([eE][\+\-]?{DIGITO_DECIMAL}+)?{SUFIJO_REAL}?|[\+\-]?{DIGITO_DECIMAL}+([eE][\+\-]?{DIGITO_DECIMAL}+) {printf("Constante real: %s\n",yytext);}
    /*Constante Caracter*/
'.'                         {printf("Constante caracter: %s\n",yytext);}
    /*Literal Cadena*/
\"([^"\\]|{SECUENCIA_DE_ESCAPE_SIMPLE}|\\{DIGITO_OCTAL}{1,3}|\\x{DIGITO_HEXADECIMAL}{1,2})*\" {printf("Literal cadena: %s\n",yytext);}    
    /*Palabra Reservada*/
{TIPO_DE_DATO}             {printf("Palabra Reservada (tipo de dato): %s\n",yytext);}
{ESTRUCTURA_DE_CONTROL}    {printf("Palabra Reservada (estructura de control): %s\n",yytext);}
{OTRA_PALABRA_RESERVADA} {printf("Palabra Reservada (otra palabra reservada): %s\n",yytext);}
    /*Operador*/
{OPERADOR} {printf("Operador: %s\n",yytext);}
    /*Identificador (Algun operador entra en identificadores)*/
({LETRA}|_)({LETRA}|{DIGITO_DECIMAL}|_)* {printf("Identificador: %s\n",yytext);}
    /*Caracter de Puntuación*/
{CARACTER_DE_PUNTUACION}    {printf("Caracter de puntuacion: %s\n",yytext);}
    /*Comentario de multiples lineas*/
\/\*.*\*\/   {printf("Comentario de multiples lineas: %s\n",yytext);}
    /*Comentario de una linea*/
\/\/.*\n   {printf("Comentario de una linea: %s\n",yytext);}
    /*Directivas de precompilador*/
#.*\n      {printf("Directiva de precompilador: %s\n",yytext);}
    /*Caracter no identificado*/
. {printf("Caracter no identificado: %s\n",yytext);}    
    /*Cadena de caracteres no identificados
.* {printf("Cadena de caracteres no identificados: %s\n",yytext);}*/

%%

int main(){
    /* Acciones previas a la invocación den analizador léxico */
    yyin = fopen("archivo.c","r");
 
    /* Invocación del analizador léxico */
    yylex();

    /* Acciones posteriores a la ejecución del analizador léxico */
    /* Mandar data al archivo de reporte */
    return 0;
}