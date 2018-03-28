%{
	#include<bits/stdc++.h>
	using namespace std;
	int yylex();
	void yyerror(char *s);
	deque<string> s;
	deque<int> vars;
	deque<int> blocks;
	int blocknum=0,varnum=0;
%}

%token <str> OP CL SC KEY CM ID UNR VAL EQ

%union{
	string *str;
}

%type <str> b stmt decl d

%%

b: OP {blocknum++;blocks.push_back(blocknum);vars.push_back(varnum);varnum=0;} stmt CL {	
								printf("****END OF BLOCK**** %d: ",blocks.back());
								blocks.pop_back();
								for(int i=0;i<s.size();i++)
									cout<<s[i]<<" ";
								cout<<endl;
								for(int i=0;i<varnum;i++)
									s.pop_back();
								varnum=vars.back();
								vars.pop_back();
							};
stmt: decl stmt | b stmt | {};
decl: KEY ID {varnum++;s.push_back(*$1+" "+*$2);} d | KEY ID EQ VAL {varnum++;s.push_back(*$1+" "+*$2+"="+*$4);} d; 
d: CM ID {varnum++;s.push_back(*$2);} d | CM ID EQ VAL {varnum++;s.push_back(*$2+"="+*$4);} d | SC;

%%

void yyerror(char *s)
{
	printf("%s\n",s);
}
int yywrap()
{
	return 1;
}
int main(void)
{
	yyparse();
}
