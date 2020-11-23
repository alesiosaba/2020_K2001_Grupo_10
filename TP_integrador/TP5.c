#include "TP5.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

symrec *aux;
symrec *aux2;
param *listaAuxParametros = NULL;
arg *listaAuxArgumentos = NULL;
int errorEnArgumento = 0;
//Definición de la función putsym

symrec *putsym (char const *sym_name, int sym_type)
{
  symrec *ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->type = sym_type;
  //ptr->value.valor;
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

//Definición de la función getsym

symrec *getsym (char const *sym_name, int sym_type)
{
    symrec *ptr;
    for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *)ptr->next)
        if (strcmp (ptr->name, sym_name) == 0 && ptr->type == sym_type )
            return ptr;
        return 0;
}


// Definicion de las funciones para agregar variables a la TS
void mostrarListaVar();

void declararVariable(char* nombre,char* tipo,char* valor){
    
    aux = putsym(strdup(nombre),TYP_VAR);
    aux->tipo = tipo;
    strcpy(aux->value.valor,valor);
    printf("\n\tSe declara la variable %s de tipo %s con valor inicial %s\n\n",aux->name, aux->tipo, aux->value.valor);
}


void declararVariableSinInicializar(char* nombre,char* tipo){
    aux = putsym(strdup(nombre),TYP_VAR);
    aux->tipo = tipo;
    strcpy(aux->value.valor,"");
    printf("\n\tSe declara la variable %s de tipo %s sin valor inicial\n\n",aux->name, aux->tipo);
}

int sonDelMismoTipo(char* tipo, char* tipo2){
    int comparacion = strcmp(tipo,tipo2);
    // 0 si son iguales , otro valor es que son distintas
    if(comparacion == 0)
        return 1;
    else 
        return 0;
};

// Se utiliza cuando declaramos una variable inicializando su valor con el de otra variable

void declararVariableIgualando(char * nombre1,char* tipo,char * nombre2){
    aux2 = getsym(nombre2,TYP_VAR);
 
    if(aux2 && sonDelMismoTipo(tipo, aux2->tipo)){
        // asignacion
        aux = putsym(strdup(nombre1),TYP_VAR);
        strcpy(aux->value.valor,aux2->value.valor);
        aux->tipo = tipo;  
        printf("\n\tSe declara la variable %s de tipo %s con valor inicial %s\n", aux->name, aux->tipo, aux->value.valor);
    }
    else if(aux2 && !sonDelMismoTipo(tipo, aux2->tipo))
    {
        printf("\n\tERROR EN CONTROL DE TIPOS DE DATOS EN LA ASIGNACION.\n\n");
    }
    else{
        printf("\n\tERROR: NO EXISTE LA VARIABLE %s DE LA ASIGNACION.\n\n", nombre2);
    }
    
};

void recorrerParametrosAuxiliar(struct param *listaAuxParametros){
    if(listaAuxParametros==NULL)
        printf("\tSin parametros\n\n");
    else{
        printf("\tSus parametros son: ");
        int totalAcumulado = 0;
        struct param* aux; 
        aux = listaAuxParametros;
        while(aux!=NULL){
            totalAcumulado ++;
            printf("%s ",aux->tipo);
            aux = aux->next;
        }
        printf("\tTotal: %d\n\n",totalAcumulado);
    }    
}

// Definicion de la funcion para agregar Funciones a la TS

void declaracionDeFuncion(char * id, char* tipo, struct param* parametros){

        aux = putsym(strdup(id),TYP_FNCT);
        aux->tipo = tipo;
        aux->value.fnctptr.listaParametros = parametros;
        printf("\n\tSe declara la funcion %s de tipo %s.\n",aux->name, aux->tipo);
        // informar nombre y tipo de cada parametro de la funcion
        recorrerParametrosAuxiliar(aux->value.fnctptr.listaParametros);
};

void agregarParametroAuxiliar(char* tipoParametro){
    struct param *nuevo;
    nuevo = (struct param*)malloc(sizeof(struct param));
    nuevo->tipo = strdup(tipoParametro);
    nuevo->next = NULL;

    if(listaAuxParametros == NULL){
        listaAuxParametros = nuevo;
    }
    else{
        struct param *aux;
        aux = listaAuxParametros;

        while(aux->next != NULL){
            aux = aux->next;
        }
        aux->next = nuevo;
    }
}

// Definicion de la funcion para recorrer lista de argumentos invocados
void recorrerArgumentosAuxiliar(struct arg *listaAuxArgumentos){
    if(listaAuxArgumentos==NULL)
        printf("sin argumentos\n\n");
    else{
        printf(".Sus argumentos son: ");
        int totalAcumulado = 0;
        struct arg *aux; 
        aux = listaAuxArgumentos;
        while(aux!=NULL){
            totalAcumulado ++;
            printf("%s ,",aux->tipo);
            aux = aux->next;
        }
        printf("\tTotal: %d\n",totalAcumulado);
    }    
}

// Definicion de la funcion para generar lista de argumentos invocados
void agregarArgumentoAuxiliar(char* tipoArgumento){
    struct arg *nuevo;
    nuevo = (struct arg*)malloc(sizeof(struct arg));
    nuevo->tipo = strdup(tipoArgumento);
    nuevo->next = NULL;

    if(listaAuxArgumentos == NULL){
        listaAuxArgumentos = nuevo;
    }
    else{
        struct arg *aux;
        aux = listaAuxArgumentos;

        while(aux->next != NULL){
            aux = aux->next;
        }
        aux->next = nuevo;
    }
}

// verificacion de los parametros al invocar una funcion 

int invocacionCorrecta(struct symrec *funcionInvocada){
  // listaAuxArgumentos
  // listaAuxParametros

  struct arg *auxArgumentos;
  struct param *auxParametros;

  auxArgumentos = listaAuxArgumentos;
  auxParametros = funcionInvocada->value.fnctptr.listaParametros;

  while(auxArgumentos != NULL && auxParametros != NULL)
  {
    if(strcmp(auxArgumentos->tipo,auxParametros->tipo)!=0){
      printf("\nNo coinciden los tipos de argumentos de en la invocacion\n");
      return 0;
    }
    auxArgumentos = auxArgumentos->next;
    auxParametros = auxParametros->next;
  }
  if( (auxArgumentos == NULL && auxParametros != NULL) || (auxArgumentos != NULL && auxParametros == NULL) )
  {
    printf("\nCantidad de argumentos de invocacion incorrecta\n");
    return 0;
  }
  else return 1;

  // Si es cero , la invocacion es incorrecta
  // Si es uno , la invocacion es correcta
  
}

void chequeoArgumento(char* id, int linea){
    symrec* auxArg=getsym(id,TYP_VAR); 
    char* mensajeError;

    if(auxArg == 0){
        mensajeError = strcat("\n\tERROR semantico: NO EXISTE LA VARIABLE %s DEL PARAMETRO \n",id);
        insertarErrorSemantico(mensajeError,linea);
        errorEnArgumento = 1;
    }
    else
        agregarArgumentoAuxiliar(auxArg->tipo);
}


int invocacion(char* id, int linea){

    int estadoChequeo = 1;
    char mensajeError[100];

    if(!errorEnArgumento) {
        aux=getsym(id,TYP_FNCT); 
        if (aux == 0){
            strcpy(mensajeError,"ERROR semantico: NO EXISTE LA FUNCION ");
            strcat(mensajeError,id);
            insertarErrorSemantico(mensajeError,linea);
            estadoChequeo = 0;
        }
        else if(aux && !invocacionCorrecta(aux)){
            strcpy(mensajeError,"ERROR semantico: ERROR DE INVOCACION DE FUNCION "); 
            strcat(mensajeError,id);
            insertarErrorSemantico(mensajeError,linea);
            estadoChequeo = 0;
        }
        else
            printf("Invocacion correcta de la funcion %s\n",id);
          
    }
    
    errorEnArgumento = 0;
    listaAuxArgumentos = NULL; 

    return estadoChequeo;
} 

// verificacion de tipos en una operacion binaria de asignacion

void verificacionDeTiposCorrecta(char* tipo1,char* tipo2, int linea){
    if(strcmp(tipo1,tipo2)==0) 
        printf("Se puede realizar la Operacion Binaria porque son del MISMO tipo.\n");
    else
        insertarErrorSemantico("ERROR SEMANTICO: NO se puede realizar la Operacion Binaria porque NO son del mismo tipo.\n",linea);
}

void mostrarListaVar(){
    symrec * auxTabla = sym_table;
    int contador = 1;
    printf("\n\t----------------------Variables declaradas----------------------\n\n");
    if(auxTabla == NULL)
        printf("\t No se encontraron variables\n");
    else
        while(auxTabla != NULL){
            if(auxTabla->type == TYP_VAR){
                printf("\t%d) %s %s ",contador,auxTabla->tipo,auxTabla->name);
                if(strcmp(auxTabla->value.valor,"")==0)
                    printf("sin valor\n");
                else
                    printf("con valor: %s\n",auxTabla->value.valor);
                contador++;
            }
            auxTabla = auxTabla->next;
        }
        printf("\n");
    }

void mostrarListaFunc(){
    symrec * auxTabla = sym_table;
    int contador = 1;
    printf("\n\t----------------------Funciones declaradas----------------------\n\n");
    if(auxTabla == NULL)
        printf("\t No se encontraron funciones.");
    else
        while(auxTabla != NULL){
            if(auxTabla->type == TYP_FNCT){
                printf("\t%d) %s %s\n",contador,auxTabla->tipo,auxTabla->name);
                recorrerParametrosAuxiliar(auxTabla->value.fnctptr.listaParametros);
                contador++;
            }
            auxTabla=auxTabla->next;
        }
        printf("\n");
    }


void generarReporte(){
    printf("A continuacion hacemos el reporte: \n");
    system("PAUSE");
    system("CLS");
    printf("\n\n\t*************************  REPORTE DE COMPILACION  *************\n\n");
    
    mostrarListaVar();
    mostrarListaFunc();
    reporteCaracNoReconocidos();
    reporteErroresSintacticos();
    reporteErroresSemanticos();
}














/* void mostrarTabla(){
    symrec * auxTabla = sym_table;
    int contador = 1;
    printf("\n\t----------------------Tabla----------------------\n\n");
    if(auxTabla == NULL)
        printf("\t No se encontro nada.");
    else
        while(auxTabla != NULL){
            printf("\t%d) %s %s ",contador,auxTabla->tipo,auxTabla->name);
            if(auxTabla->type == TYP_FNCT){
                recorrerParametrosAuxiliar(auxTabla->value.fnctptr.listaParametros);
            }
            else
                printf("%s\n",auxTabla->value.valor);
            contador++;
            auxTabla=auxTabla->next;
        }
        printf("\n");
    } */