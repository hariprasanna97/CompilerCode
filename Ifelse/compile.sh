filename=$1
flex $filename".l"
bison $filename".y" -d
gcc lex.yy.c $filename".tab.c" -lfl