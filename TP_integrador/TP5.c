#include "TP5.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

symrec *aux;
symrec *aux2;

//Definición de la función putsym

symrec *putsym (char const *sym_name, int sym_type)
{
  symrec *ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->type = sym_type;
  ptr->value.valor = 0;
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

//Definición de la función getsym

symrec *getsym (char const *sym_name)
{
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name, sym_name) == 0)
      return ptr;
  return 0;
}


// Definicion de la funcion para agregar variables a la TS

void declararVariable(char* nombre,char* tipo,char* valor){

    aux = putsym(strdup(nombre),TYP_VAR);
    aux->tipo = tipo;
    aux->value.valor = valor;
    printf("\tSe declara la variable %s de tipo %s con valor inicial %s\n",aux->name, aux->tipo, aux->value.valor);
}

int sonDelMismoTipo(char* tipo, char* tipo2){
    int comparacion = strcmp(tipo,tipo2);
    // 0 si son iguales , otro valor es que son distintas
    if(comparacion == 0)
        return 1;
    else 
        return 0;
};

void declararVariableIgualando(char * nombre1,char* tipo,char * nombre2){
    aux2 = getsym(nombre2);
 
    if(aux2 && sonDelMismoTipo(tipo, aux2->tipo)){
        // asignacion
        aux = putsym(strdup(nombre1),TYP_VAR);
        aux->value.valor = aux2->value.valor;
        aux->tipo = tipo;  

        printf("\tSe declara la variable %s de tipo %s con valor inicial %s\n", aux->name, aux->tipo, aux->value.valor);
    }
    else if(aux2 && !sonDelMismoTipo(tipo, aux2->tipo))
    {
        printf("\n\tERROR EN CONTROL DE TIPOS DE DATOS EN LA ASIGNACION.\n\n");
    }
    else{
        printf("\n\tERROR: NO EXISTE LA VARIABLE %s DE LA ASIGNACION.\n\n", nombre2);
    }
    
};

