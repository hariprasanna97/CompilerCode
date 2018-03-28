%{
	#include<bits/stdc++.h>
	using namespace std;
	#include "threeaddr.tab.h"
	
%}

%%
(int)|(float)|(char)|(double) 			yylval.str=new string(yytext);return KEY ;
[a-zA-Z_][a-zA-Z0-9_]* 					yylval.str=new string(yytext);return ID;
([0-9]*\.?[0-9]*)|(\".*?\")|(\'.\')		yylval.str=new string(yytext);return VAL ;
";"										yylval.str=new string(yytext);return SC ;
","										yylval.str=new string(yytext);return CM ;
"+"										yylval.str=new string(yytext);return PL;
"-"										yylval.str=new string(yytext);return MI;
"*"										yylval.str=new string(yytext);return MUL;
"/"										yylval.str=new string(yytext);return DIV;
"^"										yylval.str=new string(yytext);return POW;
"("										yylval.str=new string(yytext);return OP;
")"										yylval.str=new string(yytext);return CL;
"["										yylval.str=new string(yytext);return AO;
"]"										yylval.str=new string(yytext);return AC;
"="										yylval.str=new string(yytext);return EQ;
"{"										yylval.str=new string(yytext);return BO ;
"}"										yylval.str=new string(yytext);return BC ;
[\n \t]+								;
. 										yylval.str=new string(yytext);return UNR;
%%