cls
bison -v -d TP5.y 
flex TP5.l
gcc lex.yy.c TP5.tab.c -L "C:\flex_y_bison\lib" -lfl -ly
a.exe