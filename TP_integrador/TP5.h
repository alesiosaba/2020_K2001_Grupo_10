#ifndef TP5_H
#define TP5_H

#define TYP_VAR 0
#define TYP_FNCT 1

// Definición de un tipo de dato denominado func_t que es de tipo puntero a función

typedef struct func_t {
  struct param *listaParametros; 
} func_t;

// Definición de un tipo de dato denominado param para los parametros de entrada

typedef struct param {
    char* tipo;
    struct param* next; 
} param;

// Definición de un tipo de dato denominado param para los parametros de entrada

typedef struct arg {
    char* tipo;
    struct arg* next; 
} arg;

// Definición de la estructura de los nodos de la TS, la denominamos symrec.

typedef struct symrec {
  char *name;
  int type;         //Tenemos dos tipos: Variable (TYP_VAR) o Función (TYP_FNCT)
  char *tipo;       // Se guarda el tipo ya sea funcion o variable  
  union
  {
    char* valor;               //Si es una variable, se guarda su valor  
    struct func_t fnctptr;     //Si es una función, se almacena un puntero a una función
  } value;
  struct symrec *next; //Puntero al siguiente nodo de la lista
} symrec;

//Se utiliza para exponer variables pertenecientes a un archivo a uno o varios archivos adicionales. 
//Declaración de la variable sym_table que apunta a la TS

extern symrec *sym_table;

//Declaración de la función putsym para agregar símbolo a la TS

symrec *putsym (char const *, int);

//Declaración de la función getsym para tomar un símbolo de la TS

symrec *getsym (char const *, int);

#endif