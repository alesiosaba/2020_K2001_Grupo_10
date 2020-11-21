%option noyywrap
%option yylineno

%{
// librerias incluidas    
#include <stdio.h>
#include <stdlib.h> 
#include <string.h>
#include "TP5.tab.h"    // archivo generado por BISON
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
[1-9]{DIGITO_DECIMAL}*      {yylval.ival = atoi(yytext); return ENTERO;}
    /*Constante Entera Octal*/
0{DIGITO_OCTAL}*            {yylval.ival = strtol(yytext,NULL,0); return ENTERO;}
    /*Constante Entera Hexadecimal*/
0[xX]{DIGITO_HEXADECIMAL}+  {yylval.ival = strtol(yytext,NULL,0); return ENTERO;}
    /*Constante Real*/
[\+\-]?{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([eE][\+\-]?{DIGITO_DECIMAL}+)?{SUFIJO_REAL}?|[\+\-]?{DIGITO_DECIMAL}+\.([eE][\+\-]?{DIGITO_DECIMAL}+)?{SUFIJO_REAL}?|[\+\-]?{DIGITO_DECIMAL}+([eE][\+\-]?{DIGITO_DECIMAL}+) {yylval.dval = atof(yytext); return NUM;}
    /*Constante Caracter*/
'([^'\\]|{SECUENCIA_DE_ESCAPE_SIMPLE}|\\{DIGITO_OCTAL}{1,3}|\\x{DIGITO_HEXADECIMAL}{1,2})*' {yylval.strval = strdup(yytext); return CONST_CARACTER;}
    /*Literal Cadena*/
\"([^"\\]|{SECUENCIA_DE_ESCAPE_SIMPLE}|\\{DIGITO_OCTAL}{1,3}|\\x{DIGITO_HEXADECIMAL}{1,2})*\" {yylval.strval = strdup(yytext); return LITERAL_CADENA;}    
    /*Palabra Reservada*/
{TIPO_DE_DATO}             {yylval.strval = strdup(yytext); return TIPO_DE_DATO;}
    /* Void */
"void"          {return TKN_VOID;}

    /*  Estructura de control */
"switch"        {return TKN_SWITCH;}
"case"          {return TKN_CASE;}
"break"         {return TKN_BREAK;}
"default"       {return TKN_DEFAULT;}
"continue"      {return TKN_CONTINUE;}
"do"            {return TKN_DO;}
"while"         {return TKN_WHILE;}
"if"            {return TKN_IF;}
"else"          {return TKN_ELSE;}
"for"           {return TKN_FOR;}
"return"        {return TKN_RETURN;}
"goto"          {return TKN_GOTO;}



"volatile"      {return TKN_VOLATILE;}
"const"         {return TKN_CONST;}
"struct"        {return TKN_STRUCT;}
"union"         {return TKN_UNION;}
"enum"          {return TKN_ENUM;}

    /*Operador*/
"["         {return '[';}
"]"         {return ']';}
"."         {return '.';}
"->"        {return OP_ACCESO_ATRIBUTO;}
"sizeof"    {return OP_SIZEOF;}
"++"        {return OP_INC;}
"--"        {return OP_DEC;}
"~"         {return '~';}
"!"         {return '!';}
"-"         {return '-';}
"+"         {return '+';}
"&"         {return '&';}
"*"         {return '*';}
"/"         {return '/';}
"%"         {return OP_PORCENTAJE;}
"<<"        {return OP_DESPLAZAMIENTO_IZQ;}      
">>"        {return OP_DESPLAZAMIENTO_DER;}      
"<"         {return '<';}
">"         {return '>';}
"<="        {return OP_MENOR_IGUAL;}
">="        {return OP_MAYOR_IGUAL;}
"="         {return '=';}
"=="        {return OP_IGUALDAD;}
"!="        {return OP_DESIGUALDAD;}
"+="        {return OP_ASIG_SUMA;}
"-="        {return OP_ASIG_RESTA;}
"*="        {return OP_ASIG_MULTIPLICACION;}
"/="        {return OP_ASIG_DIVISION;}
"%="        {return OP_ASIG_RESTO;}
"^="        {return OP_ASIG_POTENCIA;}             
"^"         {return '^';}
"|"         {return '|';}
"||"        {return OP_OR;}
"&&"        {return OP_AND;}
"?"         {return '?';}

    /*Identificador*/
({LETRA}|_)({LETRA}|{DIGITO_DECIMAL}|_)* {yylval.strval = strdup(yytext); return IDENTIFICADOR;} 
    /*Caracter de Puntuación*/
";"     {return ';';}
","     {return ',';}
"("     {return '(';}
")"     {return ')';}
"{"     {return '{';}
"}"     {return '}';}
":"     {return ':';}
"..."   {return OP_PARAMETROS_MULTIPLES;}

    /*Espacio*/
" "  {}

    /*Salto de linea*/
"\n"    {return '\n';}

    /*Caracteres no reconocidos*/
.      {printf("ERROR LEXICO: %s en la linea n: %d\n\n",yytext,yylineno);}

%%