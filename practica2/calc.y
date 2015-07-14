%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	double fval;
	int ival;
}

%token<fval> T_NUMBER
%token<ival> T_INTEGER
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE
%token T_NEWLINE T_QUIT
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<fval> expression_real
%type<ival> expression_integer

%start calculation

%%

calculation: 
	   | calculation line
;

line: T_NEWLINE
	| expression_integer T_NEWLINE { printf("\tResultado: %i\n", $1); } 	
    | expression_real T_NEWLINE { printf("\tResultado: %f\n", $1); } 
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;

expression_real: T_NUMBER				{ $$ = $1; }
	  | expression_real T_PLUS expression_real	{ $$ = $1 + $3; }
	  | expression_real T_PLUS expression_integer	{ $$ = $1 + $3; }
	  | expression_integer T_PLUS expression_real	{ $$ = $1 + $3; }
	  | expression_real T_MINUS expression_real	{ $$ = $1 - $3; }
	  | expression_real T_MINUS expression_integer	{ $$ = $1 - $3; }
	  | expression_integer T_MINUS expression_real	{ $$ = $1 - $3; }
	  | expression_real T_MULTIPLY expression_real	{ $$ = $1 * $3; }
	  | expression_real T_MULTIPLY expression_integer	{ $$ = $1 * $3; }
	  | expression_integer T_MULTIPLY expression_real	{ $$ = $1 * $3; }
	  | expression_real T_DIVIDE expression_real	{ $$ = $1 / $3; }
	  | expression_real T_DIVIDE expression_integer	{ $$ = $1 / $3; }
	  | expression_integer T_DIVIDE expression_real	{ $$ = $1 / $3; }
  ;
expression_integer: T_INTEGER				{ $$ = $1; }
	  | expression_integer T_PLUS expression_integer	{ $$ = $1 + $3; }
	  | expression_integer T_MINUS expression_integer	{ $$ = $1 - $3; }
	  | expression_integer T_MULTIPLY expression_integer	{ $$ = $1 * $3; }
	  | expression_integer T_DIVIDE expression_integer	{ $$ = $1 / $3; }
  ;
%%

main() {
	yyin = stdin;

	do { 
		yyparse();
	} while(!feof(yyin));
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
