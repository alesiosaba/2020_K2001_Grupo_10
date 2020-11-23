#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int cadenaErrorLexico = 1;

//////////////////////////  CARACTERES NO RECONOCIDOS  ////////////////////////////////////

struct nodoCarNoReconocidos{
	char* cadena;
	int linea;
	struct nodoCarNoReconocidos* sig;		
};

struct nodoCarNoReconocidos *primerCarNoReconocido = NULL;

void insertarCarNoReconocidos(char* cadena,int linea){
    struct nodoCarNoReconocidos *nuevo;
    nuevo = (struct nodoCarNoReconocidos*)malloc(sizeof(struct nodoCarNoReconocidos));
    nuevo->cadena = strdup(cadena);
    nuevo->linea = linea;
    nuevo->sig = NULL;

    if(primerCarNoReconocido == NULL){
        primerCarNoReconocido = nuevo;
    }
    else{
        struct nodoCarNoReconocidos* aux;
        aux = primerCarNoReconocido;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

char cadenaNoReconocidos[100]="";
int lineaAnterior;

void caracNoReconocidos(char* caracterNoReconocido,int linea){
    
    if(cadenaErrorLexico)
    {
        strcat(cadenaNoReconocidos,caracterNoReconocido);
        lineaAnterior = linea;
    }
    else
    {
        insertarCarNoReconocidos(cadenaNoReconocidos,lineaAnterior);
        strcpy(cadenaNoReconocidos,"");
        cadenaErrorLexico = 1;

        strcat(cadenaNoReconocidos,caracterNoReconocido);
        lineaAnterior = linea;
    }
}

void reporteCaracNoReconocidos(){
    
    printf("\n\t----------------------Errores Lexicos----------------------\n\n");
    if(primerCarNoReconocido == NULL)
        printf("\tNo se encontraron cadenas de caracteres no reconocidos (Errores Lexicos)\n\n");
    else{
        cadenaErrorLexico = 0;
        caracNoReconocidos(" ",1);
        struct nodoCarNoReconocidos* aux;
        aux = primerCarNoReconocido;
        while(aux != NULL){
            if(strcmp(aux->cadena , "") != 0)
                printf("\tCadena: %s\tlinea: %d\n",aux->cadena,aux->linea);
            aux = aux->sig;
        }
    }
}
