%{
#include <cstdio>
#include <iostream>
#include "sintatico.tab.h"

using namespace std;

int linha = 1;

extern int yylval;
%}

%%
"INICIO"                return(INICIO);
"DEADPOOL"              return(DEADPOOL);
"ESPADINHA"             return(ESPADINHA);
"PONTARIA"              return(PONTARIA);
"CURA ACELERADA"        return(CURA_ACELERADA);
"MESTRE DAS ARMAS"      return(MESTRE_DAS_ARMAS);
"VELOCIDADE"            return(VELOCIDADE);
"IRONMAN"               return(IRONMAN);
"ARMA DE FOTONS"        return(ARMA_DE_FOTONS);
"RAIO DE ENERGIA"       return(RAIO_DE_ENERGIA);
"VISAO TERMAL"          return(VISAO_TERMAL);
"MAGNETISMO"            return(MAGNETISMO);
"INVISIBILIDADE"        return(INVISIBILIDADE);
[a-z0-9]*               { return(INVALIDO); }
\n	                    { ++linha; return (FINAL_DE_LINHA); }
"FIM"                   return(FIM);
.                       ;
%%