%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"int" {yylval.numar=1; return INT;}
"float" {yylval.numar=2; return FL;}
"char" {yylval.numar=3; return CH;}
"string" {yylval.numar=5; return STR;}
"bool" {yylval.numar=4; return BOL;}
"ho ho ho" {return BGIN;}
"oh oh oh" {return END;}
"ploaia"|"ninsoarea" {return CONTROL;}
"clasa" {return CLASS;}
"defineste" {return CONSTANT;}
AS[_a-zA-Z][_a-zA-Z0-9]* { strcpy(yylval.n, yytext); return ID; }
`[A-Za-z0-9!-?]+` {return STRING;}
":=" {return ASSIGN;}
[1-9][0-9]*|0 {yylval.numar=atoi(yytext); return NR;}
functional_[a-z]+ {strcpy(yylval.n, yytext); return FCT;}
return {return RET;}
eval {return EVAL;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
