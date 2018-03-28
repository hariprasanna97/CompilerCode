%{
	#include<stdio.h>	
	extern char* yytext;
	void yyerror(const char* st);
	int yywrap();
%}
%token IF ELSE OP CL OC CC TEXT

%%
	S : SF;

	SF : TEXT{printf("\n%s\n",yytext);} SF
		| IF{printf("\n%s",yytext);} OP{printf("%s",yytext);} TEXT{printf("%s",yytext);} CL{printf("%s\n",yytext);} OC{printf("%s\n",yytext);} SF CC{printf("%s\n",yytext);} ST
		| ;
	ST : ELSE {printf("\n%s",yytext);} OC{printf("\n%s\n",yytext);} SF CC{printf("%s\n",yytext);} SF
		| {printf("\nelse\n{\n}\n");};
%% 
main()
{
	yyparse();
}


void yyerror(const char* st)
{
	printf("error: %s\n",st);
}

int yywrap()
{	
	return 1;	
}

