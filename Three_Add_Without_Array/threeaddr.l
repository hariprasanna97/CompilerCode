%{
	#include<bits/stdc++.h>
	using namespace std;
	#include "y.tab.h"
	
%}

%%
[a-zA-Z_][a-zA-Z0-9_]* 	yylval.str=strdup(yytext);return ID;
[0-9]+					yylval.str=strdup(yytext);return VAL;
"+"						yylval.str=strdup(yytext);return PL;
"-"						yylval.str=strdup(yytext);return MI;
"*"						yylval.str=strdup(yytext);return MUL;
"/"						yylval.str=strdup(yytext);return DIV;
"^"						yylval.str=strdup(yytext);return POW;
"("						yylval.str=strdup(yytext);return OP;
")"						yylval.str=strdup(yytext);return CL;
"["						yylval.str=strdup(yytext);return OP2;
"]"						yylval.str=strdup(yytext);return CL2;
"="						yylval.str=strdup(yytext);return EQ;
[\n \t]+				;
%%