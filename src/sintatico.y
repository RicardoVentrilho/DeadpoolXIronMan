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

int PONTARIA_ATUAL = 1;
bool ESTA_VELOZ = false;

float HP_DO_DEADPOOL = 20000.0;
float HP_DO_IRONMAN = 20000.0;

/*
 * FUNÇÕES AUXILIARES
 */
void imprima_hp_do_ironman();
void imprima_hp_do_deadpool();
void volte_pontaria_para_o_normal();

/*
 * ATAQUES DO DEADPOOL, DIMINUEM O HP DO IRONMAN
 */
void ataque_de_espadinha();
void aumente_pontaria();
void use_cura_acelerada();
void ataque_de_mestre_das_armas();
void fique_veloz();

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
							printf("DEADPOOL ATACA COM ESPADINHA | ");
							ataque_de_espadinha();
							imprima_hp_do_ironman();
						}
						| 
						PONTARIA 
						{
							printf("DEADPOOL USA PONTARIA | ");
							aumente_pontaria();
							cout << "PONTARIA ATUAL " << PONTARIA_ATUAL << "x" << endl;
						} 
						|
						CURA_ACELERADA
						{
							cout << "DEADPOOL USA CURA ACELERADA + 5% DE HP | ";
							use_cura_acelerada();
							imprima_hp_do_deadpool();
						} 
						|
						MESTRE_DAS_ARMAS
						{
							cout << "DEADPOOL ATACA MESTRE DAS ARMAS | ";
							ataque_de_mestre_das_armas();
							imprima_hp_do_ironman();
						} 
						|
						VELOCIDADE
						{
							cout << "DEADPOOL ESTA VELOZ | PROXIMO ATAQUE SE ESQUIVA" << endl;
							fique_veloz();
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
	
	yyin = arquivo;
	
	do 
	{
		yyparse();
	} 
	while (!feof(arquivo));
	
	fclose(arquivo);

	return(SUCESSO);
}

int yyerror(const char *mensagem)
{
	fprintf(stderr, "Comando da linha %d inválido: %s\n\n", linha, mensagem);
	return(1);
}

void imprima_hp_do_ironman() 
{
	cout.precision(7);
	cout << "HP DO IRONMAN " << HP_DO_IRONMAN << endl;
}

void imprima_hp_do_deadpool()
{
	cout.precision(7);
	cout << "HP DO DEADPOOL " << HP_DO_DEADPOOL << endl;
}

void volte_pontaria_para_o_normal()
{
	PONTARIA_ATUAL = 1;
}

void ataque_de_espadinha()
{
	HP_DO_IRONMAN *= 1 - (0.15 * PONTARIA_ATUAL);
	volte_pontaria_para_o_normal();
}

void aumente_pontaria()
{
	PONTARIA_ATUAL *= 2;
}

void use_cura_acelerada()
{
	HP_DO_DEADPOOL *= 1 + 0.05;
}

void ataque_de_mestre_das_armas()
{
	HP_DO_IRONMAN *= 1 - (0.15 * PONTARIA_ATUAL);
	volte_pontaria_para_o_normal();
}

void fique_veloz()
{
	ESTA_VELOZ = true;
}