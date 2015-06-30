Variable [a-zA-z|_]{1}[a-zA-z|0-9^\\s]+$
DigitoConSigno 	^-{1}?[0-9]+$
DecimalConSinSigno ^-{1}?[0-9]+[\.]{1}[0-9]+$ 
PotenciaReales ^-{1}?[0-9]+[\.]{1}[0-9]+\^[0-9]+$
%%
{PotenciaReales}	{printf("\n\tPotencias Reales\n");}
{Variable}	{printf("\n\tVariable\n");}
{DigitoConSigno}	{printf("\n\tDigito con signo\n");}
{DecimalConSinSigno}	{printf("\n\tDecimal\n");}
%%
