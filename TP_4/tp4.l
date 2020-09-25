%option noyywrap
%option yylineno

%{
// librerias incluidas    
#include <stdio.h>
#include <stdlib.h> 
#include "tp4.tab.h"    // archivo generado por BISON
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
[1-9]{DIGITO_DECIMAL}*      {yylval.ival = atoi(yytext); return ENTERO;}
    /*Constante Entera Octal*/
0{DIGITO_OCTAL}*            {yylval.ival = strtol(yytext,NULL,0); return ENTERO;}
    /*Constante Entera Hexadecimal*/
0[xX]{DIGITO_HEXADECIMAL}+  {yylval.ival = strtol(yytext,NULL,0); return ENTERO;}
    /*Constante Real*/
[\+\-]?{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([eE][\+\-]?{DIGITO_DECIMAL}+)?{SUFIJO_REAL}?|[\+\-]?{DIGITO_DECIMAL}+\.([eE][\+\-]?{DIGITO_DECIMAL}+)?{SUFIJO_REAL}?|[\+\-]?{DIGITO_DECIMAL}+([eE][\+\-]?{DIGITO_DECIMAL}+) {yylval.dval = atof(yytext); return NUM;}
    /*Constante Caracter*/
'([^'\\]|{SECUENCIA_DE_ESCAPE_SIMPLE}|\\{DIGITO_OCTAL}{1,3}|\\x{DIGITO_HEXADECIMAL}{1,2})*' {yylval.strval = yytext; return CONST_CARACTER;}
    /*Literal Cadena*/
\"([^"\\]|{SECUENCIA_DE_ESCAPE_SIMPLE}|\\{DIGITO_OCTAL}{1,3}|\\x{DIGITO_HEXADECIMAL}{1,2})*\" {yylval.strval = yytext; return LITERAL_CADENA;}    
    /*Palabra Reservada*/
{TIPO_DE_DATO}             {yylval.strval = yytext; return TIPO_DE_DATO;}
{ESTRUCTURA_DE_CONTROL}    {yylval.strval = yytext; return ESTRUCTURA_DE_CONTROL;}
{OTRA_PALABRA_RESERVADA}   {yylval.strval = yytext; return OTRA_PALABRA_RESERVADA;}
 
    /*Operador*/
"["         {return '[';}
"]"         {return ']';}
"."         {return '.';}
"->"        {return "->";}
"sizeof"    {return "sizeof";}
"++"        {return "++";}
"--"        {return "--";}
"~"         {return '~';}
"!"         {return '!';}
"-"         {return '-';}
"+"         {return '+';}
"&"         {return '&';}
"*"         {return '*';}
"/"         {return '/';}
"%"         {return '%';}
"<<"        {return "<<";}
">>"        {return ">>";}
"<"         {return '<';}
">"         {return '>';}
"<="        {return "<=";}
">="        {return ">=";}
"="         {return '=';}
"=="        {return "==";}
"!="        {return "!=";}
"+="        {return "+=";}
"-="        {return "-=";}
"*="        {return "*=";}
"/="        {return "/=";}
"%="        {return "%=";}
"&="        {return "&=";}
"^="        {return "^=";}
"|="        {return "|=";}
"<<="       {return "<<=";}
">>="       {return ">>=";}
"^"         {return '^';}
"|"         {return '|';}
"||"        {return "||";}
"&&"        {return "&&";}
"?:"        {return "?:";}

    /*Identificador*/
({LETRA}|_)({LETRA}|{DIGITO_DECIMAL}|_)* {yylval.strval = yytext; return IDENTIFICADOR;} 
    /*Caracter de Puntuación*/
";"     {return ';';}
","     {return ',';}
"("     {return '(';}
")"     {return ')';}
"{"     {return '{';}
"}"     {return '}';}
":"     {return ':';}
"..."     {return "...";}

    /*Cadena de caracteres no reconocidos*/
. {yylval.strval = yytext; return CARAC_NO_RECONOCIDO;}
    
%% 