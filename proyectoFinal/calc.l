%{
/*  Written by: Yancy Vance M. Paredes. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc.tab.h"
 
#define TABSIZE 1000
#define true 1
#define false 0
 
char* var_names[TABSIZE];   // where the variable names will be stored
int var_def[TABSIZE];       // flag to determine whether a var is defined
int var_type[TABSIZE];       // flag to determine whether a var is defined
int n_of_names = 0;         // counter of variables
 
void reset()
{
    /* this will just reset all the flags to false */
    int j;
    for(j = 0; j < TABSIZE; j++){
        var_def[j] = false;
        var_type[j] = -1;
    }
        
}

int install(char *txt)
{
    int j; char *s;    
    /* if the table of var_names is still empty */
    /* add the first record at 0 and return 0 */
    if(n_of_names == 0) {
        s = strdup(txt);
        var_names[0] = s;
        ++n_of_names;
        /*for(j = 0; j < TABSIZE; j++){
          printf("--> %s\n",var_names[j]);
        }*/
        return 0;
    }
     
    /* if the table has contents already, return the index */
    for(j = 0; j < n_of_names; ++j) {
        if(strcmp(txt, var_names[j]) == 0) {
            /*for(j = 0; j < TABSIZE; j++){
              printf("--> %s\n",var_names[j]);
            }*/
            return j;
        }
    }
     
    /* if the table is not empty and the var name is not yet listed */
    /* list the new var name and return the index */
    s = strdup(txt);
    var_names[j] = s;
    ++n_of_names;

    /*for(j = 0; j < TABSIZE; j++){
      printf("--> %s\n",var_names[j]);
    }*/

    return j;
}
 
%}

VariableRegex [a-zA-z|_]{1}[a-zA-z|0-9^\\s]+ 

%%
[ \n\t]                 { }

[0-9]+ {    
    /* convert yytext to a double and return it  */    
    yylval.intnum = atoi(yytext);
    return INT_NUMBER;
}

[0-9]+"."[0-9]+ {      
    yylval.num = atof(yytext);
    return NUMBER;  
}

[a-zA-z] {
    printf("Es variable!\n");
    /* install the variable found to the array and return the index */
    yylval.index = install(yytext);
    return VARIABLE;
}

"int " {
  return INT;
}

"float " {
  return FLOAT;
}
.                       {
    return yytext[0];
}
 
%%
 
int yywrap(void)
{
    return 1;
}