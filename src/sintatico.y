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
bool ESTA_COM_VELOCIDADE = false;
bool ESTA_COM_VISAO_TERMAL = false;
bool ESTA_COM_MAGNETISMO = false;
bool ESTA_COM_INVISIBILIDADE = false;

float HP_DO_DEADPOOL = 20000.0;
float HP_DO_IRONMAN = 20000.0;

/*
 * FUNÇÕES AUXILIARES
 */
void imprima_hp_do_ironman();
void imprima_hp_do_deadpool();
void volte_pontaria_para_o_normal();
void desative_visao_termal();
void desative_invisibilidade();
void desative_magnetismo();
void verifique_se_houve_vencedor();

/*
 * ATAQUES DO DEADPOOL, DIMINUEM O HP DO IRONMAN
 */
void ataque_de_espadinha();
void aumente_pontaria();
void use_cura_acelerada();
void ataque_de_mestre_das_armas();
void fique_veloz();

/*
 * ATAQUES DO IRON MAN, DIMINUEM O HP DO DEADPOOL
 */
void ataque_de_arma_de_fotons();
void ataque_de_raio_de_energia();
void ative_visao_termal();
void ative_magnetismo();
void ative_invisibilidade();

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
							ataque_de_espadinha();
							imprima_hp_do_ironman();
							verifique_se_houve_vencedor();
						}
						| 
						PONTARIA 
						{
							aumente_pontaria();
							cout << "PONTARIA ATUAL " << PONTARIA_ATUAL << "x" << endl;
							verifique_se_houve_vencedor();
						} 
						|
						CURA_ACELERADA
						{
							use_cura_acelerada();
							imprima_hp_do_deadpool();
							verifique_se_houve_vencedor();
						} 
						|
						MESTRE_DAS_ARMAS
						{
							ataque_de_mestre_das_armas();
							imprima_hp_do_ironman();
							verifique_se_houve_vencedor();
						} 
						|
						VELOCIDADE
						{
							fique_veloz();
							verifique_se_houve_vencedor();
						}
						;
comandos_de_ironman  	: 
						ARMA_DE_FOTONS 
						{
							ataque_de_arma_de_fotons();
							imprima_hp_do_deadpool();
							verifique_se_houve_vencedor();
						} 
						| 
						RAIO_DE_ENERGIA 
						{
							ataque_de_raio_de_energia();
							imprima_hp_do_deadpool();
							verifique_se_houve_vencedor();
						} 
						|
						VISAO_TERMAL
						{
							ative_visao_termal();
							imprima_hp_do_ironman();
							verifique_se_houve_vencedor();
						} 
						|
						MAGNETISMO
						{
							ative_magnetismo();
							imprima_hp_do_ironman();
							verifique_se_houve_vencedor();
						} 
						|
						INVISIBILIDADE
						{
							ative_invisibilidade();
							imprima_hp_do_ironman();
							verifique_se_houve_vencedor();
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
		printf("Falha ao abrir arquivo '%s' do jogador!\n", nome_do_arquivo);
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
	fprintf(stderr, "COMANDO DA LINHA %d INVALIDO: %s\n\n", linha, mensagem);
	return(ERRO);
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
	cout << "DEADPOOL ATACA COM ESPADINHA | ";

	if (!ESTA_COM_MAGNETISMO)
	{
		HP_DO_IRONMAN -= 20000 * (0.15 * PONTARIA_ATUAL);
		volte_pontaria_para_o_normal();
	}
	else
	{
		cout << "IRONMAN DEFENDEU COM ESCUDO DE MAGNETISMO | ";
	}
	desative_magnetismo();
}

void aumente_pontaria()
{
	cout << "DEADPOOL USA PONTARIA | ";
	PONTARIA_ATUAL *= 2;
}

void use_cura_acelerada()
{
	cout << "DEADPOOL USA CURA ACELERADA + 5% DE HP | ";

	HP_DO_DEADPOOL += 20000 * 0.05;
}

void ataque_de_mestre_das_armas()
{
	cout << "DEADPOOL ATACA MESTRE DAS ARMAS | ";

	if(!ESTA_COM_MAGNETISMO)
	{
		HP_DO_IRONMAN -= 20000 * (0.15 * PONTARIA_ATUAL);
		volte_pontaria_para_o_normal();
	}
	else
	{
		cout << "IRONMAN DEFENDEU COM ESCUDO DE MAGNETISMO | ";
	}
	desative_magnetismo();
}

void fique_veloz()
{
	cout << "DEADPOOL ESTA VELOZ | PROXIMO ATAQUE SE ESQUIVA" << endl;
	ESTA_COM_VELOCIDADE = true;
}

void ataque_de_arma_de_fotons()
{
	cout << "IRONMAN ATACA COM ARMA DE FOTONS | ";

	if (ESTA_COM_VELOCIDADE)
	{
		cout << "DEADPOOL ESQUIVOU! | ";
		ESTA_COM_VELOCIDADE = false;
	}
	else
	{
		HP_DO_DEADPOOL -= 20000 * (0.25 * (ESTA_COM_VISAO_TERMAL ? 2 : 1));
		desative_visao_termal();

		if (ESTA_COM_INVISIBILIDADE)
		{
			desative_invisibilidade();
			ataque_de_raio_de_energia();
		}
	}
}

void ataque_de_raio_de_energia()
{
	cout << "IRONMAN ATACA COM RAIO DE ENERGIA | ";
	
	if (ESTA_COM_VELOCIDADE)
	{
		cout << "DEADPOOL ESQUIVOU! | ";
		ESTA_COM_VELOCIDADE = false;
	}
	else
	{
		HP_DO_DEADPOOL -= 20000 * (0.15 * (ESTA_COM_VISAO_TERMAL ? 2 : 1));
		desative_visao_termal();

		if (ESTA_COM_INVISIBILIDADE)
		{
			desative_invisibilidade();
			ataque_de_raio_de_energia();
		}
	}
}

void ative_visao_termal()
{
	cout << "IRONMAN ATIVA VISAO TERMAL | ";
	ESTA_COM_VISAO_TERMAL = true;
}

void desative_visao_termal()
{
	ESTA_COM_VISAO_TERMAL = false;
}

void ative_magnetismo()
{
	cout << "IRONMAN ATIVA MAGNETISMO | ";
	ESTA_COM_MAGNETISMO = true;
}

void ative_invisibilidade()
{
	cout << "IRONMAN ATIVA INVISIBILIDADE | ";
	ESTA_COM_INVISIBILIDADE = true;
}

void desative_invisibilidade()
{
	ESTA_COM_INVISIBILIDADE = false;
}

void desative_magnetismo()
{
	ESTA_COM_MAGNETISMO = false;
}

void verifique_se_houve_vencedor()
{
	if (HP_DO_DEADPOOL <= 0)
	{
		cout << "DEADPOOL MORREUUUU" << endl;
		exit(SUCESSO);
	}
	if (HP_DO_IRONMAN <= 0)
	{
		cout << "IRONMAN MORREUUUU" << endl;
		exit(SUCESSO);
	}
}