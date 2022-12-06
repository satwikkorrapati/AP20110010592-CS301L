CODE:

digit              [0-9]
id                 [a-zA-Z][a-zA-Z0-9]*
unsigned_integer   {digit}*
signed_integer     -{digit}*
unsigned_float     {digit}*\.{digit}*[e[+|-]?{digit}*]?
signed_float       -{digit}*\.{digit}*[e[+|-]?{digit}*]?
keyword            void|int|long|char|float|double|do|while|for|if|else|return

%{
#include<stdio.h>
#include<string.h>
int cnt=0,i=0,j=0;
char st[20][10];
int com=0,scom=0;
int look_up(char st[10][10],char *id,int n);
%}

%%
"\n"   {com=0;}
"//"   {com=1;}
"/*"   {scom=1;}
"*/"   {scom=0;}

{keyword}            {if(!com&&!scom)fprintf(yyout,"\n%s is Keyword",yytext);}
{unsigned_integer}   {if(!com&&!scom)fprintf(yyout,"\n%s is Unsigned Integer",yytext);}
{signed_integer}     {if(!com&&!scom)fprintf(yyout,"\n%s is Signed Integer",yytext);}
{id}                 {if(com==0&&scom==0){
                       if (!lookup(st,yytext,i)){
                         strcpy(st[i++],yytext);
			 fprintf(yyout,"\n%s is Identifier",yytext);
			 cnt++; }}}
{unsigned_float}     {if(!com&&!scom)fprintf(yyout,"%s is Unsigned Float.",yytext);}
{signed_float}       {if(!com&&!scom)fprintf(yyout,"%s is Signed Float.",yytext);}

"<=" {if(!com&&!scom)fprintf(yyout,"\n %s is Relational operator Lessthan or Equal to",yytext);}
"<"  {if(!com&&!scom)fprintf(yyout,"\n %s is Relational operator Lessthan",yytext);}
">=" {if(!com&&!scom)fprintf(yyout,"\n %s is Relational operator Greaterthan or Equal to",yytext);}
">"  {if(!com&&!scom)fprintf(yyout,"\n %s is Relational operator Greaterthan",yytext);}
"==" {if(!com&&!scom)fprintf(yyout,"\n %s is Relational operator Equal to",yytext);}
"!=" {if(!com&&!scom)fprintf(yyout,"\n %s is Relational operator Not Equal to",yytext);}
"="  {if(!com&&!scom)fprintf(yyout,"\n %s is Assignment operator",yytext);}
. 

%%
int main(int argc,char**argv)
{
yyin=fopen(argv[1],"r");
yyout=fopen(argv[2],"w");
yylex();
printf(" No. of identifiers are : %d ",cnt);
printf("\n the contents of symbol table are :\n");
for(j=0;j<i;j++)
printf("\n %s",st[j]);
return 0;
}

int yywrap()
{
return 1;
}

int lookup(char st[10][10],char *id,int n)
{
for(j=0;j<n;j++)
if(!strcmp(st[j],id))
  return 1;
return 0;
}


OUTPUT:

No. of identifiers are : 10
 the contents of symbol table are :

 include
 stdio
 h
 fib
 n
 f
 i
 main
 printf
 d
