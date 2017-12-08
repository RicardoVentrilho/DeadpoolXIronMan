%{
#include <cstdio>
#include <iostream>
#include "sintatico.tab.h"

using namespace std;

int linha = 1;

extern int yylval;
%}

%%
"INICIO"     return(INICIO);
"GUERREIRO"  return(GUERREIRO);
"ATAQUE"     return(ATAQUE);
"ESCUDO"     return(ESCUDO);
"POCAO"      return(POCAO);
"MAGO"       return(MAGO);
"BOLADEFOGO" return(BOLADEFOGO);
"CANALIZAR"  return(CANALIZAR);
"CURAR"      return(CURAR);
"LADRAO"     return(LADRAO);
"FLECHA"     return(FLECHA);
"ESQUIVA"    return(ESQUIVA);
"ATADURA"    return(ATADURA);
[a-z0-9]*    {return(INVALIDO);}
\n	     { ++linha; return (END_OF_LINE);}
"FIM"        return (FIM);
.            ;
%%
