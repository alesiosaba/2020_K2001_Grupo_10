%option noyywrap
%option yylineno

%{
// librerias incluidas    
#include <stdio.h>
#include <stdlib.h> 
#include <string.h>
#include "TP5.tab.h"    // archivo generado por BISON
#include "caracteresNoReconocidos.h"
#include <windows.h>

%}

DIGITO_DECIMAL [0-9] 
DIGITO_OCTAL [0-7] 
DIGITO_HEXADECIMAL [a-fA-F0-9] 

LETRA [a-zA-Z] 
SUFIJO_REAL [FfLlDd]
SECUENCIA_DE_ESCAPE_SIMPLE (\\\?|\\'|\\\\|\\a|\\b|\\f|\\r|\\t|\\v)

TIPO_DE_DATO (char|int|float|double|long|short)
ESTRUCTURA_DE_CONTROL (switch|case|break|default|continue|do|while|if|else|for|return)
CLASE_ALMACENAMIENTO (typedef|static|auto|register|extern)

CARACTER_DE_PUNTUACION (;|,|\(|\)|\{|\}|:|\.\.\.)
OPERADOR (\[|\]|\.|->|sizeof|\+\+|--|~|!|-|\+|&|\*|\/|%|<<|>>|<|<=|>|>=|=|==|!=|\+=|-=|\*=|\/=|%=|&=|^=|\|=|>>=|<<=|^|\||&&|\|\||\?:)


%%  
    /*Constante Entera Decimal*/        
[1-9]{DIGITO_DECIMAL}*      {cadenaErrorLexico = 0; yylval.ival = atoi(yytext); return ENTERO;}
    /*Constante Entera Octal*/
0{DIGITO_OCTAL}*            {cadenaErrorLexico = 0; yylval.ival = strtol(yytext,NULL,0); return ENTERO;}
    /*Constante Entera Hexadecimal*/
0[xX]{DIGITO_HEXADECIMAL}+  {cadenaErrorLexico = 0; yylval.ival = strtol(yytext,NULL,0); return ENTERO;}
    /*Constante Real*/
[\+\-]?{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([eE][\+\-]?{DIGITO_DECIMAL}+)?{SUFIJO_REAL}?|[\+\-]?{DIGITO_DECIMAL}+\.([eE][\+\-]?{DIGITO_DECIMAL}+)?{SUFIJO_REAL}?|[\+\-]?{DIGITO_DECIMAL}+([eE][\+\-]?{DIGITO_DECIMAL}+) {cadenaErrorLexico = 0; yylval.dval = atof(yytext); return NUM;}
    /*Constante Caracter*/
'([^'\\]|{SECUENCIA_DE_ESCAPE_SIMPLE}|\\{DIGITO_OCTAL}{1,3}|\\x{DIGITO_HEXADECIMAL}{1,2})*' {cadenaErrorLexico = 0; yylval.strval = strdup(yytext); return CONST_CARACTER;}
    /*Literal Cadena*/
\"([^"\\]|{SECUENCIA_DE_ESCAPE_SIMPLE}|\\{DIGITO_OCTAL}{1,3}|\\x{DIGITO_HEXADECIMAL}{1,2})*\" {cadenaErrorLexico = 0; yylval.strval = strdup(yytext); return LITERAL_CADENA;}    
    /*Palabra Reservada*/
{TIPO_DE_DATO}             {cadenaErrorLexico = 0; yylval.strval = strdup(yytext); return TIPO_DE_DATO;}
    /* Void */
"void"          {cadenaErrorLexico = 0; return TKN_VOID;}

    /*  Estructura de control */
"switch"        {cadenaErrorLexico = 0; return TKN_SWITCH;}
"case"          {cadenaErrorLexico = 0; return TKN_CASE;}
"break"         {cadenaErrorLexico = 0; return TKN_BREAK;}
"default"       {cadenaErrorLexico = 0; return TKN_DEFAULT;}
"continue"      {cadenaErrorLexico = 0; return TKN_CONTINUE;}
"do"            {cadenaErrorLexico = 0; return TKN_DO;}
"while"         {cadenaErrorLexico = 0; return TKN_WHILE;}
"if"            {cadenaErrorLexico = 0; return TKN_IF;}
"else"          {cadenaErrorLexico = 0; return TKN_ELSE;}
"for"           {cadenaErrorLexico = 0; return TKN_FOR;}
"return"        {cadenaErrorLexico = 0; return TKN_RETURN;}
"goto"          {cadenaErrorLexico = 0; return TKN_GOTO;}



"volatile"      {cadenaErrorLexico = 0; return TKN_VOLATILE;}
"const"         {cadenaErrorLexico = 0; return TKN_CONST;}
"struct"        {cadenaErrorLexico = 0; return TKN_STRUCT;}
"union"         {cadenaErrorLexico = 0; return TKN_UNION;}
"enum"          {cadenaErrorLexico = 0; return TKN_ENUM;}

    /*Operador*/
"["         {cadenaErrorLexico = 0; return '[';}
"]"         {cadenaErrorLexico = 0; return ']';}
"."         {cadenaErrorLexico = 0; return '.';}
"->"        {cadenaErrorLexico = 0; return OP_ACCESO_ATRIBUTO; }
"sizeof"    {cadenaErrorLexico = 0; return OP_SIZEOF;}
"++"        {cadenaErrorLexico = 0; return OP_INC;}
"--"        {cadenaErrorLexico = 0; return OP_DEC;}
"~"         {cadenaErrorLexico = 0; return '~';}
"!"         {cadenaErrorLexico = 0; return '!';}
"-"         {cadenaErrorLexico = 0; return '-';}
"+"         {cadenaErrorLexico = 0; return '+';}
"&"         {cadenaErrorLexico = 0; return '&';}
"*"         {cadenaErrorLexico = 0; return '*';}
"/"         {cadenaErrorLexico = 0; return '/';}
"%"         {cadenaErrorLexico = 0; return OP_PORCENTAJE;}
"<<"        {cadenaErrorLexico = 0; return OP_DESPLAZAMIENTO_IZQ;}      
">>"        {cadenaErrorLexico = 0; return OP_DESPLAZAMIENTO_DER;}      
"<"         {cadenaErrorLexico = 0; return '<';}
">"         {cadenaErrorLexico = 0; return '>';}
"<="        {cadenaErrorLexico = 0; return OP_MENOR_IGUAL;}
">="        {cadenaErrorLexico = 0; return OP_MAYOR_IGUAL;}
"="         {cadenaErrorLexico = 0; return '=';}
"=="        {cadenaErrorLexico = 0; return OP_IGUALDAD;}
"!="        {cadenaErrorLexico = 0; return OP_DESIGUALDAD;}
"+="        {cadenaErrorLexico = 0; return OP_ASIG_SUMA;}
"-="        {cadenaErrorLexico = 0; return OP_ASIG_RESTA; }
"*="        {cadenaErrorLexico = 0; return OP_ASIG_MULTIPLICACION; }
"/="        {cadenaErrorLexico = 0; return OP_ASIG_DIVISION; }
"%="        {cadenaErrorLexico = 0; return OP_ASIG_RESTO; }
"^="        {cadenaErrorLexico = 0; return OP_ASIG_POTENCIA; }             
"^"         {cadenaErrorLexico = 0; return '^'; }
"|"         {cadenaErrorLexico = 0; return '|'; }
"||"        {cadenaErrorLexico = 0; return OP_OR; }
"&&"        {cadenaErrorLexico = 0; return OP_AND; }
"?"         {cadenaErrorLexico = 0; return '?'; }

    /*Identificador*/
({LETRA}|_)({LETRA}|{DIGITO_DECIMAL}|_)* {cadenaErrorLexico = 0; yylval.strval = strdup(yytext); return IDENTIFICADOR;} 
    /*Caracter de Puntuación*/
";"     {cadenaErrorLexico = 0; return ';'; }
","     {cadenaErrorLexico = 0; return ','; }
"("     {cadenaErrorLexico = 0; return '('; }
")"     {cadenaErrorLexico = 0; return ')'; }
"{"     {cadenaErrorLexico = 0; return '{'; }
"}"     {cadenaErrorLexico = 0; return '}'; }
":"     {cadenaErrorLexico = 0; return ':'; }
"..."   {cadenaErrorLexico = 0; return OP_PARAMETROS_MULTIPLES;}

    /*Espacio*/
" "  {}

    /*Salto de linea*/
"\n"         {cadenaErrorLexico = 0; return '\n';}

    /*ignorar comentarios*/
"//"(.*)/"\n"        {cadenaErrorLexico = 0;}

    /*Caracteres no reconocidos*/
.           {printf("ENTRE CON %s\n",yytext); caracNoReconocidos(yytext,yylineno); }

%%