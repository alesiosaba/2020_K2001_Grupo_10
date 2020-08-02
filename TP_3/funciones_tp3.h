#include <stdio.h>
#include <string.h>
#include <stdlib.h> 
#include <math.h>

///////////////////////////////// CONSTANTES /////////////////////////////////
struct nodoConstante{
    char* cadena;
    int valor;
    struct nodoConstante *sig; 
};

struct nodoConstante *primerDecimal = NULL;
struct nodoConstante *primerOctal = NULL;
struct nodoConstante *primerHexadecimal = NULL;
struct nodoConstante *primerReal = NULL;
struct nodoConstante *primerCaracter = NULL;

void insertarConstanteDecimal(char* cadena){
    struct nodoConstante *nuevo;
    nuevo = (struct nodoConstante*)malloc(sizeof(struct nodoConstante));
    nuevo->cadena = strdup(cadena);
    // strdup hace malloc((strlen(cadena)+1)*sizeof(char)); y strcpy(nuevo->cadena,cadena);
    nuevo->valor = atoi(cadena);

    if(primerDecimal == NULL){
        primerDecimal = nuevo;
        nuevo->sig = NULL;
    }
    else{
        struct nodoConstante* aux;
        aux = primerDecimal;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

void constantesDecimales(char* cadena){
    insertarConstanteDecimal(cadena);
}

void reporteConstantesDecimales(){
    printf("\nReporte Constantes Decimales\n\n");
    if(primerDecimal==NULL)
        printf("\tNo se encontraron constantes decimales\n");
    else{
        int totalAcumulado = 0;
        struct nodoConstante* aux; 
    
        aux = primerDecimal; 
        while(aux != NULL){
            printf("Cadena: %s\tValor: %d\n",aux->cadena,aux->valor);
            totalAcumulado += aux->valor;
            aux = aux->sig;
        }    
        printf("Total acumulado: %d\n",totalAcumulado);
    }    
}

void insertarConstanteOctal(char* cadena){
    struct nodoConstante *nuevo;
    nuevo = (struct nodoConstante*)malloc(sizeof(struct nodoConstante));
    nuevo->cadena = strdup(cadena);
    nuevo->valor = strtol(cadena,NULL,8);

    if(primerOctal == NULL){
        primerOctal = nuevo;
        nuevo->sig = NULL;
    }
    else{
        struct nodoConstante* aux;
        aux = primerOctal;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

void constantesOctales(char* cadena){
    insertarConstanteOctal(cadena);
}

void reporteConstantesOctales(){
    printf("\nReporte Constantes Octales\n\n");
    if(primerOctal==NULL)
        printf("\tNo se encontraron constantes octales\n");
    else{
        struct nodoConstante* aux; 
        aux = primerOctal; 
        while(aux != NULL){
            printf("Cadena: %s\tValor: %d\n",aux->cadena,aux->valor);
            aux = aux->sig;
        }
    }
}

void insertarConstanteHexadecimal(char* cadena){
    struct nodoConstante *nuevo;
    nuevo = (struct nodoConstante*)malloc(sizeof(struct nodoConstante));
    nuevo->cadena = strdup(cadena);
    nuevo->valor = strtol(cadena,NULL,16);

    if(primerHexadecimal == NULL){
        primerHexadecimal = nuevo;
        nuevo->sig = NULL;
    }
    else{
        struct nodoConstante* aux;
        aux = primerHexadecimal;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

void constantesHexadecimales(char* cadena){
    insertarConstanteHexadecimal(cadena);
}

void reporteConstantesHexadecimales(){
    printf("\nReporte Constantes Hexadecimales\n\n");
    if(primerHexadecimal==NULL)
        printf("\tNo se encontraron constantes hexadecimales\n");
    else{
        struct nodoConstante* aux; 
        aux = primerHexadecimal; 
        while(aux != NULL){
            printf("Cadena: %s\tValor: %d\n",aux->cadena,aux->valor);
            aux = aux->sig;
        }
    }
}

void insertarConstanteReal(char* cadena){
    struct nodoConstante *nuevo;
    nuevo = (struct nodoConstante*)malloc(sizeof(struct nodoConstante));
    nuevo->cadena = strdup(cadena);
    if(primerReal == NULL){
        primerReal = nuevo;
        nuevo->sig = NULL;
    }
    else{
        struct nodoConstante* aux;
        aux = primerReal;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

void constantesReales(char* cadena){
    insertarConstanteReal(cadena);
}

void reporteConstantesReales(){
    int parteEntera;
    double parteDecimal;
    double valor;

    printf("\nReporte Constantes Reales\n\n");
    struct nodoConstante* aux; 
    if(primerReal==NULL)
        printf("\tNo se encontraron constantes reales\n");
    else{
        aux = primerReal; 
        while(aux != NULL)
        {
            valor = atof(aux->cadena);
            
            parteEntera = (int) valor;
            parteDecimal = valor - parteEntera;

            printf("Cadena: %s\tParte entera: %d\tParte decimal: %f\n", aux->cadena, parteEntera, parteDecimal);
            aux = aux->sig;
        }
    }
}


void insertarConstanteCaracter(char* cadena){
    struct nodoConstante *nuevo;
    nuevo = (struct nodoConstante*)malloc(sizeof(struct nodoConstante));
    nuevo->cadena = strdup(cadena);

    if(primerCaracter == NULL){
        primerCaracter = nuevo;
        nuevo->sig = NULL;
    }
    else{
        struct nodoConstante* aux;
        aux = primerCaracter;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

void constantesCaracter(char* cadena){
    insertarConstanteCaracter(cadena);
}

void reporteConstantesCaracter(){
    printf("\nReporte Constantes Caracter\n\n");
    if(primerCaracter==NULL)
        printf("\tNo se encontraron constantes caracter\n");
    else{
        struct nodoConstante* aux;
        aux = primerCaracter;
        int i=1; 
        while(aux != NULL){
            printf("-%d \t %s\n",i,aux->cadena);
            aux = aux->sig;
            i++;
        }
    }
}

///////////////////////////////// LITERALES CADENAS /////////////////////////////////
struct nodoLiteralCadena{
    char* cadena;
    int longitud;
    struct nodoLiteralCadena *sig; 
};
struct nodoLiteralCadena *primerLiteralCadena = NULL;

void insertarLiteralCadena(char* cadena){
    struct nodoLiteralCadena *nuevo;
    nuevo = (struct nodoLiteralCadena*)malloc(sizeof(struct nodoLiteralCadena));
    nuevo->cadena = strdup(cadena);
    nuevo->longitud = strlen(cadena)-2;

    if(primerLiteralCadena == NULL){
        primerLiteralCadena = nuevo;
        nuevo->sig = NULL;
    }
    else{
        struct nodoLiteralCadena* aux;
        aux = primerLiteralCadena;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

void literalesCadena(char* cadena){
    insertarLiteralCadena(cadena);
}

void reporteLiteralesCadena(){
    printf("\nReporte Literales cadena\n\n");
    if(primerLiteralCadena==NULL)
        printf("\tNo se encontraron literales cadena\n");
    else{
        struct nodoLiteralCadena* aux; 
        aux = primerLiteralCadena; 
        while(aux != NULL){
            printf("-%s\tLongitud: %d\n",aux->cadena,aux->longitud);
            aux = aux->sig;
        }
    }
}

/////////////////////////////////   PALABRAS RESERVADAS    /////////////////////////////////

struct nodoPalabraReservada{
    char* cadena;
    char* tipo;
    struct nodoPalabraReservada *sig; 
};
struct nodoPalabraReservada *primerPalabraReservada = NULL;

void insertarPalabraReservada(char* cadena,char* tipo){
    struct nodoPalabraReservada *nuevo;
    nuevo = (struct nodoPalabraReservada*)malloc(sizeof(struct nodoPalabraReservada));
    nuevo->cadena = strdup(cadena);
    nuevo->tipo = tipo;

    if(primerPalabraReservada == NULL){
        primerPalabraReservada = nuevo;
        nuevo->sig = NULL;
    }
    else{
        struct nodoPalabraReservada* aux;
        aux = primerPalabraReservada;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

void palabrasReservadas(char* cadena,char* tipo){
    insertarPalabraReservada(cadena,tipo);
}

void reportePalabrasReservadas(){
    printf("\nReporte Palabras Reservadas\n\n");
    if(primerPalabraReservada==NULL)
        printf("\tNo se encontraron palabras reservadas\n");
    else{
        struct nodoPalabraReservada* aux;
        aux = primerPalabraReservada;
        while(aux != NULL){
            printf("%s\t(%s)\n",aux->cadena,aux->tipo);
            aux = aux->sig;
        }
    }
}

/////////////////////////////////   OPERADORES Y CARACTERES DE PUNTUACION    /////////////////////////////////

/* struct nodoOpCarPuntc{
    char* cadena;
    int cantidad;
    struct nodoOpCarPuntc *sig; 
};

struct nodoOpCarPuntc *primerOpCarPuntc = NULL;

void insertarOperadorCaracterPuntc(char* cadena){

    if(primerOpCarPuntc == NULL){
        struct nodoOpCarPuntc *nuevo = (struct nodoOpCarPuntc*)malloc(sizeof(struct nodoOpCarPuntc));
        strcpy(nuevo->cadena,cadena);
        nuevo->sig = NULL;
        nuevo->cantidad = 1;
        primerOpCarPuntc = nuevo;
    }
    else{
        struct nodoOpCarPuntc* aux;
        aux = primerOpCarPuntc;

        while(aux->sig != NULL && (strcmp(aux->cadena,cadena) != 0)){  // Mientras los caracteres sean distintos y no sea el fin de la lista
            aux = aux->sig;
        }

        if(strcmp(aux->cadena,cadena) != 0){
            struct nodoOpCarPuntc *nuevo = (struct nodoOpCarPuntc*)malloc(sizeof(struct nodoOpCarPuntc));
            strcpy(nuevo->cadena,cadena);
            nuevo->sig = NULL;
            nuevo->cantidad = 1;
            aux->sig = nuevo;
        }
        else{
            aux->cantidad +=1;
        }   
    }
}

void operadoresCaracteresPuntc(char* cadena){
    insertarOperadorCaracterPuntc(cadena);
}

void reporteOperadoresCaracteresPuntc(){
    printf("\nReporte Operadores y Caracteres de Puntuacion\n\n");
    if(primerOpCarPuntc == NULL)
        printf("\tNo se encontraron operadores ni caracteres de puntuacion\n");
    else{
        struct nodoOpCarPuntc* aux;
        aux = primerOpCarPuntc;
        while(aux != NULL){
            printf("Op/Caracter: %s\tCantidad: %d\n",aux->cadena,aux->cantidad);
            aux = aux->sig;
        }
    }
} */


/////////////////////////////////   IDENTIFICADORES    /////////////////////////////////

struct nodoID{
    char* cadena;
    int cantidad;
    struct nodoID *sig; 
};
struct nodoID *primerID = NULL;

struct nodoID* buscar(struct nodoID* primerID, char* cadena){
    struct nodoID* p = primerID;
    while(p && strcmp(p->cadena,cadena)!=0)
        p=p->sig;
    if(p!=NULL && strcmp(p->cadena,cadena)==0)
        return p;
    return NULL;
}

struct nodoID *insertarIdentificadorOrdenado(char* cadena){
    struct nodoID *nuevo;
    nuevo = (struct nodoID*)malloc(sizeof(struct nodoID));
    nuevo->cadena = strdup(cadena);
    if(primerID==NULL || strcmp(cadena,(primerID->cadena))<0){
        nuevo->sig = primerID;
        primerID = nuevo;
    }
    else{
        struct nodoID *aux = primerID; // Primer posicion
        while (aux->sig !=NULL && strcmp(cadena,(aux->sig->cadena))>0)
            aux=aux->sig; // avanzo
        nuevo->sig=aux->sig;
        aux->sig=nuevo;
    }
    return nuevo;
}

void insertarSinRepetir(char* cadena)
{
    struct nodoID *p = buscar(primerID,cadena);
    if(p==NULL)
        p=insertarIdentificadorOrdenado(cadena);

}

void identificadores(char* cadena){
    insertarSinRepetir(cadena);
}

void reporteIdentificadores(){
     printf("\nReporte Identificadores\n\n");
    if(primerID == NULL)
        printf("\tNo se encontraron identificadores\n");
    else{
        struct nodoID* aux;
        aux = primerID;
        while(aux != NULL){
            printf("Identificador: %s\t\n",aux->cadena);
            aux = aux->sig;
        }
    }   
}

void ejecutarReportes(){
    reportePalabrasReservadas();
    reporteLiteralesCadena();
    reporteConstantesDecimales();
    reporteConstantesOctales();
    reporteConstantesHexadecimales();
    reporteConstantesReales();
    reporteConstantesCaracter();
    //reporteOperadoresCaracteresPuntc();
    reporteIdentificadores();
}