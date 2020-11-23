//Al menos un control de tipos de datos en alguna operación binaria
int f;
char c = 'p';
f = a;
f = c;
//Control de doble declaración de variables
char* f;
//Control de cantidad y tipos de parámetros en la invocación a funciones 
char p(int,char);
p(3);
p(3,3);
funcionInexistente(5);
f = p(3,'a');

char funcionVacia(int param){};
funcionVacia(f);

for(x = 1; x > 0; x++);
while(a == 0){a++;}

//Sentencias (todos los tipos: compuesta, If, While, Salto, For, Expresión, etc)

// prototipo sin nombres de parametros
int nuevaFuncion(int void);
int nuevaFuncion(void identificador){}
int nuevaFuncion(void *identificador)
int nuevaFuncion(int* void);

int nuevaFuncion(for*);

if(99>0 void {}
if void 99>0) {}
if(void) {}

while(void){}

for void 1; 1; 1);
for (1; 1; 1 void ;

// atajamos el error de esta manera: error ';' cuando no terminan con una sentencia
while(1>0) void ;

for(1; 1; 1) void ;

do{}while(1) void ;

//Declaraciones de variables de forma correcta

int* buffer;
char letraA = 'a';
char* letraB = "hola";
int variable = 99;

//Declaraciones de funciones de forma correcta

int suma(int valor1, int valor2);
char* concatenarPalabras(char* palabra1, char* palabra2);


// este caso no lo contemplamos
//int void();
//Expresiones
arregloOk[5]
arregloMal[5)


