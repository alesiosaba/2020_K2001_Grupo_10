#include <stdio.h>
#include <string.h>
#include <stdlib.h> 
#include <math.h>
#include <ctype.h> 

/////////////////////////////////   CONSTANTES   /////////////////////////////////

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

/////////////////////////////////   CONSTANTES DECIMALES   /////////////////////////////////

void insertarConstanteDecimal(char* cadena){
    struct nodoConstante *nuevo;
    nuevo = (struct nodoConstante*)malloc(sizeof(struct nodoConstante));
    nuevo->cadena = strdup(cadena);
    // strdup hace malloc((strlen(cadena)+1)*sizeof(char)); y strcpy(nuevo->cadena,cadena);
    nuevo->valor = atoi(cadena);
    nuevo->sig = NULL;

    if(primerDecimal == NULL){
        primerDecimal = nuevo;
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

/////////////////////////////////   CONSTANTES OCTALES   /////////////////////////////////

void insertarConstanteOctal(char* cadena){
    struct nodoConstante *nuevo;
    nuevo = (struct nodoConstante*)malloc(sizeof(struct nodoConstante));
    nuevo->cadena = strdup(cadena);
    nuevo->valor = strtol(cadena,NULL,8);
    nuevo->sig = NULL;

    if(primerOctal == NULL){
        primerOctal = nuevo;
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

/////////////////////////////////   CONSTANTES HEXADECIMALES   /////////////////////////////////

void insertarConstanteHexadecimal(char* cadena){
    struct nodoConstante *nuevo;
    nuevo = (struct nodoConstante*)malloc(sizeof(struct nodoConstante));
    nuevo->cadena = strdup(cadena);
    nuevo->valor = strtol(cadena,NULL,16);
    nuevo->sig = NULL;

    if(primerHexadecimal == NULL){
        primerHexadecimal = nuevo;
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

/////////////////////////////////   CONSTANTES REALES  /////////////////////////////////

void insertarConstanteReal(char* cadena){
    struct nodoConstante *nuevo;
    nuevo = (struct nodoConstante*)malloc(sizeof(struct nodoConstante));
    nuevo->cadena = strdup(cadena);
    nuevo->sig = NULL;

    if(primerReal == NULL){
        primerReal = nuevo;
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

////////////////////   CONSTANTES CARACTER   ///////////////////

void insertarConstanteCaracter(char* cadena){
    struct nodoConstante *nuevo;
    nuevo = (struct nodoConstante*)malloc(sizeof(struct nodoConstante));
    nuevo->cadena = strdup(cadena);
    nuevo->sig = NULL;

    if(primerCaracter == NULL){
        primerCaracter = nuevo;
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
        while(aux != NULL){
            printf("%s\n",aux->cadena);
            aux = aux->sig;
        }
    }
}

/////////////////////////////////   LITERALES CADENAS   /////////////////////////////////

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
    nuevo->sig = NULL;

    if(primerLiteralCadena == NULL){
        primerLiteralCadena = nuevo;
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
            printf("%s\tLongitud: %d\n",aux->cadena,aux->longitud);
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
    nuevo->sig = NULL;

    if(primerPalabraReservada == NULL){
        primerPalabraReservada = nuevo;
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

/////////////////////////////////   OPERADORES Y CARACTERES DE PUNTUACION   /////////////////////////////////

struct nodoOpCarPuntc{
    char* cadena;
    int cantidad;
    struct nodoOpCarPuntc *sig; 
};

struct nodoOpCarPuntc* primerOpCarPuntc = NULL;

void insertarOperadorCaracterPuntc(char* cadena){
    if(primerOpCarPuntc == NULL){
        
        struct nodoOpCarPuntc* nuevo;
        nuevo = (struct nodoOpCarPuntc*)malloc(sizeof(struct nodoOpCarPuntc));
        nuevo->cadena = strdup(cadena);
        // strdup hace malloc((strlen(cadena)+1)*sizeof(char)); y strcpy(nuevo->cadena,cadena);
        nuevo->cantidad = 1;
        nuevo->sig = NULL;
        primerOpCarPuntc = nuevo; 
    }
    else{
        struct nodoOpCarPuntc* aux = primerOpCarPuntc;
        while((strcmp(cadena,aux->cadena) != 0) && aux->sig != NULL){ // si no existe el caracter y NO estoy parado en el ultimo de la lista
            aux = aux->sig;
        }

        if(aux->sig == NULL){ // si estoy parado en el ultimo de la lista
            struct nodoOpCarPuntc* nuevo;
            nuevo = (struct nodoOpCarPuntc*)malloc(sizeof(struct nodoOpCarPuntc));
            nuevo->cadena = strdup(cadena);
            // strdup hace malloc((strlen(cadena)+1)*sizeof(char)); y strcpy(nuevo->cadena,cadena);
            nuevo->cantidad = 1;
            nuevo->sig = NULL;
            aux->sig = nuevo;
        }
        else{ // si ya existe el caracter
            aux->cantidad = aux->cantidad +1;
        }
    }
}

void operadoresCaracteresPuntc(char* cadena){
    insertarOperadorCaracterPuntc(cadena);
}

void reporteOperadoresCaracteresPuntc(){
    printf("\nReporte Operadores/Caracteres de Puntuacion\n\n");
    struct nodoOpCarPuntc* aux = primerOpCarPuntc;
    if(primerOpCarPuntc==NULL)
        printf("\tNo se encontraron Operadores/Caracteres de Puntuacion\n");
    while(aux != NULL){
        printf("Operador/Caracter: %s\tCantidad: %d\n",aux->cadena,aux->cantidad);
        aux = aux->sig;
    }
} 

//////////////////////////  IDENTIFICADORES  ////////////////////////////////////

struct nodoID{
	char* cadena;
	int cantidad;
	struct nodoID* sig;		
};

struct nodoID* primerID = NULL;

int buscarIdentificador(char* cadena){
	struct nodoID* aux = primerID;
	while(strcmp(cadena,aux->cadena)!=0 && aux->sig != NULL){
		aux = aux->sig;
	}
	
	if(strcmp(cadena,aux->cadena)==0){
		aux->cantidad = aux->cantidad + 1;
		return 1;
	}
	else if(aux->sig == NULL){
		return 0;
	}		
}

int criterioOrdenamiento(char* cadena1,char* cadena2){
	
	int resultado = strcasecmp(cadena1,cadena2); 
	
	if(resultado < 0)		// Si minuscula1 tiene menor ascii devuelve < 0    	ej: a y z 
		return 0;
	else if(resultado > 0)	// Si minuscula1 tiene mayor ascii devuelve > 0		ej: z y a
		return 1;
	else{ // Caso cuando en minusculas son iguales			ej: A y a
		resultado = strcmp(cadena1,cadena2); // Comparo con las cadenas originales
		if(resultado < 0)
			return 0;   // Devuelve 0 cuando cadena1 es mayus antes de cadena2 	ej: A y a
		else 
			return 1;	// Devuelve 1 cuando cadena1 es mayus despues de cadena2 	ej: a y A
	}
}

void insertarIdentificadorOrdenado(char* cadena){
	if(primerID == NULL){ // si la lista esta vacia
		struct nodoID* nuevo;
		nuevo = (struct nodoID*)malloc(sizeof(struct nodoID));
        nuevo->cadena = strdup(cadena);
        // strdup hace malloc((strlen(cadena)+1)*sizeof(char)); y strcpy(nuevo->cadena,cadena);
		primerID = nuevo;
		strcpy(primerID->cadena,cadena);
		primerID->cantidad = 1;
		primerID->sig = NULL;
	}
	else{
		if(!(criterioOrdenamiento(cadena,primerID->cadena))){ // si el ID a insertar es el nuevo primero (o sea no tendria que avanzar con el criterio de ordenamiento)
			struct nodoID* nuevo;
			nuevo = (struct nodoID*)malloc(sizeof(struct nodoID));
        	nuevo->cadena = strdup(cadena);
        	// strdup hace malloc((strlen(cadena)+1)*sizeof(char)); y strcpy(nuevo->cadena,cadena);
			nuevo->sig = primerID;
			nuevo->cantidad = 1;
			primerID = nuevo;
		}
		else if(!buscarIdentificador(cadena)){ // si el ID ya estaba en la lista lo incremento de cantidad
			// si el ID no estaba en la lista lo inserto ordenado
			struct nodoID* aux = primerID;
			while(aux->sig != NULL && criterioOrdenamiento(cadena,aux->sig->cadena)){ // busco la posicion donde insertar el ID
				aux = aux->sig;
			}
			struct nodoID* nuevo;
			nuevo = (struct nodoID*)malloc(sizeof(struct nodoID));
        	nuevo->cadena = strdup(cadena);
        	// strdup hace malloc((strlen(cadena)+1)*sizeof(char)); y strcpy(nuevo->cadena,cadena);
			nuevo->cantidad = 1;
			nuevo->sig = aux->sig;
			aux->sig = nuevo;				
		}	
	}
}

void identificadores(char* cadena){
    insertarIdentificadorOrdenado(cadena);
}

void reporteIdentificadores(){
    printf("\nReporte Identificadores\n\n");
	struct nodoID* aux;
	aux = primerID;
	while(aux != NULL){
		printf("Identificador: %s\tcantidad: %d\n",aux->cadena,aux->cantidad);
		aux = aux->sig;
	}
    if (primerID == NULL){
        printf("\tNo se encontraron identificadores\n");
        }
}

//////////////////////////  COMENTARIOS  ////////////////////////////////////

struct nodoComentarios{
	char* cadena;
	char* tipo;
	struct nodoComentarios* sig;		
};

struct nodoComentarios *primerComentario = NULL;

void insertarComentarios(char* cadena,char* tipo){
    struct nodoComentarios *nuevo;
    nuevo = (struct nodoComentarios*)malloc(sizeof(struct nodoComentarios));
    nuevo->cadena = strdup(cadena);
    nuevo->tipo = tipo;
    nuevo->sig = NULL;

    if(primerComentario == NULL){
        primerComentario = nuevo;
    }
    else{
        struct nodoComentarios* aux;
        aux = primerComentario;

        while(aux->sig != NULL){
            aux = aux->sig;
        }
        aux->sig = nuevo;
    }
}

void comentarios(char* cadena,char* tipo){
    insertarComentarios(cadena,tipo);
}

void reporteComentarios(){
    printf("\nReporte Comentarios\n\n");
    if(primerComentario == NULL)
        printf("\tNo se encontraron comentarios\n");
    else{
        struct nodoComentarios* aux;
        aux = primerComentario;
        while(aux != NULL){
            printf("%s\n%s\n\n",aux->tipo,aux->cadena);
            aux = aux->sig;
        }
    }
}

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

void caracNoReconocidos(char* caracterNoReconocido,int linea){
    
    // Cuando el caracter no reconocido NO es un espacio y NO es un salto de linea
    if(strcmp(caracterNoReconocido," ")!=0 && strcmp(caracterNoReconocido,"\n")!=0){ 
        strcat(cadenaNoReconocidos,caracterNoReconocido);
    }
    else{            
        if(strcmp(cadenaNoReconocidos,"")!=0){ // Cuando la cadena de no reconocidos no está vacia
            if(strcmp(caracterNoReconocido," ")==0) // Cuando el caracter no reconocido es un espacio
                insertarCarNoReconocidos(cadenaNoReconocidos,linea);
            else                                    // Cuando el caracter no reconocido es un salto de linea
                insertarCarNoReconocidos(cadenaNoReconocidos,linea-1);
            
            strcpy(cadenaNoReconocidos,"");
        }
    }
}

void reporteCaracNoReconocidos(){
    printf("\nReporte Cadenas de caracteres no reconocidos\n\n");
    if(primerCarNoReconocido == NULL)
        printf("\tNo se encontraron cadenas de caracteres no reconocidos\n\n");
    else{
        struct nodoCarNoReconocidos* aux;
        aux = primerCarNoReconocido;
        while(aux != NULL){
            printf("Cadena: %s\tlinea: %d\n",aux->cadena,aux->linea);
            aux = aux->sig;
        }
    }
}

//////////////////////////  REPORTES  ////////////////////////////////////

void ejecutarReportes(){
    reportePalabrasReservadas();
    reporteLiteralesCadena();
    reporteConstantesDecimales();
    reporteConstantesOctales();
    reporteConstantesHexadecimales();
    reporteConstantesReales();
    reporteConstantesCaracter();
    reporteOperadoresCaracteresPuntc();
    reporteIdentificadores();
    reporteComentarios();
    reporteCaracNoReconocidos();
}
