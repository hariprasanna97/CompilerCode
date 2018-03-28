%{
	#include<bits/stdc++.h>
	using namespace std;
	int yylex();	
	void yyerror(char *s);

	typedef struct node
	{
		struct node *left,*right;
		int label;
		string val;
	}NODE;


	NODE *synTree;

	map<string,string> op;

	void assign_map(map<string,string> &op)
	{
		op["+"]="ADD";
		op["-"]="SUB";
		op["*"]="MUL";
		op["/"]="DIV";
		//op["+"]="ADD";	
	}	

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

	void assign_label(NODE* root)
	{
		if(root==NULL)
			return;
		if(!root->left && !root->right)
			{
				root->label=1;
				return;
			}

		if(root->left==NULL)
		{
			root->label=root->right->label;
			return;
		}
		if(root->right==NULL)
		{
			root->label=root->left->label;
			return;
		}

		assign_label(root->right);
		assign_label(root->left);

		if(root->left->label==root->right->label)
		{
			root->label=root->left->label+1;
		}
		else
		{
			root->label=max(root->left->label,root->right->label);
		}

	}



	void genCode(NODE* root,int base=1,int n=2)
	{
		if(!root)
		{
			return;
		}
		if(root->left==NULL && root->right==NULL)
		{
			cout<<"LD R"<<base<<" "<<root->val<<endl;
			return;
		}

		if(root->label<=n)
		{
			if(root->left->label==root->right->label)
			{
				int k=root->left->label;
				genCode(root->right,base+1);
				genCode(root->left,base);
				cout<< op[root->val] <<" R"<<base+k-1<<" ,R"<<base+k-2<<" ,R"<<base+k-1<<endl;

			}
	

			else

			{
				NODE *big,*small;
				if(root->left->label > root->right->label)
				{
					big=root->left;
					small=root->right;
				}
				else
				{
					big=root->right;
					small=root->left;
				}
				genCode(big,base);
				genCode(small,base);
				int k=big->label;
				int m=small->label;
				if(root->left->label > root->right->label)
				{ 
					cout<<op[root->val]<<" R"<<base+k-1<< ",R" <<base+k-1<<" ,R"<<base+m-1<<endl;

				}
				else
				{
					cout<<op[root->val]<<" R"<<base+k-1<< ",R" <<base+k-1<<" ,R"<<base+m-1<<endl;					
				}

			}
		

		}

		else
		{
			NODE *small,*big;
			if(root->left->label>root->right->label)
			{
				small=root->right;
				big=root->left;
			}
			else
			{
				small=root->left;
				big=root->right;
			}
			genCode(big,1);
			cout<<"ST t"<<root->label<<", R"<<n<<endl;
			if(small->label < n)
			{
				genCode(small,n-small->label);
			}
			else
				genCode(small,base);
			cout<<"LD R"<<n-1<<", t"<<root->label<<endl;
			if(big==root->right)
			{
				cout<<op[root->val]<<" R"<<n<<", R"<<n<<", R"<<n-1<<endl;
			}
			else
				cout<<op[root->val]<<" R"<<n<<", R"<<n-1<<", R"<<n<<endl;
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
s : e {$$=$1;synTree=$$;}
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
	postOrder(synTree);
	assign_map(op);
	cout<<endl;
	assign_label(synTree);
	genCode(synTree);
}
