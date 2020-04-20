#include <stdio.h>
#include <windows.h>

int main()
{
    int filas=7;
	int columnas=6; 
    int tablaTransiciones [7][6]={{2,1,1,6,6,6},
								  {1,1,1,6,6,6},
								  {5,5,6,3,6,6},
								  {4,4,4,6,4,6},
								  {4,4,4,6,4,6},
								  {5,5,6,6,6,6},
								  {6,6,6,6,6,6}};
	
	
	// Mostrar Tabla de Transicion en pantalla
	/*
	int i,j;
	printf("Tabla de Transiciones: \n");
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
    */
	       
    char caracter;
    
    int estado;
	int auxEstado;
    
	FILE * salida = fopen("salida.txt","wt");
	
	FILE * entrada = fopen("entrada.txt","rt");
	
	caracter = fgetc(entrada);
    
	while(caracter != EOF)
	{
		estado = 0;
		auxEstado = 0;
		
		while(caracter != ',' && estado != 6 && caracter != EOF)
		{
			//printf("%c",caracter);
   	    
			// Si viene un '0'
        	if (caracter == 48)
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
	        else if(caracter > 48 && caracter < 56)
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
	        else if(caracter > 55 && caracter < 58)
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
	        else if(caracter == 88 || caracter == 120)
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
	        else if((caracter > 64 && caracter < 71) || (caracter > 96 && caracter < 103))
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

		// Palabra no reconocida
		if(estado == 6)
		{
			//printf("\nPalabra no reconocida\n");
			fputs("error,",salida);
			//system("PAUSE");
		}
		else 
		{
			// Constante Decimal 
			if(estado == 1)
			{
				//printf("\nDecimal\n");
				fputs("Decimal,",salida);
				//system("PAUSE");
			}
			// Constante Octal
			if(estado == 5 || estado == 2)
			{
				//printf("\nOctal\n");
				fputs("Octal,",salida);
				//system("PAUSE");
			}
			// Constante Hexadecimal
			if(estado == 4)
			{
				//printf("\nHexadecimal\n");
				fputs("Hexadecimal,",salida);
				//system("PAUSE");
			}	
		}
		fflush(stdin);
		caracter = fgetc(entrada);	
	}
	
	fclose(entrada); 
	fclose(salida);
		
    return 0;
}

