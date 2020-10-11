%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>
#define YYDEBUG 1

extern int lineno;
int flag_error=0;
int contador=0;
char* tipoSentencia = NULL;

// Llamada por yyparse ante un error 
void yyerror(char const *s){  //Con yyerror se detecta el error sintáctico     
    printf("Error: %s\n",s);
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
%token OP_ASIG_AND_BIT
%token OP_ASIG_POTENCIA
%token OP_ASIG_OR_BIT
%token OP_ASIG_DESPLAZAMIENTO_IZQ
%token OP_ASIG_DESPLAZAMIENTO_DER
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

line:     '\n'
        | sentencia           {printf("Se detecto una sentencia de tipo: %s\n\n",tipoSentencia);} 
        | declaracion         {printf("Se detecto una declaracion\n\n");}  
;   

/*  GRAMATICA DE SENTENCIAS  */

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

listaDeSentencias:    sentencia
                    | listaDeSentencias sentencia
;

sentenciaDeSeleccion:   TKN_IF '(' expresion ')' sentencia                    
                      | TKN_IF '(' expresion ')' sentencia TKN_ELSE sentencia 
                      | TKN_SWITCH '(' IDENTIFICADOR ')' sentencia            
;

sentenciaDeIteracion:   TKN_WHILE '(' expresion ')' sentencia                             
                      | TKN_DO sentencia TKN_WHILE '(' expresion ')' ';'                  
                      | TKN_FOR '(' ';' ';' ')' sentencia                                 
                      | TKN_FOR '(' expresion ';' ';' ')' sentencia                       
                      | TKN_FOR '('  ';' expresion ';' ')' sentencia                      
                      | TKN_FOR '('  ';' ';' expresion ')' sentencia                      
                      | TKN_FOR '(' expresion ';' expresion ';' ')' sentencia             
                      | TKN_FOR '(' expresion ';'  ';' expresion ')' sentencia            
                      | TKN_FOR '('  ';' expresion ';' expresion ')' sentencia            
                      | TKN_FOR '(' expresion ';' expresion ';' expresion ')' sentencia   
;

sentenciaEtiquetada:    TKN_CASE expresionConstante ':' sentencia 
                      | TKN_DEFAULT ':' sentencia                 
                      | IDENTIFICADOR ':' sentencia               
; 

sentenciaDeSalto:   TKN_CONTINUE ';'            
                  | TKN_BREAK ';'               
                  | TKN_RETURN ';'              
                  | TKN_RETURN expresion ';'    
                  | TKN_GOTO IDENTIFICADOR ';'  
;

/*  GRAMATICA DE EXPRESIONES  */

expresion:    expresionDeAsignacion   
            | expresion ',' expresionDeAsignacion 
;

expresionDeAsignacion:    expresionCondicional  
                        | expresionUnaria operadorAsignacion expresionDeAsignacion
;

expresionCondicional:   expresionOlogico  
                      | expresionOlogico '?' expresion ':' expresionCondicional
;

operadorAsignacion: '=' 
                    | OP_ASIG_MULTIPLICACION
                    | OP_ASIG_DIVISION
                    | OP_ASIG_RESTO
                    | OP_ASIG_SUMA
                    | OP_ASIG_RESTA
                    | OP_ASIG_DESPLAZAMIENTO_IZQ
                    | OP_ASIG_DESPLAZAMIENTO_DER
                    | OP_ASIG_AND_BIT
                    | OP_ASIG_OR_BIT
                    | OP_ASIG_POTENCIA
;

expresionOlogico:   expresionYlogico  
                  | expresionOlogico OP_OR expresionYlogico
;

expresionYlogico:   expresionOinclusivo 
                  | expresionYlogico OP_AND expresionOinclusivo
;

expresionOinclusivo:   expresionOexcluyente 
                     | expresionOinclusivo '|' expresionOexcluyente
;

expresionOexcluyente:   expresionY 
                      | expresionOexcluyente '^' expresionY
;

expresionY:   expresionDeIgualdad 
            | expresionY '&' expresionDeIgualdad
;

expresionDeIgualdad:    expresionRelacional 
                      | expresionDeIgualdad OP_IGUALDAD expresionRelacional
                      | expresionDeIgualdad OP_DESIGUALDAD expresionRelacional
;

expresionRelacional:      expresionDeCorrimiento  
                        | expresionRelacional '<' expresionDeCorrimiento
                        | expresionRelacional '>' expresionDeCorrimiento
                        | expresionRelacional OP_MENOR_IGUAL expresionDeCorrimiento
                        | expresionRelacional OP_MAYOR_IGUAL expresionDeCorrimiento
;

expresionDeCorrimiento:     expresionAditiva  
                          | expresionDeCorrimiento OP_DESPLAZAMIENTO_IZQ expresionAditiva 
                          | expresionDeCorrimiento OP_DESPLAZAMIENTO_DER expresionAditiva
;

expresionAditiva:     expresionMultiplicativa 
                    | expresionAditiva '+' expresionMultiplicativa 
                    | expresionAditiva '-' expresionMultiplicativa
;

expresionMultiplicativa:    expresionDeConversion 
                          | expresionMultiplicativa '*' expresionDeConversion
                          | expresionMultiplicativa '/' expresionDeConversion
                          | expresionMultiplicativa OP_PORCENTAJE expresionDeConversion
;

expresionDeConversion:    expresionUnaria   
                        | '(' nombreDeTipo ')' expresionDeConversion
;

expresionUnaria:    expresionSufijo               
                  | OP_INC expresionUnaria
                  | OP_DEC expresionUnaria
                  | operadorUnario expresionDeConversion 
                  | OP_SIZEOF expresionUnaria
                  | OP_SIZEOF '(' nombreDeTipo ')' 
;

operadorUnario:   '&' | '*' | '+' | '-' | '~' | '!' | '<'
;

expresionSufijo:    |  expresionPrimaria                          
                    |  expresionSufijo '[' expresion ']' 
                    |  expresionSufijo '(' listaDeArgumentos ')' 
                    |  expresionSufijo '(' ')' 
                    |  expresionSufijo '.' IDENTIFICADOR
                    |  expresionSufijo OP_ACCESO_ATRIBUTO IDENTIFICADOR 
                    |  expresionSufijo OP_INC 
                    |  expresionSufijo OP_DEC
;

listaDeArgumentos:    expresionDeAsignacion                         
                    | listaDeArgumentos ',' expresionDeAsignacion  
;

expresionPrimaria:    IDENTIFICADOR               
                    | expresionConstante           
                    | LITERAL_CADENA               
                    | '(' expresion ')'             
;

expresionConstante:   ENTERO                  
                    | NUM                     
                    | CONST_CARACTER          
;

/*  GRAMATICA DE DECLARACIONES  */                    

declaracion:  especificadoresDeDeclaracion listaDeDeclaradores ';'    
            | especificadoresDeDeclaracion                       
;   

especificadoresDeDeclaracion:   especificadorDeClaseDeAlmacenamiento especificadoresDeDeclaracion
                              | especificadorDeClaseDeAlmacenamiento
                              | especificadorDeTipo especificadoresDeDeclaracion
                              | especificadorDeTipo
                              | calificadorDeTipo especificadoresDeDeclaracion
                              | calificadorDeTipo
;

listaDeDeclaradores:  declarador
                    | listaDeDeclaradores ',' declarador
;

declarador:   decla
            | decla '=' inicializador
;

inicializador:  expresionDeAsignacion
              | '{' listaDeInicializadores '}'
              | '{' listaDeInicializadores ',' '}'
;

listaDeInicializadores:   inicializador
                        | listaDeInicializadores ',' inicializador
;

especificadorDeClaseDeAlmacenamiento: CLASE_ALMACENAMIENTO
;

especificadorDeTipo:  TIPO_DE_DATO
                    | especificadorDeStructOUnion
                    | especificadorDeEnum
                    | nombreDeTypedef
;

calificadorDeTipo:  TKN_CONST
                  | TKN_VOLATILE
;

especificadorDeStructOUnion:  structOUnion IDENTIFICADOR '{' listaDeDeclaracionesStruct '}'
                            | structOUnion '{' listaDeDeclaraciones '}'
                            | structOUnion IDENTIFICADOR
;

structOUnion:   TKN_STRUCT
              | TKN_UNION
;

listaDeDeclaracionesStruct:   declaracionStruct
                            | listaDeDeclaracionesStruct declaracionStruct
;

declaracionStruct: listaDeCalificadores declaradoresStruct
;

listaDeCalificadores:   especificadorDeTipo listaDeCalificadores
                      | especificadorDeTipo
                      | calificadorDeTipo listaDeCalificadores
                      | calificadorDeTipo
;

declaradoresStruct:   declaStruct
                    | declaradoresStruct ',' declaStruct
;

declaStruct:  decla
            | decla ':' expresionConstante
            | ':' expresionConstante
;

decla:  puntero declaradorDirecto
      | declaradorDirecto
;

puntero:  '*' listaDeCalificadoresTipos
        | '*'
        | '*' listaDeCalificadoresTipos puntero
        | '*' puntero
;

listaDeCalificadoresTipos:  calificadorDeTipo
                          | listaDeCalificadoresTipos calificadorDeTipo
;                          

declaradorDirecto:   IDENTIFICADOR                  
                    | '(' decla ')'                     
                    | declaradorDirecto '[' expresionConstante ']'
                    | declaradorDirecto '[' ']'
                    | declaradorDirecto '(' listaTiposParametros ')' declaradorDirecto '(' listaDeIdentificadores ')'
                    | declaradorDirecto '(' listaTiposParametros ')' declaradorDirecto '(' ')'
;

listaTiposParametros:   listaDeParametros                     
                       | listaDeParametros OP_PARAMETROS_MULTIPLES   
;

listaDeParametros:   declaracionDeParametro
                    | listaDeParametros ',' declaracionDeParametro
;

declaracionDeParametro:   especificadoresDeDeclaracion decla
                         | especificadoresDeDeclaracion declaradorAbstracto
                         | especificadoresDeDeclaracion
;

listaDeIdentificadores:   IDENTIFICADOR
                         | listaDeIdentificadores ',' IDENTIFICADOR
;

especificadorDeEnum:  TKN_ENUM IDENTIFICADOR '{' listaDeEnumeradores '}'
                      | TKN_ENUM '{' listaDeEnumeradores '}'
                      | TKN_ENUM IDENTIFICADOR
;

listaDeEnumeradores:   enumerador
                      | listaDeEnumeradores ',' enumerador
;

enumerador:   constanteDeEnumeracion
             | constanteDeEnumeracion '=' expresionConstante
;

constanteDeEnumeracion:   IDENTIFICADOR
;

nombreDeTypedef:   IDENTIFICADOR
;

nombreDeTipo:   listaDeCalificadores declaradorAbstracto
               | listaDeCalificadores
;

declaradorAbstracto:   puntero
                      | puntero declaradorAbstractoDirecto
                      | declaradorAbstractoDirecto
;

declaradorAbstractoDirecto:   '(' declaradorAbstracto ')'
                             | declaradorAbstractoDirecto '[' expresionConstante ']'
                             | declaradorAbstractoDirecto '[' ']'
                             | '[' expresionConstante ']'
                             | '[' ']'
                             | declaradorAbstractoDirecto '(' listaTiposParametros ')'
                             | declaradorAbstractoDirecto '(' ')'
                             | '(' listaTiposParametros ')'
                             | '(' ')'
;

%%

int main(){
  yyin = fopen("archivo.c","r");

  #ifdef BISON_DEBUG
    yydebug = 1;
  #endif

  yyparse();
}
