%{
/*  Written by: Yancy Vance M. Paredes. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "calc.tab.h"
 
#define TABSIZE 1000
#define true 1
#define false 0
 
/* the following were defined in lexana.l */
extern char* var_names[TABSIZE];
extern int var_def[TABSIZE];
extern int var_type[TABSIZE];
extern int n_of_names;
extern int install(char *txt);
extern void reset();
 
/* variables for the grammar file */
int invalid = false;            // just added for error checking
double double_var_values[TABSIZE];     // array where all the values are stored
 
int yyerror(const char *p) 
{
    fprintf(stderr, "%s\n", p); // print the error message
    invalid = true;
}
 
%}
 
%union {
    /* this will be used for the yylval. */
    /* it is a union since two data types will be used */
    double num;     // the number provided by the user
    int intnum;
    int index;      // index of the variable name inside the array
};
 
%start manycmds
%token <index> VARIABLE

%token INT FLOAT

%token <intnum> INT_NUMBER
%token <num> NUMBER

%type <num> onecmd

%type <intnum> int_expression
%type <num> expression

%type <intnum> int_assignment
%type <num> float_assignment

%type <intnum> int_term
%type <num> term

%type <num> factor
%type <intnum> int_factor

%type <intnum> int_primary
%type <num> primary

 
%%
 
manycmds : onecmd                           { }
|   manycmds onecmd                         { }
;
 
onecmd : expression ';'                     { if(!invalid) fprintf(stderr, "%f\n", $1); invalid = 0; }
|   int_expression ';'                      { if(!invalid) fprintf(stderr, "%i\n", $1); invalid = 0; }
|   float_assignment ';'                    { if(!invalid) fprintf(stderr, "%f\n", $1); invalid = 0; }
|   int_assignment ';'                      { if(!invalid) fprintf(stderr, "%i\n", $1); invalid = 0; }
 
expression : term                           { $$ = $1; }
|   '-' term                                { $$ = -$2; }
|   expression '+' term                     { $$ = $1 + $3; }
|   int_expression '+' term                 { $$ = $1 + $3; }
|   expression '+' int_term                 { $$ = $1 + $3; }
|   expression '-' term                     { $$ = $1 - $3; }
|   int_expression '-' term                 { $$ = $1 - $3; }
|   expression '-' int_term                 { $$ = $1 - $3; }
;

int_expression : int_term                           { $$ = (int)$1; }
|   '-' int_term                                { $$ = -$2; }
|   int_expression '+' int_term                     { $$ = $1 + $3; }
|   int_expression '-' int_term                     { $$ = $1 - $3; }
;
 
term : factor                               { $$ = $1; }
|   term '*' factor                         { $$ = $1 * $3; }
|   term '/' factor                         { if($3 == 0) yyerror("undefined"); else $$ = $1 / $3;  }
;

int_term : int_factor                               { $$ = (int)$1; }
|   int_term '*' int_factor                         { $$ = $1 * $3; }
|   int_term '/' int_factor                         { if($3 == 0) yyerror("undefined"); else $$ = $1 / $3;  }
;

factor : primary                            { $$ = $1; }
;
primary : NUMBER                            { $$ = $1; }
|   VARIABLE                                {   
  if(!var_def[$1]) {
    yyerror("undefined"); 
  } else {
    printf("Existe variable [%i]\n",$1);
    printf("Tipo: %i\n",var_type[$1]);
    if(var_type[$1] == 1){
      $$ = (int) double_var_values[$1];  
    } else {
      $$ = double_var_values[$1];
    }    
    
  }  
}
|   '(' expression ')'                      { $$ = $2; }
;
int_factor : int_primary                    { $$ = (int) $1; }
;
int_primary : INT_NUMBER                    { $$ = (int) $1; }
|   VARIABLE                                {   
  if(!var_def[$1]) {
    yyerror("undefined"); 
  } else {    
    printf("Existe variable [%i]\n",$1);
    printf("Tipo: %i\n",var_type[$1]);    
    $$ = (int) double_var_values[$1];
  }  
}
|   '(' int_expression ')'                      { $$ = $2; }
;
int_assignment :  INT VARIABLE '=' int_expression    {
  printf("Es entero [%i]!\n",$2);
  var_def[$2] = 1; 
  var_type[$2] = 1;
  $$ = double_var_values[$2] = $4;
};
float_assignment : FLOAT VARIABLE '=' expression    { 
  printf("Es decimal [%i]!\n",$2);
  var_def[$2] = 1; 
  var_type[$2] = 2;
  $$ = double_var_values[$2] = $4; 
}; 
%%
 
int main(void)
{
    /* reset all the definition flags first */
    reset();
    int j;
    for(j = 0; j < TABSIZE; j++){
      var_def[j] = 0;
      var_type[j] = -1;
    }
    
    yyparse();
     
    return 0;
}