#include <stdio.h>
#include <windows.h>

const int filas=7;
const int columnas=6; 

void MostrarTabla(int [][columnas]);
void ProcesarArchivoEntrada(FILE*, FILE*, int [][columnas]);
void EscribirTipoConstante(FILE*, int);
void AsignarEstado(int,int*,int [][columnas],int);

int main()
{
    int tablaTransiciones [7][6]={{2,1,1,6,6,6},
								  {1,1,1,6,6,6},
								  {5,5,6,3,6,6},
								  {4,4,4,6,4,6},
								  {4,4,4,6,4,6},
								  {5,5,6,6,6,6},
								  {6,6,6,6,6,6}};
	
	
	printf("Ver tabla de transiciones?\n1.Si\n0.No\n\nOpcion: ");
	int verTabla = scanf("%d", &verTabla);
	
	if(verTabla)
		MostrarTabla(tablaTransiciones);
		
    FILE * entrada = fopen("entrada.txt","rt");
	FILE * salida = fopen("salida.txt","wt");
	
	ProcesarArchivoEntrada(entrada,salida,tablaTransiciones);
	
	printf("Archivo de entrada procesado exitosamente\n");
	printf("Archivo de salida grabado exitosamente\n");
	
    return 0;
}

void ProcesarArchivoEntrada(FILE *entrada, FILE *salida, int tablaTransiciones[][columnas]){
	int estadoActual;
	int estadoAnterior;
	
	char caracter;
	caracter = fgetc(entrada);
    
	while(caracter != EOF){
		estadoActual = 0;
		estadoAnterior = 0;
		
		while(caracter != ',' && estadoActual != 6 && caracter != EOF)
		{
			// Caracter leido es '0'
        	if (caracter == '0')
        		AsignarEstado(estadoAnterior,&estadoActual,tablaTransiciones,0);
        	// Caracter leido es un [1-7] 
	        else if(caracter > '0' && caracter < '8')
	        	AsignarEstado(estadoAnterior,&estadoActual,tablaTransiciones,1);
	        // Caracter leido es un {8,9}
	        else if(caracter == '8' || caracter == '9')
	        	AsignarEstado(estadoAnterior,&estadoActual,tablaTransiciones,2);
	        // Caracter leido es un {xX}
	        else if(caracter == 'x' || caracter == 'X')
	        	AsignarEstado(estadoAnterior,&estadoActual,tablaTransiciones,3);
	        // Caracter leido es un [a-f A-F] 
	        else if(((caracter >= 'A' && caracter <= 'F') || (caracter >= 'a' && caracter < 'f')))
	        	AsignarEstado(estadoAnterior,&estadoActual,tablaTransiciones,4);
	        // Caracter leido no es admitido
	        else
	        	AsignarEstado(estadoAnterior,&estadoActual,tablaTransiciones,5);
			
			fflush(stdin);
			caracter = fgetc(entrada);
		}
		
		EscribirTipoConstante(salida,estadoActual);
		
		fflush(stdin);
		caracter = fgetc(entrada);	
		
		// Agregar coma despues de cada tipo de constante
		if(caracter != EOF && caracter != ',' ) 
			fputs(",",salida);
	}
	
	fclose(entrada); 
	fclose(salida);
}

void MostrarTabla(int tablaTransiciones[][columnas]){
	int i,j;
	printf("\nTabla de Transiciones: \n\n");
    for(i=0; i<filas ; i++)
    {
        printf("q%d  ",i);
        for(j=0;j<columnas;j++)
        {
            printf("q%d ",tablaTransiciones[i][j]);
        }
        printf("\n");
    }
    
    printf("\n");
    system("PAUSE");
    system("CLS");
}

void EscribirTipoConstante(FILE *salida, int estadoActual){
	switch (estadoActual){
		// Palabra no reconocida
		case 6:
			fputs("ERROR",salida);
			break;
		// Constante Decimal 
		case 1:
			fputs("Decimal",salida);
			break;
		// Constante Octal
		case 5:
		case 2:
			fputs("Octal",salida);
			break;
		// Constante Hexadecimal
		case 4:
			fputs("Hexadecimal",salida);
			break;			
	}
}

void AsignarEstado(int estadoAnterior, int *estadoActual, int tablaTransiciones[][columnas],int nuevoEstado){
	estadoAnterior = *estadoActual;
	*estadoActual = tablaTransiciones[estadoAnterior][nuevoEstado];
}


