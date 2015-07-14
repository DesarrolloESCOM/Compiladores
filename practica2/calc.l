%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "calc.tab.h"

%}
Integer [0-9]+
SignedIntEgeR "-"?{Integer}
Decimal {SignedIntEgeR}"."{Integer}
Real {SignedIntEgeR}|{Decimal}
%%	
[ \t]	;
{SignedIntEgeR} {printf("Signed INTEGER\n");yylval.ival = atoi(yytext); return T_INTEGER; }
{Integer} {printf("INTEGER\n");yylval.ival = atoi(yytext); return T_INTEGER; }
{Decimal}	{printf("FLOAT\n");yylval.fval = atof(yytext); return T_NUMBER; }
\n	{printf("NEW LINE\n");return T_NEWLINE;}
"+"	{printf("PLUS\n");return T_PLUS;}
"-"	{printf("MINUS\n");return T_MINUS;}
"*"	{printf("MULTIPLY\n");return T_MULTIPLY;}
"/"	{printf("DIVIDE\n");return T_DIVIDE;}
"quit"	{return T_QUIT;}
%%