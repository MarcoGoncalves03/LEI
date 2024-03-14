#ifndef gestor_utilizador_h
#define gestor_utilizador_h
#include <stdio.h>
#include <stdlib.h>
#include <glib.h>

typedef struct BTREE_UTILIZADORES btree_utilizadores;
typedef struct BTREE_REGISTOS_ANO btree_registos_ano;


btree_utilizadores* criar_arvore_vazia_utilizador();

btree_utilizadores* inserir_utilizador (btree_utilizadores* arvore, void* Nodo_novo);


btree_registos_ano** criar_lista_anos_registos();
btree_registos_ano* criar_ano_registo ();


int somar_ano_utilizadores (btree_registos_ano* anos_registos_utilizadores);
void inserir_registo_utilizador (int ano_registo,btree_registos_ano** registos,int* data);


void print_querie_9 (btree_utilizadores* arvore,char* prefixo, FILE* ficheiro_output,int* contador,int F);
int querie_9_interativa (btree_utilizadores* arvore,char* prefixo,char* resposta,int* contador,int F);
char* retorna_nome (btree_utilizadores* arvore);
void calcular_utilizadores_data (int data[2],btree_registos_ano** anos_registos_utilizadores,int* n_utilizadores,int tipo);
int somar_ano_utilizadores (btree_registos_ano* anos_registos_utilizadores);


void free_registos_utilizadores(btree_registos_ano** anos_registos_utilizadores);


#endif