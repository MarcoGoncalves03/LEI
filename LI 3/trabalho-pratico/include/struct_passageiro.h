#ifndef struct_passageiro_h
#define struct_passageiro_h
#include <stdio.h>
#include <stdlib.h>

#include "../include/struct_voos.h"
#include "../include/struct_reserva.h"

typedef struct Passageiro passageiro;
typedef struct BTREE_ID_VOOS btree_id_voos;
typedef struct ARRAY_RESERVAS array_reservas;
typedef struct ARRAY_VOOS array_voos;
typedef struct BTREE_REGISTOS_PASSAGEIROS btree_registos_passageiros;


void parser_passageiros (char** total_dados_passageiro,GHashTable* hash_id_utilizadores,voo** hash_voos,int n_passageiros,GHashTable* verificar_passageiros,int interativo);

void inserir_passageiro (char* id_user,GHashTable* hash_id_users,voo** hash_voos,int id_novo_voo);

btree_id_voos* criar_id_voo (int id_voo,btree_id_voos* arvore,int data[6]);

btree_id_voos* inserir_id_voo (int id,btree_id_voos* arvore,int data[6]);

void querie_2_Voos (char* username,GHashTable* dados_utilizadores_id,FILE* ficheiro_output,int F);

void print_voos_q2 (btree_id_voos* arvore_voos,FILE* ficheiro_output);

void print_voos_q2_F (btree_id_voos* arvore_voos,FILE* ficheiro_output,int* contador);

void querie_2_Total (char *username,GHashTable* dados_utilizadores_id,FILE *ficheiro_output,int F);

void print_querie2_totalF(char *username,btree_reservas_utilizador* dados_utilizadores_id,btree_id_voos* dados_passageiros,FILE* ficheiro_output,int *contador);

void print_querie2_total(char *username,btree_reservas_utilizador* dados_utilizadores_id,btree_id_voos* dados_passageiros,FILE* ficheiro_output);

void querie2_print_reserva_F (char* id,int data[3],FILE* ficheiro_output,int* contador);

void querie2_print_voo_F (int id,int data[3],FILE* ficheiro_output,int* contador);

void guardar_btree_id_voos (array_voos** voos,btree_id_voos* arvore_id_voos);

void contador_de_passageiros (char** matriz_passageiros,int linhas_matriz,int* voos_a_contar,int* dia_do_voo,int* passageiros,int* passageiros_unicos);

void contador_de_passageiros_mes (char** matriz_passageiros,int linhas_matriz,int* voos_a_contar,int* mes_do_voo,int* passageiros,int* passageiros_unicos);

void contador_de_passageiros_total (char** matriz_passageiros,int linhas_matriz,int* ano_do_voo,int* passageiros,int* passageiros_unicos);

//////////////////////////////////////////////////////INTERATIVO////////////////////////////////////////////////////////////
void querie_2_Voos_interativo (char* username ,GHashTable* dados_utilizadores_id,char* resposta,int F);

void print_voos_q2_interativo (btree_id_voos* arvore_voos,char* resposta,int* contador,int F);

void querie_2_Total_interativo (char* username,GHashTable* dados_utilizadores_id,char* resposta,int F);

void print_querie2_Total_interativo(char *username,btree_reservas_utilizador* dados_utilizadores_id,btree_id_voos* dados_passageiros,char* resposta,int *contador,int F);

void querie2_print_voo_F_interativo (int id,int data[3],char* resposta,int* contador);

void querie2_print_reserva_F_interativo (char* id,int data[3],char* resposta,int* contador);

//////////////////////////////////////////////////////////////Frees////////////////////////////////////////////////////////

void free_arvore_id_voos (btree_id_voos* arvore);

void  free_stack_voos (array_voos* v);

void free_stack_reservas (array_reservas* r);


#endif