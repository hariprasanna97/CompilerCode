%{
	#include <bits/stdc++.h>
	#include <string>
	using namespace std;
	#include "block.tab.h"
%}

%%

(int)|(float)|(char)|(double) 	yylval.str=new string(yytext);return KEY ;
[a-zA-Z_][a-zA-Z_0-9]* 	yylval.str=new string(yytext);return ID ;
([0-9]*\.?[0-9]*)|(\".*?\")|(\'.\')	yylval.str=new string(yytext);return VAL ;
";"		yylval.str=new string(yytext);return SC ;
","		yylval.str=new string(yytext);return CM ;
"{"		yylval.str=new string(yytext);return OP ;
"}"		yylval.str=new string(yytext);return CL ;
"="		yylval.str=new string(yytext);return EQ ;
[\n \t]+	;
. 		yylval.str=new string(yytext);return UNR;

%%