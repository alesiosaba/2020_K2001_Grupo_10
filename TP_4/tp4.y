%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>

extern int yylineno;
int flag_error=0;
int contador=0;
char* tipoSentencia = NULL;

// Llamada por yyparse ante un error 
void yyerror(char const *s){  //Con yyerror se detecta el error sintáctico     
    printf("%s linea: %d\n",s,yylineno);
}

FILE* yyin;

int yylex();

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

%% /* A continuacion las reglas gramaticales y las acciones */

input:    /* vacio */
        | input line
;

line:   '\n'
        | expresion         {if(!flag_error) printf("\tSE DETECTO UNA EXPRESION\n\n"); else printf("\tEXPRESION INCORRECTA\n\n");}           
;

caracterDeCorte: '\n' | ';' 
;

/////// EXPRESIONES //////

expresion: expAsignacion {printf("Se derivo por expAsignacion\n");}
;

expAsignacion: expCondicional                             {printf("Se derivo por expCondicional\n");}
               | expUnaria operAsignacion expAsignacion   {printf("Se agregan expAsignacion\n");} 
;

operAsignacion: '='                         {printf("Se utiliza el =\n");}
                | OP_ASIG_MULTIPLICACION    {printf("Se utiliza el =*\n");}
                | OP_ASIG_DIVISION          {printf("Se utiliza el =/\n");}
                | OP_ASIG_RESTO             {printf("Se utiliza el =%\n");}
                | OP_ASIG_SUMA              {printf("Se utiliza el =+\n");}                        
                | OP_ASIG_RESTA             {printf("Se utiliza el =-\n");}
                | OP_ASIG_POTENCIA          {printf("Se utiliza el =^\n");}
                | error                     {printf("\t ERROR: operador de asignacion incorrecto\n"); flag_error = 1;}
;

expCondicional: expOr   {printf("Se derivo por expOr\n");}
;

expOr: expAnd                   {printf("Se derivo por expAnd\n");}   
       | expOr OP_OR expAnd     {printf("Se agrega expOr\n");}  
;

expAnd: expIgualdad                     {printf("Se derivo por expIgualdad\n");} 
        | expAnd OP_AND expIgualdad     {printf("Se agrega expAnd\n");}  
;

expIgualdad: expRelacional                                {printf("Se derivo por expRelacional\n");} 
             | expIgualdad OP_IGUALDAD expRelacional      {printf("Se agrega expIgualdad con ==\n");}  
             | expIgualdad OP_DESIGUALDAD expRelacional   {printf("Se agrega expIgualdad con !=\n");}  
             | error                                      {printf("\t ERROR: estructura de expresion de igualdad incorrecta \n"); flag_error = 1;} 
;

expRelacional: expAditiva                                   {printf("Se derivo por expAditiva\n");}  
               | expRelacional OP_MAYOR_IGUAL expAditiva    {printf("Se agrega expRelacional con >=\n");} 
               | expRelacional '>' expAditiva               {printf("Se agrega expRelacional con >\n");} 
               | expRelacional OP_MENOR_IGUAL expAditiva    {printf("Se agrega expRelacional con <=\n");} 
               | expRelacional '<' expAditiva               {printf("Se agrega expRelacional con <\n");} 
               | error                                      {printf("\t ERROR: estructura de expresion relacional incorrecta \n"); flag_error = 1;} 
;

expAditiva: expMultiplicativa                   {printf("Se derivo por expMultiplicativa\n");}  
            | expAditiva '+' expMultiplicativa  {printf("Se agrega expAditiva con +\n");} 
            | expAditiva '-' expMultiplicativa  {printf("Se agrega expAditiva con -\n");} 
            | error                             {printf("\t ERROR: estructura de expresion aditiva incorrecta \n"); flag_error = 1;} 
;

expMultiplicativa: expUnaria                            {printf("Se derivo por expUnaria\n");} 
                   | expMultiplicativa '*' expUnaria    {printf("Se agrega expMultiplicativa con *\n");} 
                   | expMultiplicativa '/' expUnaria    {printf("Se agrega expMultiplicativa con /\n");}
                   | expMultiplicativa '%' expUnaria    {printf("Se agrega expMultiplicativa con %\n");}
                   | error                              {printf("\t ERROR: estructura de expresion multiplicativa incorrecta \n"); flag_error = 1;} 
;

expUnaria: expPostfijo                          {printf("Se derivo por expPostfijo\n");} 
           | OP_INC expUnaria                   {printf("Se derivo por ++ expUnaria\n");} 
           | OP_DEC expUnaria                   {printf("Se derivo por -- expUnaria\n");} 
           | operUnario expUnaria               {printf("Se derivo por operUnario expUnaria\n");} 
           | OP_SIZEOF '(' TIPO_DE_DATO ')'     {printf("Se derivo por sizeof ( TIPO_DE_DATO )\n");} 
           | error                              {printf("\t ERROR: estructura de expresion unaria incorrecta \n"); flag_error = 1;} 
;           

operUnario: '&'     {printf("Se derivo por operUnario con &\n");}  
            | '*'   {printf("Se derivo por operUnario con *\n");}     
            | error {printf("\t ERROR: operador unario incorrecto\n"); flag_error = 1;}      
;

expPostfijo: expPrimaria                            {printf("Se derivo por expPrimaria\n");} 
             | expPostfijo '[' expresion ']'        {printf("Se agrega [ expresion ] a expPostfijo\n");} 
             | expPostfijo '(' listaArgumentos ')'  {printf("Se agrega ( listaArgumentos ) a expPostfijo\n");} 
             | expPostfijo '(' ')'                  {printf("Se agrega () a expPostfijo\n");}
             | error                                {printf("\t ERROR: estructura de expresion postfijo incorrecta \n"); flag_error = 1;} 
;

listaArgumentos: expAsignacion                          {printf("Se derivo por expAsignacion en la lista de parametros\n");} 
                 | expAsignacion ',' listaArgumentos    {printf("Se agrega argumento a la lista de parametros\n");}
;

expPrimaria: IDENTIFICADOR         {printf("Se derivo el identificador: %s\n", $<strval>1);}
             | constante           {printf("Se derivo una constante\n");} 
             | LITERAL_CADENA      {printf("Se derivo el literal cadena: %s\n", $<strval>1);} 
             | '(' expresion ')'   {printf("Se derivo por ( expresion ) en expPrimaria\n");}
             | error               {printf("\t ERROR: expresion primaria incorrecta\n"); flag_error = 1;}
;

constante:  ENTERO                 {printf("Se derivo la constante entera: %d\n",$<ival>1);}   
            | NUM                  {printf("Se derivo la constante real: %f\n",$<dval>1);}     
            | CONST_CARACTER       {printf("Se derivo la constante caracter: %s\n",$<strval>1);} 
;

//////////////////////////////////////////////////////////////////////////////////////////////////////// 

%%

int main(){
  yyin = fopen("archivo.c","r");
  printf("\n");
  yyparse();
}
