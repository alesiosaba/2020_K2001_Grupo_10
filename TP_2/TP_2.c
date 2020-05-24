#include <stdio.h>
#include <string.h>
#include <windows.h>
#include <conio.h>

struct Estado_CimaPila
{
	int estadoSig;
	char cadenaPush[3];
};

struct Nodo
{
	char info;
	struct Nodo* sig;
};

struct Nodo* push(struct Nodo*, char);
struct Nodo* pop(struct Nodo*);

int estadosPosibles = 4; 	// q0, q1, q2, q3 (rechazo)
int cimaPilaPosibles = 2; 	// $=0, R=1
int columnas = 6; 			// 0, [1-9], {+,-,*,/}, (, ), [caracteres no admitidos]

int q0=0, q1=1, q2=2, q3=3;
	
int pilaVacia = 0; 		// $
int pilaNoVacia = 1; 	// R

void generarTablaTransiciones(struct Estado_CimaPila [][cimaPilaPosibles][columnas]);
void mostrarTablaTransiciones(struct Estado_CimaPila [][cimaPilaPosibles][columnas]);

void analizarExpresion(struct Estado_CimaPila [][cimaPilaPosibles][columnas]);
void evaluarEstadoFinal(int,int);

int main()
{
	struct Estado_CimaPila TT[estadosPosibles][cimaPilaPosibles][columnas];
	
	char opcion;
	
	generarTablaTransiciones(TT);
	
	do{
		printf("Ver tabla de transiciones?\n1.Si\n0.No\n\nOpcion: ");
		opcion = getchar();
		system("CLS");
	}while(opcion!='1' && opcion!='0');
	
	if(opcion == '1')
		mostrarTablaTransiciones(TT);	
	
	do
	{
		analizarExpresion(TT);
		
		printf("Ingresar otra expresion?\n1.Si\n0.No\n\nOpcion: ");
		opcion = getch();
		
		system("CLS");
	}while(opcion!='0');
	
	
}

void generarTablaTransiciones(struct Estado_CimaPila TT[][cimaPilaPosibles][columnas])
{	
	int i,j,k;
	
	for(i=0;i<columnas;i++)
	{
		for(j=0;j<estadosPosibles;j++)
		{
			for(k=0;k<cimaPilaPosibles;k++)
			{
				TT[j][k][i].estadoSig=3;
				strcpy(TT[j][k][i].cadenaPush,"-");
			}
		}
	}

	// (q0,$) caracter entrante: 0
	TT[q0][pilaVacia][1].estadoSig=q1;
	strcpy(TT[q0][pilaVacia][1].cadenaPush,"$");
	
	// (q0,$) caracter entrante: (
	TT[q0][pilaVacia][3].estadoSig=q0;
	strcpy(TT[q0][pilaVacia][3].cadenaPush,"R$");

	// (q1,$) caracter entrante: 0
	TT[q1][pilaVacia][0].estadoSig=q1;
	strcpy(TT[q1][pilaVacia][0].cadenaPush,"$");
	
	// (q1,$) caracter entrante: [1-9]
	TT[q1][pilaVacia][1].estadoSig=q1;
	strcpy(TT[q1][pilaVacia][1].cadenaPush,"$");
	
	// (q1,$) caracter entrante: {+,-,*,/}
	TT[q1][pilaVacia][2].estadoSig=q0;
	strcpy(TT[q1][pilaVacia][2].cadenaPush,"$");
		
	// (q0,R) caracter entrante: [1-9]
	TT[q0][pilaNoVacia][1].estadoSig=q1;
	strcpy(TT[q0][pilaNoVacia][1].cadenaPush,"R");
	
	// (q0,R) caracter entrante: (
	TT[q0][pilaNoVacia][3].estadoSig=q0;
	strcpy(TT[q0][pilaNoVacia][3].cadenaPush,"RR");
	
	// (q1,R) caracter entrante: 0
	TT[q1][pilaNoVacia][0].estadoSig=q1;
	strcpy(TT[q1][pilaNoVacia][0].cadenaPush,"R");
	
	// (q1,R) caracter entrante: [1-9] 
	TT[q1][pilaNoVacia][1].estadoSig=q1;
	strcpy(TT[q1][pilaNoVacia][1].cadenaPush,"R");
	
	// (q1,R) caracter entrante: {+,-,*,/}
	TT[q1][pilaNoVacia][2].estadoSig=q0;
	strcpy(TT[q1][pilaNoVacia][2].cadenaPush,"R");
	
	// (q1,R) caracter entrante: )
	TT[q1][pilaNoVacia][4].estadoSig=q2;
	strcpy(TT[q1][pilaNoVacia][4].cadenaPush,"");
	
	// (q2,R) caracter entrante: {+,-,*,/}
	TT[q2][pilaNoVacia][2].estadoSig=q0;
	strcpy(TT[q2][pilaNoVacia][2].cadenaPush,"R");
	
	// (q2,R) caracter entrante: )
	TT[q2][pilaNoVacia][4].estadoSig=q2;
	strcpy(TT[q2][pilaNoVacia][4].cadenaPush,"");
	
	// (q2,$) caracter entrante: {+,-,*,/}
	TT[q2][pilaVacia][2].estadoSig=q0;
	strcpy(TT[q2][pilaVacia][2].cadenaPush,"$");
	
	printf("La Tabla de Transiciones se ha generado correctamente!\n\n");
}

void mostrarTablaTransiciones(struct Estado_CimaPila TT[][cimaPilaPosibles][columnas])
{
	printf("Tabla de Transiciones:\n\n");
	int i,j,k;
	
	for(i=0;i<columnas;i++)
	{
		printf("Columna: %d  ",i);
		
		switch(i)
		{
			case 0:
				puts("Caracter 0");
				break;
			case 1:
				puts("Caracteres [1-9]");
				break;
			case 2:
				puts("Caracteres {+,-,*,/}");
				break;
			case 3:
				puts("Caracter (");
				break;
			case 4:
				puts("Caracter )");
				break;
			case 5:
				puts ("Caracteres no admitidos");
				break;
		}
		
		printf("\n");
		for(j=0;j<estadosPosibles-1;j++)
		{
			for(k=0;k<cimaPilaPosibles;k++)
			{
				printf("(q%d,",j);
				
				if(k)
					printf("R)");
				else
					printf("$)");
					
				printf(" ---> (q%d,%s)",TT[j][k][i].estadoSig,TT[j][k][i].cadenaPush);
				printf("\n");
			}
		}
		
		printf("\n\n");
	}
	
	system("PAUSE");
	system("CLS");	
}

void analizarExpresion(struct Estado_CimaPila TT[][cimaPilaPosibles][columnas])
{
	// Creacion de pila y asignacion inicial
	struct Nodo *pila = (struct Nodo*)malloc(sizeof(struct Nodo));
	pila = push(pila, '$');
	
	int columnaActual;
	int estadoActual = 0;
	int cimaPilaActual = pilaVacia; // Hay un $
	
	char cima;
	
	int i;
	int posError = 0;
	int tieneError = 0;
	
	printf("Ingrese la expresion a analizar:\n\n");

	char c = getche();
	while(c != 13)
	{
		i=1; // segundo caracter de lo que vas a pushear
		
		cima = pila->info;
		if(cima == '$')
			cimaPilaActual = pilaVacia;
		else
			cimaPilaActual = pilaNoVacia;
		
		pila = pop(pila);
		
		if(c == 0)
			columnaActual = 0;
		else if(c >= '1' && c <= '9')
			columnaActual = 1;
		else if(c == '+' || c == '-' || c == '/' || c == '*')
			columnaActual = 2;
		else if(c == '(')
			columnaActual = 3;
		else if(c == ')')
			columnaActual = 4;
		else
			columnaActual = 5;
		
		while(i>=0)
		{
			if(TT[estadoActual][cimaPilaActual][columnaActual].cadenaPush[i] == '$' || TT[estadoActual][cimaPilaActual][columnaActual].cadenaPush[i] == 'R')
				pila = push(pila,TT[estadoActual][cimaPilaActual][columnaActual].cadenaPush[i]);
			i--;
		}
		
		estadoActual = TT[estadoActual][cimaPilaActual][columnaActual].estadoSig;
		
		if(estadoActual == 3)
			tieneError = 1;
		
		if(tieneError == 0)
			posError++;
		
		c = getche();
	}
	
	if(pila->info != '$')
		estadoActual = 3; 
	
	free(pila);
	
	evaluarEstadoFinal(estadoActual, posError);
}

void evaluarEstadoFinal(int estadoFinal, int posError)
{
	int i;
	
	printf("\n"); // Esto es para que no borre la expresion ingresada con el getche();
	
	if(estadoFinal == 3) // Estado de rechazo
	{
		if(posError != 0)
		{
			for(i=0;i<posError;i++)
				printf("-");
		}
		
		printf("^ error\n\n");
		
		printf("La expresion aritmetica ingresada NO es sintacticamente correcta\n\n");
	}
	else
		printf("\nLa expresion aritmetica ingresada es sintacticamente correcta\n\n");
}

struct Nodo* push(struct Nodo *pila, char caracter)
{
	struct Nodo* nuevo=(struct Nodo*)malloc(sizeof(struct Nodo));
	nuevo->info = caracter;
	nuevo->sig = pila;
	return nuevo;
}

struct Nodo* pop(struct Nodo *pila)
{
	struct Nodo* aux = pila;
	pila = aux->sig;
	free(aux);
	return pila;
}