*****This program coverts dowhile and for loop into while loop*****

given a input file ,Lex file parses them into tokens and gives to YACC file which constructs Parse tree using tokens.

****For Compilation****
flex for.l
bison for.y -d
g++ for.tab.c lex.yy.c -lfl
./a.out < in.txt
