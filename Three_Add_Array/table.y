%{
	#include<bits/stdc++.h>
	using namespace std;
	typedef long long ll;
	int yylex();
	void yyerror(char *s);
	deque<string> s;
	deque<int> vars;
	deque<int> blocks;
	int blocknum=-1,varnum=0;
	string type,varname,value;
	map<ll,map<string,pair<string,string> > > table;
%}

%token <str> OP CL SC KEY CM ID UNR VAL EQ AO AC

%union{
	string *str;
}

%type <str> b stmt decl d id arr

%%

b: OP 	{
			blocknum++;
			blocks.push_back(blocknum);
			int bno=blocknum;
			for(int i=0;i<s.size();i++)
			{
				varname=s[i];
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
				if(ind!=-1)
				{
					table[bno][varname.substr(0,ind)]=make_pair(type+varname.substr(ind),value);
				}
				else
				{
					table[bno][varname]=make_pair(type,value);
				}
			}
			vars.push_back(varnum);
			varnum=0;
		} 
		stmt CL 
		{
			blocks.pop_back();
			for(int i=0;i<varnum;i++)
				s.pop_back();
			varnum=vars.back();
			vars.pop_back();
		};
stmt: decl stmt | b stmt | {};
decl: KEY id {
				varnum++;s.push_back(*$1+" "+*$2);
				int bno=blocks.back();
				varname=*$1+" "+*$2;
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
				if(ind!=-1)
				{
					table[bno][varname.substr(0,ind)]=make_pair(type+varname.substr(ind),value);
				}
				else
				{
					table[bno][varname]=make_pair(type,value);
				}
			} d SC; 
id:	ID arr{$$=new string(*$1+*$2);} | ID arr EQ VAL {$$=new string(*$1+*$2+*$3+*$4);};
arr:	AO VAL AC arr {$$=new string(*$1+*$2+*$3+*$4);}| {$$=new string("");};
d: CM id {
			varnum++;s.push_back(*$2);
			int bno=blocks.back();
			varname=*$2;
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
			if(ind!=-1)
			{
				table[bno][varname.substr(0,ind)]=make_pair(type+varname.substr(ind),value);
			}
			else
			{
				table[bno][varname]=make_pair(type,value);
			}
		} d | {};

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
	for(map<ll,map<string,pair<string,string> > >::iterator it=table.begin();it!=table.end();it++)
	{
		cout<<it->first<<":"<<endl;
		for(map<string,pair<string,string> >::iterator it2=it->second.begin();it2!=it->second.end();it2++)
		{
			cout<<it2->first<<" "<<it2->second.first<<" "<<it2->second.second<<endl;
		}
	}
}