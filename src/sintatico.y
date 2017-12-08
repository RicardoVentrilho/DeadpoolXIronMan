%{
#include <cstdio>
#include <iostream>
using namespace std;

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int linha;

#define SUCESSO 0
#define ERRO -1

int yyerror(const char *mensagem);
%}

%start batalha 

%token INICIO
%token DEADPOOL
%token ESPADINHA
%token PONTARIA
%token CURA_ACELERADA
%token MESTRE_DAS_ARMAS
%token VELOCIDADE
%token IRONMAN
%token ARMA_DE_FOTONS
%token RAIO_DE_ENERGIA
%token VISAO_TERMAL
%token MAGNETISMO
%token INVISIBILIDADE
%token INVALIDO

%left  DEADPOOL IRONMAN INICIO FINAL_DE_LINHA FIM

%%

batalha    				:	INICIO FINAL_DE_LINHA jogar FINAL_DE_LINHA
						{
							exit(SUCESSO);
						}
						;

jogar					: 	DEADPOOL comandos_do_deadpool FINAL_DE_LINHA jogar |
        
							IRONMAN comandos_de_ironman FINAL_DE_LINHA jogar |
					
							fim
        
comandos_do_deadpool 	: 
						ESPADINHA 
						{
							printf("DEADPOOL ESPADINHA\n");
						} 
						| 
						PONTARIA 
						{
							printf("DEADPOOL PONTARIA\n");
						} 
						|
						CURA_ACELERADA
						{
							printf("DEADPOOL CURA_ACELERADA\n");
							} 
						|
						MESTRE_DAS_ARMAS
						{
							printf("DEADPOOL MESTRE_DAS_ARMAS\n");
						} 
						|
						VELOCIDADE
						{
							printf("DEADPOOL VELOCIDADE\n");
						}
						;
comandos_de_ironman  	: 
						ARMA_DE_FOTONS 
						{
							printf("IRONMAN ARMA_DE_FOTONS\n");
						} 
						| 
						RAIO_DE_ENERGIA 
						{
							printf("IRONMAN RAIO_DE_ENERGIA\n");
						} 
						|
						VISAO_TERMAL
						{
							printf("IRONMAN VISAO_TERMAL\n");
							} 
						|
						MAGNETISMO
						{
							printf("IRONMAN MAGNETISMO\n");
						} 
						|
						INVISIBILIDADE
						{
							printf("IRONMAN INVISIBILIDADE\n");
						}
						;
fim: FIM
%%

int main(int argc, char **argv)
{
	FILE *arquivo;

	char* nome_do_arquivo = argv[1];
	arquivo = fopen(nome_do_arquivo,"r");

	if (!arquivo) 
	{
		printf("\nFalha ao abrir arquivo[%s] do jogador!\n", nome_do_arquivo);
		return ERRO;
	}
	
	// Seta o LEX para ler o arquivo1 atraves da variavel yyin 
	yyin = arquivo;
	
	// Realiza o parse para o arquivo
	do 
	{
		yyparse();
	} 
	while ( !feof(arquivo) );
	
	fclose(arquivo);

	return(SUCESSO);
}

int yyerror(const char *mensagem)
{
	fprintf(stderr, "Comando da linha %d inválido: %s\n\n", linha, mensagem);
	return(1);
}

int yywrap(void) {	
	// A funcao yywrap, deve retornar 0 para continuar o parse com outro arquivo
	return(1);
}
