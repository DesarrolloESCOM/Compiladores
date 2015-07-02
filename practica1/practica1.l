Variable [a-zA-z|_]{1}[a-zA-z|0-9^\\s]+
Digito [0-9]+
DigitoConSigno 	-{1}?[0-9]+
Decimal [0-9]+"."{1}[0-9]+ 
DecimalConSinSigno -{1}?[0-9]+[\.]{1}[0-9]+
PotenciaReales -{1}?[0-9]+[\.]{1}[0-9]+\^[0-9]+
OperacionesMatematicas ^-{1}?[0-9]+(\+|-|\*|\/|MOD)[0-9]+
%%
{Digito}	{printf("\n\tDigito");}
{Decimal}	{printf("\n\tDecimal");}
{PotenciaReales}	{printf("\n\tPotencias Reales\n");}
{Variable}	{printf("\n\tVariable\n");}
{DigitoConSigno}	{printf("\n\tDigito con signo\n");}
{DecimalConSinSigno}	{printf("\n\tDecimal con signo\n");}
{OperacionesMatematicas}	{printf("Operacion matemática");}
%%
