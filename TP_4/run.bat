cls
bison -v -d tp4.y 
flex tp4.l
gcc lex.yy.c tp4.tab.c -L "C:\flex_y_bison\lib" -lfl -ly
a.exe