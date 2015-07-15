%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "calc.tab.h"

%}
Integer [0-9]+
SignedIntEgeR "(-"?{Integer}")"
Decimal {SignedIntEgeR}"."{Integer}
Real {SignedIntEgeR}|{Decimal}
Variable [a-zA-z|_]{1}[a-zA-z|0-9^\\s]+
TypeInteger "int"
TypeFloat "float"
%%	
[ \t]	;
{SignedIntEgeR} {printf("Signed Integer\n");yylval.ival = atoi(yytext); return T_INTEGER; }
{Integer} {printf("Integer\n");yylval.ival = atoi(yytext); return T_INTEGER; }
{Decimal}	{printf("Float\n");yylval.fval = atof(yytext); return T_NUMBER; }
{TypeInteger} {printf("Type:Integer\n"); return T_TYPE_INTEGER;}
{TypeFloat} {printf("Type:Integer\n"); return T_TYPE_FLOAT;}
\n	{prinotf("New Line\n");return T_NEWLINE;}
"+"	{printf("Plus\n");return T_PLUS;}
"-"	{printf("Minus\n");return T_MINUS;}
"*"	{printf("Multiply\n");return T_MULTIPLY;}
"/"	{printf("Divide\n");return T_DIVIDE;}
"=" {printf("Assign/Equal");return T_EQUAL;}
" " {printf("Space Char\n"); return T_SPACE_CHAR;}
"quit"	{return T_QUIT;}
%%