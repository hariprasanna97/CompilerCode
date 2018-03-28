%{
	#include<bits/stdc++.h>
	typedef long long ll;
	using namespace std;
	int yylex();
	void yyerror(char *s);

	typedef struct node{
		string code, addr, array;
		pair<string,vector<ll> > type;
		vector<ll> trueList,falseList;
		int instNum;
	}NODE;

	map<ll,string> instList;
	int tempcount=0;
	int getTemp()
	{
		return tempcount++;
	}

	NODE* makeNode()
	{
		NODE *temp=new NODE();
		ostringstream ss;
		ss<<"t"<<getTemp();
		temp->addr=ss.str();
		ss.str("");
		temp->code="";
		temp->array="";
		return temp;
	}
	NODE* makeNode(string *x)
	{
		NODE *temp=new NODE();
		temp->addr=*x;
		temp->code="";
		temp->array="";
		return temp;
	}

	int instCounter=0;
	int nextInst()
	{
		return instCounter++;
	}
	string to_string(ll val)
	{
		ostringstream ss;
		ss<<val;
		return ss.str();
	}
	vector<ll> merge(vector<ll> a,vector<ll> b)
	{
		a.insert(a.end(),b.begin(),b.end());
		return a;
	}
	void backpatch(vector<ll> list,int num)
	{
		for(ll i=0;i<list.size();i++)
		{
			if(instList[list[i]].find("goto")==instList[list[i]].length()-4)
			{
				instList[list[i]]+=" "+to_string(num);
			}
		}
	}
%}

%union{
	typedef struct node NODE;
	string *str;
	NODE *node;
}
%token <str> AND OR NOT RELOP ID VAL SC CM PL MI MUL DIV POW OP CL AO AC EQ BO BC UNR TRUE FALSE

%type <node> b bb m e t f g
%%
s:	b 	{
			for(map<ll,string>::iterator it=instList.begin();it!=instList.end();it++)
			{
				cout<<it->first<<" "<<it->second<<endl;
			}
		}
b:	b OR m bb 	{
					$$=new NODE();
					backpatch($1->falseList,$3->instNum);
					$$->trueList=merge($1->trueList,$4->trueList);
					$$->falseList=$4->falseList;
				} |
	 b AND m bb	{
	 				$$=new NODE();
	 				backpatch($1->trueList,$3->instNum);
	 				$$->trueList=$4->trueList;
	 				$$->falseList=merge($1->falseList,$4->falseList);
				} |
		 bb {$$=new NODE();$$->trueList=$1->trueList;$$->falseList=$1->falseList;};

bb:	  NOT bb {$$=new NODE();$$->trueList=$2->falseList;$$->falseList=$2->trueList;} |
	   OP b CL {$$=new NODE();$$->trueList=$2->trueList;$$->falseList=$2->falseList;} |
	    e RELOP e 	{
	    				$$=new NODE();
	    				$$->trueList.push_back(nextInst());
	    				instList[$$->trueList.back()]="if("+$1->addr+" "+*$2+" "+$3->addr+") goto";
	    				$$->falseList.push_back(nextInst());
	    				instList[$$->falseList.back()]="goto";
	    			} |
	     TRUE {$$=new NODE();$$->trueList.push_back(nextInst());instList[$$->trueList.back()]="goto";} |
	      FALSE {$$=new NODE();$$->falseList.push_back(nextInst());instList[$$->falseList.back()]="goto";};
m:	{$$->instNum=instCounter;};

e : e PL t {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" + "+$3->addr+"\n";}|
	 e MI t {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" - "+$3->addr+"\n";}|
	  t {$$=$1;};

t : t MUL f {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" * "+$3->addr+"\n";}|
	 t DIV f {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" / "+$3->addr+"\n";}|
	  f {$$=$1;};

f : g POW f {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" ^ "+$3->addr+"\n";}|
	 g {$$=$1;};

g : OP e CL {$$=$2;}|
	 ID {
			$$=makeNode($1);
		} |
	  VAL {$$=makeNode($1);} |
	   MI g {$$=makeNode();$$->code=$2->code+$$->addr+" = - "+$2->addr+"\n";};

%%
void yyerror(char *s)
{
	cout<<s<<endl;
	exit(0);
}
int main()
{
	yyparse();
}