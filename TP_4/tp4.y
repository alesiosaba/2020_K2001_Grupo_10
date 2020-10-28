%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>

extern int yylineno;
int flag_error=0;
int contador=0;
char* tipoSentencia = NULL;
char* tipoDeclaracion = NULL;
char* identificador = NULL;
char valorConstante[100];

// Llamada por yyparse ante un error 
void yyerror(char*);  //Con yyerror se detecta el error sintáctico 

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
        | expresion         {if(!flag_error) printf("\n^^^\tSE DETECTO UNA EXPRESION\n\n"); else printf("\n^^^\tEXPRESION INCORRECTA\n\n"); flag_error = 0;}           
        | sentencia         {if(!flag_error) printf("\n^^^\tSE DETECTO UNA SENTENCIA %s\n\n",tipoSentencia); else printf("\n^^^\tSENTENCIA INCORRECTA\n\n"); flag_error = 0;}           
        | declaracion       {if(!flag_error) printf("\n^^^\tSE DETECTO UNA DECLARACION\n\n"); else printf("\n^^^\tSE DETECTO UNA DECLARACION\n\n"); flag_error = 0;}           
;

/////////////////////////////////  GRAMATICA DE SENTENCIAS  /////////////////////////////////


sentencia:  sentenciaExpresion      {printf("Se derivo por sentenciaExpresion\n"); tipoSentencia = "expresion";}
          | sentenciaCompuesta      {printf("Se derivo por sentenciaCompuesta\n"); tipoSentencia = "compuesta";}
          | sentenciaDeSeleccion    {printf("Se derivo por sentenciaDeSeleccion\n"); tipoSentencia = "de seleccion";} 
          | sentenciaDeIteracion    {printf("Se derivo por sentenciaDeIteracion\n"); tipoSentencia = "de iteracion";}
          | sentenciaEtiquetada     {printf("Se derivo por sentenciaEtiquetada\n"); tipoSentencia = "etiquetada";}
          | sentenciaDeSalto        {printf("Se derivo por sentenciaDeSalto\n"); tipoSentencia = "de salto";}  
;

sentenciaExpresion: /* vacio */ ';'         {printf("Se detecto una sentencia vacia\n");}
                    | expresion ';'         {printf("Se detecto una sentencia con una expresion\n");}
;

sentenciaCompuesta:   '{' /* vacio */ '}'                            {printf("Se detecto una sentencia compuesta vacia\n");}
                    | '{' listaDeDeclaraciones '}'                   {printf("Se detecto una sentencia compuesta con una lista de declaraciones\n");}
                    | '{' listaDeSentencias '}'                      {printf("Se detecto una sentencia compuesta con una lista de sentencias\n");}
                    | '{' listaDeDeclaraciones listaDeSentencias '}' {printf("Se detecto una sentencia compuesta con una lista de declaraciones y sentencias\n");}
;

listaDeDeclaraciones:   declaracion
                      | listaDeDeclaraciones declaracion 
;

listaDeSentencias:    sentencia
                    | listaDeSentencias sentencia
;

sentenciaDeSeleccion:   TKN_IF '(' expresion ')' sentencia                      {printf("Se detecto una sentencia if\n");}  
                      | TKN_IF '(' expresion ')' sentencia TKN_ELSE sentencia   {printf("Se detecto una sentencia if con else\n");}
                      | TKN_SWITCH '(' IDENTIFICADOR ')' sentencia              {printf("Se detecto una sentencia switch\n");}
;

sentenciaDeIteracion:   TKN_WHILE '(' expresion ')' sentencia                           {printf("Se detecto una sentencia while\n");}          
                      | TKN_DO sentencia TKN_WHILE '(' expresion ')' ';'                {printf("Se detecto una sentencia do while\n");}  
                      | TKN_FOR '(' ';' ';' ')' sentencia                               {printf("Se detecto una sentencia for\n");}    
                      | TKN_FOR '(' expresion ';' ';' ')' sentencia                     {printf("Se detecto una sentencia for\n");}  
                      | TKN_FOR '('  ';' expresion ';' ')' sentencia                    {printf("Se detecto una sentencia for\n");} 
                      | TKN_FOR '('  ';' ';' expresion ')' sentencia                    {printf("Se detecto una sentencia for\n");}  
                      | TKN_FOR '(' expresion ';' expresion ';' ')' sentencia           {printf("Se detecto una sentencia for\n");}  
                      | TKN_FOR '(' expresion ';'  ';' expresion ')' sentencia          {printf("Se detecto una sentencia for\n");}  
                      | TKN_FOR '('  ';' expresion ';' expresion ')' sentencia          {printf("Se detecto una sentencia for\n");}  
                      | TKN_FOR '(' expresion ';' expresion ';' expresion ')' sentencia {printf("Se detecto una sentencia for\n");}
;

sentenciaEtiquetada:    TKN_CASE constante ':' sentencia            {printf("Se detecto una sentencia case de switch\n");}   
                      | TKN_DEFAULT ':' sentencia                   {printf("Se detecto una sentencia caso default de switch\n");}     
; 

sentenciaDeSalto: TKN_BREAK ';'               {printf("Se detecto una sentencia break\n");}
                  | TKN_RETURN ';'            {printf("Se detecto una sentencia return sin expresion\n");}  
                  | TKN_RETURN expresion ';'  {printf("Se detecto una sentencia return con valor a retornar\n");}
;

////////////////////////////////////////////////// GRAMATICA DE DECLARACIONES ///////////////////////////////////////////////////////////

declaracion:      TIPO_DE_DATO  {tipoDeclaracion = $<strval>1;} dec                 
                | TKN_VOID      {tipoDeclaracion = "void";} declaracionDefinicionFuncion  
                | struct        {printf("Se derivo por struct\n");}
;

struct:    TKN_STRUCT IDENTIFICADOR '{' camposStruct '}' ';'                  {printf("Se declara el struct %s\n", $<strval>2);}
;

camposStruct:     TIPO_DE_DATO IDENTIFICADOR ';'
                | TIPO_DE_DATO IDENTIFICADOR ';' camposStruct
;

dec:      declaracionDefinicionFuncion          
        | declaracionVariables ';'            {printf("Declaracion de variables\n");}
;

declaracionVariables:   listaIdentificadores {printf("Comienza declaracion de variables del tipo %s\n",tipoDeclaracion);}
;

listaIdentificadores: declaIdentificador                            {printf("Derivo por declaIdentificador\n");}
                      | declaIdentificador ',' listaIdentificadores {printf("Se agrega una variable a la declaracion\n");}
;

declaIdentificador: IDENTIFICADOR                   {printf("Se declara la variable %s de tipo %s\n",$<strval>1,tipoDeclaracion);}
                    | IDENTIFICADOR '=' constante   {printf("Se declara la variable %s de tipo %s con valor inicial %s\n",$<strval>1,tipoDeclaracion,valorConstante);}
;

declaracionDefinicionFuncion:   IDENTIFICADOR {identificador = $<strval>1;} parametrosCuerpoFuncion {printf("Declaracion / Definicion de una funcion\n");}
;

parametrosCuerpoFuncion:      '(' listaParametroConId ')' sentenciaCompuesta    {printf("Define la funcion %s de tipo %s\n",identificador, tipoDeclaracion);}
                            | '(' listaParametroConId ')' ';'                   {printf("Declara la funcion %s (prototipo) de tipo %s\n",identificador, tipoDeclaracion);}
                            | '(' listaParametroSinId ')' ';'                   {printf("Declara la funcion %s (prototipo) de tipo %s\n",identificador, tipoDeclaracion);}
                            | '(' /* vacio */ ')' sentenciaCompuesta            {printf("Define la funcion %s sin parametros, de tipo %s\n",identificador, tipoDeclaracion);}
                            | '(' /* vacio */ ')' ';'                           {printf("Declara la funcion %s (prototipo) sin parametros, de tipo %s\n",identificador, tipoDeclaracion);}
;

listaParametroConId:      parametroConId
                        | parametroConId ',' listaParametroConId
;

listaParametroSinId:      parametroSinId
                        | parametroSinId ',' listaParametroSinId
;

parametroConId:   TIPO_DE_DATO IDENTIFICADOR
                | TIPO_DE_DATO '*' IDENTIFICADOR
;

parametroSinId:   TIPO_DE_DATO
                | TIPO_DE_DATO '*'
;

////////////////////////////////////////////////// GRAMATICA DE EXPRESIONES ///////////////////////////////////////////////////////////

expresion: expAsignacion {printf("Se derivo por expAsignacion\nSe derivo por expresion\n");}
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
;

expRelacional: expAditiva                                    {printf("Se derivo por expAditiva\n");}  
               | expRelacional operadorRelacional expAditiva {printf("Se agrega expRelacional\n");}  
;

operadorRelacional: OP_MAYOR_IGUAL   {printf("Se derivo el operador >=\n");} 
                    | '>'            {printf("Se derivo el operador >\n");}    
                    | OP_MENOR_IGUAL {printf("Se derivo el operador <=\n");} 
                    | '<'            {printf("Se derivo el operador <\n");}
;  

expAditiva: expMultiplicativa                   {printf("Se derivo por expMultiplicativa\n");}  
            | expAditiva '+' expMultiplicativa  {printf("Se agrega expAditiva con +\n");} 
            | expAditiva '-' expMultiplicativa  {printf("Se agrega expAditiva con -\n");} 
;

expMultiplicativa: expUnaria                            {printf("Se derivo por expUnaria\n");} 
                   | expMultiplicativa '*' expUnaria    {printf("Se agrega expMultiplicativa con *\n");} 
                   | expMultiplicativa '/' expUnaria    {printf("Se agrega expMultiplicativa con /\n");}
                   | expMultiplicativa '%' expUnaria    {printf("Se agrega expMultiplicativa con %\n");}
;

expUnaria: expPostfijo                          {printf("Se derivo por expPostfijo\n");} 
           | OP_INC expUnaria                   {printf("Se derivo por ++ expUnaria\n");} 
           | OP_DEC expUnaria                   {printf("Se derivo por -- expUnaria\n");} 
           | operUnario expUnaria               {printf("Se derivo por operUnario expUnaria\n");} 
           | OP_SIZEOF '(' TIPO_DE_DATO ')'     {printf("Se derivo por sizeof ( TIPO_DE_DATO )\n");}
;           

operUnario: '&'     {printf("Se derivo por operUnario con &\n");}  
            | '*'   {printf("Se derivo por operUnario con *\n");}
;

expPostfijo: expPrimaria                            {printf("Se derivo por expPrimaria\n");} 
             | expPostfijo '[' expresion ']'        {printf("Se agrega [ expresion ] a expPostfijo\n");} 
             | expPostfijo '(' listaArgumentos ')'  {printf("Se agrega ( listaArgumentos ) a expPostfijo\n");} 
             | expPostfijo '(' ')'                  {printf("Se agrega () a expPostfijo\n");}
;

listaArgumentos: expAsignacion                          {printf("Se derivo por expAsignacion en la lista de parametros\n");} 
                 | expAsignacion ',' listaArgumentos    {printf("Se agrega argumento a la lista de parametros\n");}
;

expPrimaria: IDENTIFICADOR         {printf("Se derivo el identificador: %s\n", $<strval>1);}
             | constante           {printf("Se derivo una constante\n");} 
             | LITERAL_CADENA      {printf("Se derivo el literal cadena: %s\n", $<strval>1);} 
             | '(' expresion ')'   {printf("Se derivo por ( expresion ) en expPrimaria\n");}
;

constante:  ENTERO                 {printf("Se derivo la constante entera: %d\n",$<ival>1); sprintf(valorConstante,"%d",$<ival>1);}   
            | NUM                  {printf("Se derivo la constante real: %f\n",$<dval>1); sprintf(valorConstante,"%f",$<dval>1);}     
            | CONST_CARACTER       {printf("Se derivo la constante caracter: %s\n",$<strval>1); sprintf(valorConstante,"%s",$<strval>1);} 
;

%%

void yyerror (char* s)
{
  printf("%s: linea %d\n",s,yylineno);
  exit(1);
}

int main(){
  yyin = fopen("archivo.c","r");
  printf("\n");
  yyparse();
}
