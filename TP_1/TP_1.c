#include <stdio.h>
#include <windows.h>

const int filas=7;
const int columnas=6; 

void MostrarTabla(int [][columnas]);
void ProcesarArchivoEntrada(FILE*, FILE*, int [][columnas]);
void EscribirTipoConstante(FILE*, int);

int main()
{
    int tablaTransiciones [7][6]={{2,1,1,6,6,6},
								  {1,1,1,6,6,6},
								  {5,5,6,3,6,6},
								  {4,4,4,6,4,6},
								  {4,4,4,6,4,6},
								  {5,5,6,6,6,6},
								  {6,6,6,6,6,6}};
	
	printf("Ver tabla de transiciones?\n1.Si\n0.No\nOpcion: ");
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

void ProcesarArchivoEntrada(FILE *entrada, FILE *salida, int tablaTransiciones[][columnas])
{
	int estado;
	int auxEstado;
	
	char caracter;
	caracter = fgetc(entrada);
    
	while(caracter != EOF)
	{
		estado = 0;
		auxEstado = 0;
		
		while(caracter != ',' && estado != 6 && caracter != EOF)
		{
			//printf("%c",caracter);
   	    
			// Si viene un '0'
        	if (caracter == '0')
			{
				//printf("Viene un '0'\n");
				//printf("Estado parado: q%d\n",estado);
	        	auxEstado = estado;
	            estado = tablaTransiciones[auxEstado][0];
	            //printf("Voy a estado q%d\n",estado);
	            //system("PAUSE");
	            //system("CLS");
			}
        	// Si viene un [1-7] 
	        else if(caracter > '0' && caracter < '8')
	        {
	            //printf("Viene un [1-7]\n");
				//printf("Estado parado: q%d\n",estado);
	        	auxEstado = estado;
	            estado = tablaTransiciones[auxEstado][1];
	            //printf("Voy a estado q%d\n",estado);
	            //system("PAUSE");
	            //system("CLS");
	        }
	        // Si viene un {8,9}
	        else if(caracter == '8' || caracter == '9')
	        {
	            //printf("Viene un {8,9}\n");
				//printf("Estado parado: q%d\n",estado);
	        	auxEstado = estado;
	            estado = tablaTransiciones[auxEstado][2];
	            //printf("Voy a estado q%d\n",estado);
	            //system("PAUSE");
	            //system("CLS");
	        }
	        // Si viene un {xX}
	        else if(caracter == 'x' || caracter == 'X')
	        {
	            //printf("Viene un {xX}\n");
				//printf("Estado parado: q%d\n",estado);
	        	auxEstado = estado;
	            estado = tablaTransiciones[auxEstado][3];
	            //printf("Voy a estado q%d\n",estado);
	            //system("PAUSE");
	            //system("CLS");
	        }
	        // Si viene [a-f A-F] 
	        else if(((caracter >= 'A' && caracter <= 'F') || (caracter >= 'a' && caracter < 'f'))) 
	        {
	            //printf("Viene un [a-f A-F]\n");
				//printf("Estado parado: q%d\n",estado);
	        	auxEstado = estado;
	            estado = tablaTransiciones[auxEstado][4];
	            //printf("Voy a estado q%d\n",estado);
	            //system("PAUSE");
	            //system("CLS");
	        }
	        // Si viene un caracter no admitido
	        else
			{
				//printf("Viene un caracter no admitido\n");
				//printf("Estado parado: q%d\n",estado);
	        	auxEstado = estado;
	            estado = tablaTransiciones[auxEstado][5];
	            //printf("Voy a estado q%d\n",estado);
	            //system("PAUSE");
	            //system("CLS");
			}
			
			fflush(stdin);
			caracter = fgetc(entrada);
		}
		
		EscribirTipoConstante(salida,estado);
		
		fflush(stdin);
		caracter = fgetc(entrada);	
		
		if(caracter != EOF && caracter != ',' ) //Para que no agregue coma al final del archivo
			fputs(",",salida);
	}
	
	fclose(entrada); 
	fclose(salida);
}

void MostrarTabla(int tablaTransiciones[][columnas])
{
	// Mostrar Tabla de Transicion en pantalla
	int i,j;
	printf("\nTabla de Transiciones: \n");
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

void EscribirTipoConstante(FILE *salida, int estado)
{
	// Palabra no reconocida
		if(estado == 6)
		{
			//printf("\nPalabra no reconocida\n");
			fputs("ERROR",salida);
			//system("PAUSE");
		}
		else 
		{
			// Constante Decimal 
			if(estado == 1)
			{
				//printf("\nDecimal\n");
				fputs("Decimal",salida);
				//system("PAUSE");
			}
			// Constante Octal
			if(estado == 5 || estado == 2)
			{
				//printf("\nOctal\n");
				fputs("Octal",salida);
				//system("PAUSE");
			}
			// Constante Hexadecimal
			if(estado == 4)
			{
				//printf("\nHexadecimal\n");
				fputs("Hexadecimal",salida);
				//system("PAUSE");
			}	
		}
}
