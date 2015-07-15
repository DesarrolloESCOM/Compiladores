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

%token<fval> T_FLOAT
%token<ival> T_INTEGER
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE
%token T_NEWLINE T_QUIT
%token T_EQUAL
%token T_SPACE_CHAR
%token T_TYPE_INTEGER
%token T_TYPE_FLOAT
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<ival> int_variable
%type<fval> float_variable

%type<ival> expression_integer
%type<fval> expression_float

%type<ival> integer_assignation
%type<fval> float_assignation

%start calculation

%%

calculation: 
	   | calculation line
;

line: T_NEWLINE
	| expression_integer T_NEWLINE { printf("\tResultado: %i\n", $1); } 	
    | expression_float T_NEWLINE { printf("\tResultado: %f\n", $1); } 
    | integer_assignation T_NEWLINE {printf("ENTERO ASIGNADO");}
    | float_assignation T_NEWLINE {printf("FLOTANTE ASIGNADO");}
    | variable_value T_NEWLINE {printf("El valor de %s es %i", (char*)"Hola",5);}
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;

integer_assignation: T_TYPE_INTEGER T_SPACE_CHAR T_VARIABLE T_EQUAL expression_integer {/*int var1=var23*/}
	| T_TYPE_INTEGER T_SPACE_CHAR T_VARIABLE T_EQUAL T_INTEGER {/*int var1=5*/}
	| T_VARIABLE T_EQUAL expression_integer {/*var1= var2+2*/}
	| T_VARIABLE T_EQUAL T_INTEGER {/*var1 = 2*/}
;
float_assignation: T_TYPE_FLOAT T_SPACE_CHAR T_VARIABLE T_EQUAL expression_float {/*int var1=var23*/}
	| T_TYPE_FLOAT T_SPACE_CHAR T_VARIABLE T_EQUAL T_FLOAT {/*int var1=5*/}
	| T_VARIABLE T_EQUAL expression_float {/*var1= var2+2*/}
	| T_VARIABLE T_EQUAL T_FLOAT {/*var1 = 2*/}
;
expression_float: T_FLOAT				{ $$ = $1; }
	| float_variable {/*$$ = funcionQueLlamaFlotanteDeEstructura($$1, 2)*/}
	| float_variable T_PLUS float_variable {/*$$ = funcionQueLlamaFlotanteDeEstructura($$1, 2) + funcionQueLLama...($$3,2)*/}
	| float_variable T_MINUS float_variable {/*$$ = funcionQueLlamaFlotanteDeEstructura($$1, 2) - funcionQueLLama...($$3,2)*/}
	| float_variable T_MULTIPLY float_variable {/*$$ = funcionQueLlamaFlotanteDeEstructura($$1, 2) * funcionQueLLama...($$3,2)*/}
	| float_variable T_DIVIDE float_variable {/*$$ = funcionQueLlamaFlotanteDeEstructura($$1, 2) / funcionQueLLama...($$3,2)*/}
	| expression_float T_PLUS expression_float	{ $$ = $1 + $3; }
	| expression_float T_PLUS expression_integer	{ $$ = $1 + $3; }
	| expression_integer T_PLUS expression_float	{ $$ = $1 + $3; }
	| expression_float T_MINUS expression_float	{ $$ = $1 - $3; }
	| expression_float T_MINUS expression_integer	{ $$ = $1 - $3; }
	| expression_integer T_MINUS expression_float	{ $$ = $1 - $3; }
	| expression_float T_MULTIPLY expression_float	{ $$ = $1 * $3; }
	| expression_float T_MULTIPLY expression_integer	{ $$ = $1 * $3; }
	| expression_integer T_MULTIPLY expression_float	{ $$ = $1 * $3; }
	| expression_float T_DIVIDE expression_float	{ $$ = $1 / $3; }
	| expression_float T_DIVIDE expression_integer	{ $$ = $1 / $3; }
	| expression_integer T_DIVIDE expression_float	{ $$ = $1 / $3; }
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
