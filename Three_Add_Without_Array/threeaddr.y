%{
	#include<bits/stdc++.h>
	using namespace std;
	int yylex();
	void yyerror(char* s);
	string temp="";
	int tempcount=0;
	int getTemp()
	{
		return tempcount++;
	}
	typedef struct node
	{
		string code, addr;
	}NODE;

	NODE* makeNode()
	{
		NODE *temp=new NODE();
		string s="t";
		/*int num = getTemp();
		s+=to_string(num);
		temp->addr=s;*/

		ostringstream ss;
		ss<<"t"<<getTemp();
		temp->addr=strdup(ss.str().c_str());
		ss.str("");
		temp->code="";
		return temp;
	}
	NODE* makeNode(char *x)
	{
		NODE *temp=new NODE();
		temp->addr=strdup(x);
		temp->code="";
		return temp;
	}
%}

%union{
	typedef struct node NODE;
	char *str;
	NODE *node;
}

%token ID VAL PL MI MUL DIV POW EQ OP CL OP2 CL2
%type <str> ID VAL PL MI MUL DIV POW EQ OP CL OP2 CL2
%type <node> e t f g l 	r stmt;

%%

stmt: l EQ r {$$->code=$3->code+$1->addr+" = "+$3->addr;cout<<$$->code<<endl;};
l: ID {$$=makeNode($1);};
r : e{$$=$1;};
e : e PL t {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" + "+$3->addr+"\n";}|
	 e MI t {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" - "+$3->addr+"\n";}|
	  t {$$=$1;};
t : t MUL f {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" * "+$3->addr+"\n";}|
	 t DIV f {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" / "+$3->addr+"\n";}|
	  f {$$=$1;};
f : g POW f {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" ^ "+$3->addr+"\n";}|
	 g {$$=$1;};
g : OP e CL {$$=$2;}|
	 ID {$$=makeNode($1);} |
	  VAL {$$=makeNode($1);}|
	   MI g {$$=makeNode();$$->code=$2->code+$$->addr+" = - "+$2->addr+"\n";};

%%

void yyerror(char* s)
{
	cout<<s<<endl;
}

int main()
{
	yyparse();
}