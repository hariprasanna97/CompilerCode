*****This program solves dangling else problem by matching else statements to appropriate if statements and adds "else{}" for if statements that dont have else*****

given a input file ,Lex file parses them into tokens and gives to YACC file which constructs Parse tree using tokens.

****For Compilation****
flex if.l
bison if.y -d
gcc if.tab.c lex.yy.c -lfl
./a.out < in.txt
