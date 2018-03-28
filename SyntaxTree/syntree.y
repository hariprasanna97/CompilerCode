%{
	#include<bits/stdc++.h>
	using namespace std;
	int yylex();	
	void yyerror(char *s);

	typedef struct node
	{
		struct node *left,*right;
		string val;
	}NODE;

	NODE* makeNode(string val, NODE* left , NODE* right)
	{
		NODE *temp=new NODE();
		temp->val=val;
		temp->left=left;
		temp->right=right;
		return temp;
	}

	void postOrder(NODE* root)
	{
		if(root)
		{
			postOrder(root->left);
			postOrder(root->right);
			cout<<root->val<<" ";
		}
	}

	void inOrder(NODE* root)
	{
		if(root)
		{
			inOrder(root->left);
			cout<<root->val<<" ";
			inOrder(root->right);
		}
	}

	void preOrder(NODE* root)
	{
		if(root)
		{
			cout<<root->val<<" ";
			preOrder(root->left);
			preOrder(root->right);
		}
	}
%}

%token PL MI MUL DIV OP CL EQ ID VAL SC UNR POW

%union{
	typedef struct node NODE;
	char *str;
	NODE *node;
}

%type <node> s e t f g
%type <str> PL MI MUL DIV OP CL EQ ID VAL SC UNR POW

%%
s : e {$$=$1;postOrder($$);cout<<endl;}
e : e PL t {$$=makeNode($2,$1,$3);} |
	 e MI t {$$=makeNode($2,$1,$3);} |
	  t {$$=$1;};
t : t MUL f {$$=makeNode($2,$1,$3);}|
	 t DIV f {$$=makeNode($2,$1,$3);}|
	  f {$$=$1;};
f : g POW f {$$=makeNode($2,$1,$3);} |
	 g {$$=$1;};
g : OP e CL {$$=$2;} |
	 ID{$$=makeNode($1,NULL,NULL);} |
	  VAL{$$=makeNode($1,NULL,NULL);} |
	   MI g{$$=makeNode($1,NULL,$2);} ;

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