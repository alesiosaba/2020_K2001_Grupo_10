#include <stdio.h>
#include <string.h>
#include <windows.h>

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

int main()
{
	struct Estado_CimaPila TT[estadosPosibles][cimaPilaPosibles][columnas];
	
	generarTablaTransiciones(TT);
	mostrarTablaTransiciones(TT);		
	
	// Creacion de pila y asignacion inicial
	struct Nodo *pila = (struct Nodo*)malloc(sizeof(struct Nodo));
	pila = push(pila, '$');
	
	int columnaAux;
	int estadoAux = 0;
	int cimaAux = pilaVacia; // Hay un $
	
	char cima;
	
	int i;
	int posError = 0;
	int tieneError = 0;

	char c = getche();
	while(c != 13)
	{
		i=1; // segundo caracter de lo que vas a pushear
		
		cima = pila->info;
		if(cima == '$')
			cimaAux = pilaVacia;
		else
			cimaAux = pilaNoVacia;
		
		pila = pop(pila);
		
		if(c == 0)
			columnaAux = 0;
		else if(c >= '1' && c <= '9')
			columnaAux = 1;
		else if(c == '+' || c == '-' || c == '/' || c == '*')
			columnaAux = 2;
		else if(c == '(')
			columnaAux = 3;
		else if(c == ')')
			columnaAux = 4;
		else
			columnaAux = 5;
		
		while(i>=0)
		{
			if(TT[estadoAux][cimaAux][columnaAux].cadenaPush[i] == '$' || TT[estadoAux][cimaAux][columnaAux].cadenaPush[i] == 'R')
				pila = push(pila,TT[estadoAux][cimaAux][columnaAux].cadenaPush[i]);
			i--;
		}
		
		estadoAux = TT[estadoAux][cimaAux][columnaAux].estadoSig;
		
		if(estadoAux == 3)
			tieneError = 1;
		
		if(tieneError == 0)
			posError++;
		
		c = getche();
	}
	
	printf("\n");
	
	if(estadoAux == 3)
	{
		for(i=0;i<posError;i++)
			printf("-");
	
		printf("^\n");
	}
	else
		printf("La expresion aritmetica ingresada es sintacticamente correcta");
	
	system("PAUSE");
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
	system("PAUSE");
	system("CLS");
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