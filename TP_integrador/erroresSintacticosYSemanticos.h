#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//////////////////////////  ERRORES SINTACTICOS ////////////////////////////////////

struct nodoError{
	char mensaje[100];  // Error semantico en linea o Error sintactico en linea  
	int linea;
	struct nodoError* sig;		
};

struct nodoError *primerErrorSintactico = NULL;

void insertarErrorSintactico(char* mensaje,int linea){   
    struct nodoError *nuevo;
    nuevo = (struct nodoError*)malloc(sizeof(struct nodoError));
    strcpy(nuevo->mensaje,mensaje);
    nuevo->linea = linea;
    nuevo->sig = NULL;

    if(primerErrorSintactico == NULL){
        primerErrorSintactico = nuevo;
    }
    else{
        struct nodoError* aux;
        aux = primerErrorSintactico;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

void reporteErroresSintacticos(){
    
    printf("\n\t----------------------Errores Sintacticos----------------------\n\n");
    if(primerErrorSintactico == NULL)
        printf("\tNo se encontraron errores sintacticos\n\n");
    else{
        struct nodoError* aux;
        aux = primerErrorSintactico;
        while(aux != NULL){
            printf("\t%s\tlinea: %d\n",aux->mensaje,aux->linea);
            aux = aux->sig;
        }
    }
}

//////////////////////////  ERRORES SEMANTICOS ////////////////////////////////////

struct nodoError *primerErrorSemantico = NULL;

void insertarErrorSemantico(char* mensaje,int linea){   
    struct nodoError *nuevo;
    nuevo = (struct nodoError*)malloc(sizeof(struct nodoError));
    strcpy(nuevo->mensaje,mensaje);
    nuevo->linea = linea;
    nuevo->sig = NULL;

    if(primerErrorSemantico == NULL){
        primerErrorSemantico = nuevo;
    }
    else{
        struct nodoError* aux;
        aux = primerErrorSemantico;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

void reporteErroresSemanticos(){
    printf("\n\t----------------------Errores Semanticos----------------------\n\n");
    if(primerErrorSemantico == NULL)
        printf("\tNo se encontraron errores semanticos\n\n");
    else{
        struct nodoError* aux;
        aux = primerErrorSemantico;
        while(aux != NULL){
            printf("\t%s\ten la linea: %d\n",aux->mensaje,aux->linea);
            aux = aux->sig;
        }
    }
}