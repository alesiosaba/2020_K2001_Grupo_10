%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>

int flag_error=0;
int contador=0;

int yylex();
int yyerror (char *s);
int yywrap(){
    return(1);
}

%}

%union
{
    int entero; 
    float real;
}

%start input

%token <real> TKN_NUM

%type <real> input
%type <real> Expresion

%left TKN_MAS TKN_MENOS
%left TKN_MULT TKN_DIV

%% /* A continuacion las reglas gramaticales y las acciones */

input:    /* vacio */
        | input line
;

line:     '\n'
        | exp '\n'  { printf ("\t %d\n", $1); }
;

exp:      NUM             { $$ = $1;         }
        | exp exp '+'     { $$ = $1 + $2;    }
        | exp exp '-'     { $$ = $1 - $2;    }
        | exp exp '*'     { $$ = $1 * $2;    }
        | exp exp '/'     { $$ = $1 / $2;    }
        | exp exp '^'     { $$ = pow ($1, $2); }

%%

// Define variable puntero que apunta a la tabla de símbolos (TS).

symrec *sym_table;

// Define una estructura para cargar en la TS las funciones aritméticas.

struct init
{
  char const *fname;
  double (*fnct) (double);
};

// Declaramos una vector de tipo init llamado arith_fncts para almacenar todas las funciones en la TS.

struct init const arith_fncts[] =
{
  { "atan", atan },
  { "cos",  cos  },
  { "exp",  exp  },
  { "ln",   log  },
  { "sin",  sin  },
  { "sqrt", sqrt },
  { 0, 0 },
};

//Definimos la función init_table para cargar el vector de funciones en la TS.

static void init_table(){
  int i;
  for (i = 0; arith_fncts[i].fname != 0; i++)
    {
      symrec *ptr = putsym (arith_fncts[i].fname, TYP_FNCT);
      ptr->value.fnctptr = arith_fncts[i].fnct;
    }  
}

/* Llamada por yyparse ante un error */
int  yyerror(char *s){
    printf("Error %s",s);
}


int main(){
    yyin = fopen("archivo.c","r");

    init_table();

    #ifdef BISON_DEBUG
            yydebug = 1;
    #endif

    yyparse();
}
