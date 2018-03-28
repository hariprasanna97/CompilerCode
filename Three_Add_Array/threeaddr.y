%{
	#include<bits/stdc++.h>
	typedef long long ll;
	using namespace std;
	int yylex();
	void yyerror(char *s);
	
	//for 3addr
	int tempcount=0;
	int getTemp()
	{
		return tempcount++;
	}
	typedef struct node
	{
		string code, addr, array;
		pair<string,vector<ll> > type;
	}NODE;

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

	//for symbol table
	deque<string> s;
	deque<int> vars;
	deque<int> blocks;
	int blocknum=-1,varnum=0;
	map<ll,map<string,pair<pair<string,vector<ll> >,string> > > table;
	map<string,ll> width;
	ll getWidth(pair<string,vector<ll> > type);
	string to_string(ll val);
	void insertID(int bno,string varname);
	void printTable();
%}

%union{
	typedef struct node NODE;
	string *str;
	NODE *node;

}

%token <str> KEY ID VAL SC CM PL MI MUL DIV POW OP CL AO AC EQ BO BC UNR 
%type <node> e t f g l r
%type <str> b decl d id arr stmt 

%%

b: BO	{
			blocknum++;
			blocks.push_back(blocknum);
			for(int i=0;i<s.size();i++)
			{
				insertID(blocknum,s[i]);
			}
			vars.push_back(varnum);
			varnum=0;
		} 
		stmt BC 
		{
			blocks.pop_back();
			for(int i=0;i<varnum;i++)
				s.pop_back();
			varnum=vars.back();
			vars.pop_back();
		};

stmt: decl stmt |
		 b stmt |
		  l EQ r SC {cout<<($1->code+$3->code+$1->array+"["+$1->addr+"]= "+$3->addr)<<endl;	}
		  			stmt{$<str>$=new string("");} |
		  	ID EQ r SC 	{
		  					if(table[blocks.back()].find(*$1)==table[blocks.back()].end())
							{
								yyerror("variable not declared");
							}
		  					cout<<($3->code+*$1+" = "+$3->addr)<<endl;
		  				} 
		  				stmt |
		  		{};

l: 	 ID AO e AC 
				{
					$$=makeNode();
					$$->array=*$1;
					if(table[blocks.back()].find(*$1)==table[blocks.back()].end())
					{
						yyerror("variable not declared");
					}
					$$->type=table[blocks.back()][*$1].first;
					$$->code=$$->addr+" = "+$3->addr+" * "+to_string(getWidth($$->type))+"\n";
				} |
		 l AO e AC
		 		{
		 			NODE *myTemp=makeNode();
		 			$$=makeNode();
		 			$$->array=$1->array;
		 			$$->type=$1->type;
		 			$$->type.second.erase($$->type.second.begin());
		 			$$->code=$1->code+ myTemp->addr + " = "+$3->addr +" * "+to_string(getWidth($$->type))+"\n";
		 			$$->code=$$->code+$$->addr+" = "+$1->addr+ " + " + myTemp->addr+"\n";
		 		}

r : e 	{$$=$1;};

e : e PL t {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" + "+$3->addr+"\n";}|
	 e MI t {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" - "+$3->addr+"\n";}|
	  t {$$=$1;} |
	   l {$$=makeNode();$$->code=$$->addr+" = "+$1->array+"["+$1->addr+"]"+"\n";};

t : t MUL f {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" * "+$3->addr+"\n";}|
	 t DIV f {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" / "+$3->addr+"\n";}|
	  f {$$=$1;};

f : g POW f {$$=makeNode();$$->code=$1->code+$3->code+$$->addr+" = "+$1->addr+" ^ "+$3->addr+"\n";}|
	 g {$$=$1;};

g : OP e CL {$$=$2;}|
	 ID {
	 		if(table[blocks.back()].find(*$1)==table[blocks.back()].end())
			{
				yyerror("variable not declared");
			}
			$$=makeNode($1);
		} |
	  VAL {$$=makeNode($1);} |
	   MI g {$$=makeNode();$$->code=$2->code+$$->addr+" = - "+$2->addr+"\n";};

decl: KEY id {
				varnum++;s.push_back(*$1+" "+*$2);
				insertID(blocks.back(),*$1+" "+*$2);
			} d SC; 

id:	ID arr{$$=new string(*$1+*$2);} | ID arr EQ VAL {$$=new string(*$1+*$2+*$3+*$4);};

arr:	AO VAL AC arr {$$=new string(*$1+*$2+*$3+*$4);}| {$$=new string("");};

d: CM id {
			varnum++;s.push_back(*$2);
			insertID(blocks.back(),*$2);
		} d | {};

%%

void insertID(int bno,string varname)
{
	string type,value;
	int ind=varname.find(" ");
	if(ind!=-1)
	{
		type=varname.substr(0,ind);
		varname=varname.substr(ind+1);
	}
	ind=varname.find("=");
	value="";
	if(ind!=-1)
	{
		value=varname.substr(ind+1);
		varname=varname.substr(0,ind);
	}
	ind=varname.find("[");
	vector<ll> dims;
	if(ind!=-1)
	{
		string indexes=varname.substr(ind);
		varname=varname.substr(0,ind);
		for(ll i=0;i<indexes.length();i++)
		{
			if(indexes[i]=='[' || indexes[i]==']')
				indexes[i]=' ';
		}
		istringstream in(indexes.c_str());
		int dim;
		while(in>>dim)
		{
			dims.push_back(dim);
		}
	}
	table[bno][varname]=make_pair(make_pair(type,dims),value);
}
ll getWidth(pair<string,vector<ll> > type)
{
	ll ans=width[type.first];
	for(ll i=1;i<type.second.size();i++)
	{
		ans=ans*type.second[i];
	}
	return ans;
}
void printTable()
{
	for(map<ll,map<string,pair<pair<string,vector<ll> >,string> > >::iterator it=table.begin();it!=table.end();it++)
	{
		cout<<it->first<<endl;
		for(map<string,pair<pair<string,vector<ll> >,string> >::iterator it2=it->second.begin();it2!=it->second.end();it2++)
		{
			cout<<it2->first<<" "<<it2->second.first.first<<" "<<it2->second.second;
			for(vector<ll>::iterator it3=it2->second.first.second.begin();it3!=it2->second.first.second.end();it3++)
				cout<<*it3<<' ';
			cout<<endl;
		}
		cout<<endl;
	}
}
void setWidths()
{
	width["int"]=4;
	width["float"]=4;
	width["char"]=1;
	width["double"]=8;
}
string to_string(ll val)
{
	ostringstream ss;
	ss<<val;
	return ss.str();
}
void yyerror(char* s)
{
	cout<<s<<endl;
	exit(0);
}
int main()
{
	setWidths();
	yyparse();
}