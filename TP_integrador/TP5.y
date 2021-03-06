%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include "TP5.h"
#include "TP5.c"
#include "erroresSintacticosYSemanticos.h"
#define YYDEBUG 1

extern int yylineno;
int flag_error=0;
int contador=0;
char* tipoSentencia = NULL;
char* tipoDeclaracion = NULL;
char* identificador = NULL;
char valorConstante[100];
char* tipoConstante;


// Llamada por yyparse ante un error 
void yyerror (char const *s) {          //Con yyerror se detecta el error sintáctico 
   fprintf (stderr, "%s\n", s);
}  

FILE* yyin;

int yylex();

int yywrap(){
    return(1);
}

symrec *aux;

%}

%union
{
    int ival; 
    double dval;
    char* strval;
    char* tipoExpresion;
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
%token <strval> CLASE_ALMACENAMIENTO
%token <strval> TKN_VOID
// Identificadores
%token <strval> IDENTIFICADOR     
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
%token OP_ASIG_POTENCIA
%token OP_OR
%token OP_AND
%token OP_PARAMETROS_MULTIPLES 
%token OP_PORCENTAJE
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
//Estructuras Tipo
%token TKN_CONST
%token TKN_VOLATILE
%token TKN_STRUCT
%token TKN_UNION
%token TKN_ENUM
// ERROR
%token <ival> error
// NoTerminales
%type <tipoExpresion> expUnaria
%type <tipoExpresion> expAsignacion
%type <tipoExpresion> expPrimaria
%type <tipoExpresion> expPostfijo
%type <tipoExpresion> expMultiplicativa
%type <tipoExpresion> expAditiva
%type <tipoExpresion> expRelacional
%type <tipoExpresion> expIgualdad
%type <tipoExpresion> expAnd
%type <tipoExpresion> expOr
%type <tipoExpresion> expCondicional
%type <tipoExpresion> expresion



%% /* A continuacion las reglas gramaticales y las acciones */

input:    /* vacio */
        | input line
;

line:   '\n'
        | expresion         {if(!flag_error) printf("\n^^^\tSE DETECTO UNA EXPRESION\n\n"); else printf("\n^^^\tEXPRESION INCORRECTA\n\n"); flag_error = 0;}           
        | sentencia         {if(!flag_error) printf("\n^^^\tSE DETECTO UNA SENTENCIA %s\n\n",tipoSentencia); else printf("\n^^^\tSENTENCIA INCORRECTA %s\n\n",tipoSentencia); flag_error = 0;}           
        | declaracion       {if(!flag_error) printf("\n^^^\tSE DETECTO UNA DECLARACION\n\n"); else printf("\n^^^\tDECLARACION INCORRECTA\n\n"); flag_error = 0;}          
;

/////////////////////////////////  GRAMATICA DE SENTENCIAS  /////////////////////////////////


sentencia:  sentenciaExpresion      {tipoSentencia = "DE EXPRESION";}
          | sentenciaCompuesta      {tipoSentencia = "COMPUESTA";}
          | sentenciaDeSeleccion    {tipoSentencia = "DE SELECCION";} 
          | sentenciaDeIteracion    {tipoSentencia = "DE ITERACION";}
          | sentenciaEtiquetada     {tipoSentencia = "ETIQUETADA";}
          | sentenciaDeSalto        {tipoSentencia = "DE SALTO";}  
;

sentenciaExpresion: /* vacio */ ';'         {printf("Se detecto una sentencia vacia\n");}
                    | expresion ';'         {printf("Se detecto una sentencia con una expresion\n");}
;

sentenciaCompuesta:       '{' interiorSentenciaCompuesta '}'
;

interiorSentenciaCompuesta:        /* vacio */                              {printf("Se detecto una sentencia compuesta vacia\n");}
                                | listaDeDeclaraciones                      {printf("Se detecto una sentencia compuesta con una lista de declaraciones\n");}
                                | listaDeSentencias                         {printf("Se detecto una sentencia compuesta con una lista de sentencias\n");}
                                | listaDeDeclaraciones listaDeSentencias    {printf("Se detecto una sentencia compuesta con una lista de declaraciones y sentencias\n");}
;

listaDeDeclaraciones:   declaracion
                      | listaDeDeclaraciones declaracion 
;

listaDeSentencias:    sentencia
                    | listaDeSentencias sentencia
;

sentenciaDeSeleccion:   TKN_IF '(' expresion ')' sentencia                      {printf("Se detecto una sentencia if\n");}
                      | TKN_IF '(' expresion ')' sentencia TKN_ELSE sentencia   {printf("Se detecto una sentencia if con else\n");}
                      | TKN_IF error expresion ')' sentencia                    {insertarErrorSintactico("ERROR SINTACTICO: falta '(' en sentencia IF",yylineno); flag_error=1;}
                      | TKN_IF '(' expresion error sentencia                    {insertarErrorSintactico("ERROR SINTACTICO: falta ')' en sentencia IF",yylineno); flag_error=1;}
                      | TKN_IF '(' error ')' sentencia                          {insertarErrorSintactico("ERROR SINTACTICO: expresion incorrecta en sentencia IF",yylineno); flag_error=1;}
                      | TKN_SWITCH '(' IDENTIFICADOR ')' sentencia              {printf("Se detecto una sentencia switch\n");}
;

sentenciaDeIteracion:   TKN_WHILE '(' expresion ')' sentencia                                   {printf("Se detecto una sentencia while\n");}   
                      | TKN_WHILE '(' error ')' sentencia                                       {insertarErrorSintactico("ERROR SINTACTICO: no tiene expresion en condicion while",yylineno); flag_error=1; } 
                      | TKN_WHILE error expresion ')' sentencia                                 {insertarErrorSintactico("ERROR SINTACTICO: falta '(' en while",yylineno); flag_error=1;}
                      | TKN_WHILE '(' expresion error sentencia                                 {insertarErrorSintactico("ERROR SINTACTICO: falta ') en' while",yylineno); flag_error=1;}
                      | TKN_WHILE '(' expresion ')' error ';'                                   {insertarErrorSintactico("ERROR SINTACTICO: El while no esta seguido por una sentencia",yylineno); flag_error=1;}
                      | TKN_DO sentencia TKN_WHILE '(' expresion ')' ';'                        {printf("Se detecto una sentencia do while\n");} 
                      | TKN_DO sentencia TKN_WHILE '(' expresion ')' error ';'                  {insertarErrorSintactico("ERROR SINTACTICO: No posee ';' luego del while",yylineno); flag_error=1;}
                      | TKN_FOR '(' ';' ';' ')' sentencia                                       {printf("Se detecto una sentencia for\n");}    
                      | TKN_FOR '(' expresion ';' ';' ')' sentencia                             {printf("Se detecto una sentencia for\n");}  
                      | TKN_FOR '('  ';' expresion ';' ')' sentencia                            {printf("Se detecto una sentencia for\n");} 
                      | TKN_FOR '('  ';' ';' expresion ')' sentencia                            {printf("Se detecto una sentencia for\n");}  
                      | TKN_FOR '(' expresion ';' expresion ';' ')' sentencia                   {printf("Se detecto una sentencia for\n");}  
                      | TKN_FOR '(' expresion ';'  ';' expresion ')' sentencia                  {printf("Se detecto una sentencia for\n");}  
                      | TKN_FOR '('  ';' expresion ';' expresion ')' sentencia                  {printf("Se detecto una sentencia for\n");}  
                      | TKN_FOR '(' expresion ';' expresion ';' expresion ')' sentencia         {printf("Se detecto una sentencia for\n");}
                      | TKN_FOR '(' expresion ';' expresion ';' expresion ')' error  ';'        {insertarErrorSintactico("ERROR SINTACTICO: El FOR no esta seguido por una sentencia",yylineno); flag_error=1;}
                      | TKN_FOR error expresion ';' expresion ';' expresion ')' sentencia       {insertarErrorSintactico("ERROR SINTACTICO: El FOR no tiene '(' de apertura", yylineno); flag_error=1;}
                      | TKN_FOR '(' expresion ';' expresion ';' expresion error sentencia       {insertarErrorSintactico("ERROR SINTACTICO: El FOR no tiene ')' de cierre", yylineno); flag_error=1;}
;

sentenciaEtiquetada:    TKN_CASE constante ':' sentencia            {printf("Se detecto una sentencia case de switch\n");}   
                      | TKN_DEFAULT ':' sentencia                   {printf("Se detecto una sentencia caso default de switch\n");}     
; 

sentenciaDeSalto:   TKN_BREAK ';'             {printf("Se detecto una sentencia break\n");}
                  | TKN_RETURN ';'            {printf("Se detecto una sentencia return sin expresion\n");}  
                  | TKN_RETURN expresion ';'  {printf("Se detecto una sentencia return con valor a retornar\n");}
;

////////////////////////////////////////////////// GRAMATICA DE DECLARACIONES ///////////////////////////////////////////////////////////

declaracion:      TIPO_DE_DATO          {tipoDeclaracion = $<strval>1;} dec
                | TIPO_DE_DATO '*'      {tipoDeclaracion = strcat($<strval>1,"*");} dec                 
                | TKN_VOID              {tipoDeclaracion = "void";} declaracionDefinicionFuncion  
                | struct                {printf("Se derivo por struct\n");}
;

struct:    TKN_STRUCT IDENTIFICADOR '{' camposStruct '}' ';'                  {printf("Se declara el struct %s\n", $<strval>2);}
;

camposStruct:     TIPO_DE_DATO IDENTIFICADOR ';' camposStruct   {printf("Se agrega el campo %s de tipo %s al struct \n",$<strval>2,$<strval>1);}
                | TIPO_DE_DATO IDENTIFICADOR ';'                {printf("Se agrega el campo %s de tipo %s al struct \n",$<strval>2,$<strval>1);}
                | error ';'                                     {if(!flag_error){insertarErrorSintactico("ERROR SINTACTICO error en campo de struct",yylineno); flag_error = 1;}}
                | TIPO_DE_DATO IDENTIFICADOR                    {if(!flag_error){insertarErrorSintactico("ERROR SINTACTICO: error sin punto y coma en campo de struct",yylineno); flag_error = 1;}}
                | TIPO_DE_DATO                                  {if(!flag_error){insertarErrorSintactico("ERROR SINTACTICO: error sin punto y coma en campo de struct",yylineno); flag_error = 1;}}
;

dec:      declaracionDefinicionFuncion          
        | declaracionVariables ';'                      {printf("Declaracion de variables\n");}
;

declaracionVariables:   listaIdentificadores {printf("Comienza declaracion de variables del tipo %s\n",tipoDeclaracion);}
;

listaIdentificadores:   declaIdentificador                          {printf("Derivo por declaIdentificador\n");}
                      | declaIdentificador ',' listaIdentificadores {printf("Se agrega una variable a la declaracion\n");}
;

declaIdentificador:   IDENTIFICADOR                     {aux=getsym($<strval>1,TYP_VAR); if (aux) insertarErrorSemantico("ERROR SEMANTICO: DOBLE DECLARACION DE VARIABLES",yylineno); else declararVariableSinInicializar($<strval>1,tipoDeclaracion);} 
                    | IDENTIFICADOR '=' constante       {aux=getsym($<strval>1,TYP_VAR); if (aux) insertarErrorSemantico("ERROR SEMANTICO: DOBLE DECLARACION DE VARIABLES",yylineno); else declararVariable($<strval>1,tipoDeclaracion,valorConstante);}
                    | IDENTIFICADOR '=' LITERAL_CADENA  {aux=getsym($<strval>1,TYP_VAR); if (aux) insertarErrorSemantico("ERROR SEMANTICO: DOBLE DECLARACION DE VARIABLES",yylineno); else {printf("Se derivo el literal cadena: %s\n", $<strval>3); sprintf(valorConstante,"%s",$<strval>3); tipoConstante = "char*";  declararVariable($<strval>1,tipoDeclaracion,valorConstante);} }
                    | IDENTIFICADOR '=' IDENTIFICADOR   {aux=getsym($<strval>1,TYP_VAR); if (aux) insertarErrorSemantico("ERROR SEMANTICO: DOBLE DECLARACION DE VARIABLES",yylineno); else declararVariableIgualando($<strval>1,tipoDeclaracion,$<strval>3,yylineno);}
                    | error                             {if(!flag_error){insertarErrorSintactico("ERROR SINTACTICO: identificador erroneo de variable a declarar",yylineno); flag_error = 1;} }
                    | error '=' constante               {if(!flag_error){insertarErrorSintactico("ERROR SINTACTICO: identificador erroneo de variable a declarar con inicializacion",yylineno); flag_error = 1;} }
                    | IDENTIFICADOR '=' error           {if(!flag_error){insertarErrorSintactico("ERROR SINTACTICO: inicializacion con valor erroneo en declaracion de variable",yylineno); flag_error = 1;} }
;

declaracionDefinicionFuncion:     IDENTIFICADOR {identificador = $<strval>1; listaAuxParametros = NULL;} parametrosCuerpoFuncion  
                                | error parametrosCuerpoFuncion { insertarErrorSintactico("ERROR SINTACTICO: falta identificador en declaracion/definicion de funcion",yylineno); flag_error = 1;}
;

parametrosCuerpoFuncion:      '(' listaParametroConId ')' sentenciaCompuesta    {aux=getsym($<strval>1,TYP_FNCT); if (aux) insertarErrorSemantico("ERROR SEMANTICO: DOBLE DECLARACION DE FUNCION",yylineno); else declaracionDeFuncion(identificador, tipoDeclaracion, listaAuxParametros); }
                            | '(' listaParametroSinId ')' ';'                   {aux=getsym($<strval>1,TYP_FNCT); if (aux) insertarErrorSemantico("ERROR SEMANTICO: DOBLE DECLARACION DE FUNCION",yylineno); else declaracionDeFuncion(identificador, tipoDeclaracion, listaAuxParametros); }
                            | '(' /* vacio */ ')' sentenciaCompuesta            {aux=getsym($<strval>1,TYP_FNCT); if (aux) insertarErrorSemantico("ERROR SEMANTICO: DOBLE DECLARACION DE FUNCION",yylineno); else declaracionDeFuncion(identificador, tipoDeclaracion, listaAuxParametros); }
                            | '(' /* vacio */ ')' ';'                           {aux=getsym($<strval>1,TYP_FNCT); if (aux) insertarErrorSemantico("ERROR SEMANTICO: DOBLE DECLARACION DE FUNCION",yylineno); else declaracionDeFuncion(identificador, tipoDeclaracion, listaAuxParametros); }
                            | '(' listaParametroConId ')' ';'                   {aux=getsym($<strval>1,TYP_FNCT); if (aux) insertarErrorSemantico("ERROR SEMANTICO: DOBLE DECLARACION DE FUNCION",yylineno); else declaracionDeFuncion(identificador, tipoDeclaracion, listaAuxParametros); }
;

listaParametroConId:      parametroConId
                        | parametroConId ',' listaParametroConId 
;

listaParametroSinId:      parametroSinId
                        | parametroSinId ',' listaParametroSinId
;

parametroConId:   TIPO_DE_DATO IDENTIFICADOR       { agregarParametroAuxiliar($<strval>1);} 
                | TIPO_DE_DATO '*' IDENTIFICADOR   { agregarParametroAuxiliar(strcat($<strval>1,"*"));} 
                | error IDENTIFICADOR              {insertarErrorSintactico("ERROR SINTACTICO: falta tipo de dato del parametro",yylineno); flag_error = 1;}
                | error '*' IDENTIFICADOR          {insertarErrorSintactico("ERROR SINTACTICO: falta tipo de dato del puntero parametro",yylineno); flag_error = 1;}
                | TIPO_DE_DATO error               {insertarErrorSintactico("ERROR SINTACTICO: falta identificador en parametro", yylineno); flag_error = 1;}
                | TIPO_DE_DATO '*' error           {insertarErrorSintactico("ERROR SINTACTICO: falta identificador del puntero parametro", yylineno); flag_error = 1;}
;

parametroSinId:   TIPO_DE_DATO         { agregarParametroAuxiliar($<strval>1);} 
                | TIPO_DE_DATO '*'     { agregarParametroAuxiliar(strcat($<strval>1,"*"));} 
                | error '*'            {insertarErrorSintactico("ERROR SINTACTICO: falta tipo de dato del puntero",yylineno); flag_error = 1;}
;

////////////////////////////////////////////////// GRAMATICA DE EXPRESIONES ///////////////////////////////////////////////////////////

expresion:      expAsignacion {$<tipoExpresion>$=$<tipoExpresion>1;}
;

expAsignacion:    expCondicional                           {$<tipoExpresion>$=$<tipoExpresion>1;}
                | invocacionDeFuncion                      {printf("Se derivo por invocacionDeFuncion\n");}
                | expUnaria operAsignacion expAsignacion   {verificacionDeTiposCorrecta($<tipoExpresion>1,$<tipoExpresion>3,yylineno);} 
;

operAsignacion:   '='                       {printf("Se utiliza el =\n");}
                | OP_ASIG_MULTIPLICACION    {printf("Se utiliza el =*\n");}
                | OP_ASIG_DIVISION          {printf("Se utiliza el =/\n");}
                | OP_ASIG_RESTO             {printf("Se utiliza el =%\n");}
                | OP_ASIG_SUMA              {printf("Se utiliza el =+\n");}                        
                | OP_ASIG_RESTA             {printf("Se utiliza el =-\n");}
                | OP_ASIG_POTENCIA          {printf("Se utiliza el =^\n");}
                | error                     {insertarErrorSintactico("ERROR SINTACTICO: operador de asignacion incorrecto",yylineno); flag_error = 1;}
;

expCondicional: expOr   {$<tipoExpresion>$=$<tipoExpresion>1; }
;

expOr:   expAnd                   {$<tipoExpresion>$=$<tipoExpresion>1;} 
       | expOr OP_OR expAnd     {printf("Se agrega expOr\n");}
;

expAnd:   expIgualdad                   {$<tipoExpresion>$=$<tipoExpresion>1;} 
        | expAnd OP_AND expIgualdad     {printf("Se agrega expAnd\n");}
;

expIgualdad:   expRelacional                              {$<tipoExpresion>$=$<tipoExpresion>1; }
             | expIgualdad OP_IGUALDAD expRelacional      {printf("Se agrega expIgualdad con ==\n");} 
             | expIgualdad OP_DESIGUALDAD expRelacional   {printf("Se agrega expIgualdad con !=\n");}  
;

expRelacional:   expAditiva                                    {$<tipoExpresion>$=$<tipoExpresion>1; }  
               | expRelacional operadorRelacional expAditiva   {printf("Se agrega expRelacional\n");}  
;

operadorRelacional:   OP_MAYOR_IGUAL    {printf("Se derivo el operador >=\n");} 
                    | '>'               {printf("Se derivo el operador >\n");}    
                    | OP_MENOR_IGUAL    {printf("Se derivo el operador <=\n");} 
                    | '<'               {printf("Se derivo el operador <\n");}
                    | error             {insertarErrorSintactico("ERROR SINTACTICO: operador relacional incorrecto",yylineno); flag_error = 1;}
;  

expAditiva: expMultiplicativa                   {$<tipoExpresion>$=$<tipoExpresion>1; }
            | expAditiva '+' expMultiplicativa  {printf("Se agrega expAditiva con +\n");} 
            | expAditiva '-' expMultiplicativa  {printf("Se agrega expAditiva con -\n");} 
;

expMultiplicativa:   expUnaria                          {$<tipoExpresion>$=$<tipoExpresion>1; }
                   | expMultiplicativa '*' expUnaria    {printf("Se agrega expMultiplicativa con *\n");} 
                   | expMultiplicativa '/' expUnaria    {printf("Se agrega expMultiplicativa con /\n");}
                   | expMultiplicativa '%' expUnaria    {printf("Se agrega expMultiplicativa con %\n");}
;

expUnaria: expPostfijo                          {$<tipoExpresion>$=$<tipoExpresion>1; }
           | OP_INC expUnaria                   {printf("Se derivo por ++ expUnaria\n");} 
           | OP_DEC expUnaria                   {printf("Se derivo por -- expUnaria\n");} 
           | expUnaria OP_INC                   {printf("Se derivo por expUnaria ++\n");} 
           | expUnaria OP_DEC                   {printf("Se derivo por expUnaria --\n");} 
           | operUnario expUnaria               {printf("Se derivo por operUnario expUnaria\n");} 
           | OP_SIZEOF '(' TIPO_DE_DATO ')'     {printf("Se derivo por sizeof ( TIPO_DE_DATO )\n");}
;           

operUnario:   '&'       {printf("Se derivo por operUnario con &\n");}  
            | '*'       {printf("Se derivo por operUnario con *\n");}
;

expPostfijo:   expPrimaria                          {$<tipoExpresion>$=$<tipoExpresion>1; } 
             | expPostfijo '[' expresion ']'        {printf("Se agrega [ expresion ] a expPostfijo\n");}
             | expPostfijo error expresion ']'      {insertarErrorSintactico("ERROR SINTACTICO: Falta '[' en expPostfijo.",yylineno); flag_error=1;}
             | expPostfijo '[' expresion error      {insertarErrorSintactico("ERROR SINTACTICO: Falta ']' en expPostfijo.",yylineno); flag_error=1;}
             | expPostfijo '[' error ']'            {insertarErrorSintactico("ERROR SINTACTICO: Expresion no valida dentro de expPostfijo.",yylineno); flag_error=1;}
;

expPrimaria:   IDENTIFICADOR            {aux=getsym($<strval>1,TYP_VAR); if(aux) $<tipoExpresion>$ = aux->tipo; else insertarErrorSemantico("ERROR SEMANTICO: No existe la variable utilizada",yylineno);}
             | constante                {printf("\nSe derivo una constante de tipo: %s\n",$<tipoExpresion>1); $<tipoExpresion>$=$<tipoExpresion>1; } 
             | LITERAL_CADENA           {$<tipoExpresion>$="char*"; printf("Se derivo el literal cadena: %s\n", $<strval>1);    sprintf(valorConstante,"%s",$<strval>1); tipoConstante = "char*";} 
             | '(' expresion ')'        {$<tipoExpresion>$=$<tipoExpresion>2;} 
;

constante:    ENTERO               {$<tipoExpresion>$="int";       printf("Se derivo la constante entera: %d\n",$<ival>1);     sprintf(valorConstante,"%d",$<ival>1);   tipoConstante = "int";}   
            | NUM                  {$<tipoExpresion>$="double";    printf("Se derivo la constante real: %f\n",$<dval>1);       sprintf(valorConstante,"%f",$<dval>1);   tipoConstante = "float";}     
            | CONST_CARACTER       {$<tipoExpresion>$="char";      printf("Se derivo la constante caracter: %s\n",$<strval>1); sprintf(valorConstante,"%s",$<strval>1); tipoConstante = "char";} 
;

invocacionDeFuncion:    IDENTIFICADOR '(' listaArgumentos ')'   {if(invocacion($<strval>1,yylineno)){aux=getsym($<strval>1,TYP_FNCT); $<tipoExpresion>$=aux->tipo;};}
                     |  IDENTIFICADOR error listaArgumentos ')' {insertarErrorSintactico("ERROR SINTACTICO falta '(' en invocacionDeFuncion", yylineno); flag_error=1;}
                     |  IDENTIFICADOR '(' listaArgumentos error {insertarErrorSintactico("ERROR SINTACTICO falta ')' en invocacionDeFuncion", yylineno); flag_error=1;}
                     |  IDENTIFICADOR '(' error ')'             {insertarErrorSintactico("ERROR SINTACTICO: lista de argumentos no valida", yylineno); flag_error=1;}
;

listaArgumentos:   argumento                          {printf("Se derivo por argumento en la lista de argumentos\n");} 
                 | argumento ',' listaArgumentos      {printf("Se agrega argumento a la lista de argumentos\n");}
;

argumento:        /* vacio */         {printf("Se derivo por invocacion sin arg\n");}
                | IDENTIFICADOR       {chequeoArgumento($<strval>1,yylineno);}
                | constante           {agregarArgumentoAuxiliar(tipoConstante);}
                | LITERAL_CADENA      {agregarArgumentoAuxiliar("char*");}
%%

// Define variable puntero que apunta a la tabla de símbolos (TS).

symrec *sym_table;

int main(){
        #ifdef BISON_DEBUG
        yydebug = 1;
        #endif

        yyin = fopen("archivo.c","r");
        printf("\n");
        yyparse();
        generarReporte();
}