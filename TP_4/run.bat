bison -d tp4.y 
flex tp4.l
gcc lex.yy.c tp4.tab.c -L "C:\Program Files (x86)\flex_y_bison\lib" -lfl -ly
a.exe