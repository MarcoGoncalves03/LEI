#ifndef queries_h
#define queries_h
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <glib.h>

void choose_queries(btree_registos_ano** anos_registos_utilizadores,btree_registos_reservas** anos_registos_reservas,btree_registos_voos** anos_registos_voos,aeroporto_arvore* arvore_todos_voos,char** matriz_passageiros,int linhas_matriz,char* querie,char* detalhes,reservas_arvore** total_dados_reservas,reserva** hash_reservas,btree_utilizadores** arvores_por_inicial,GHashTable* dados_utilizadores_id,GHashTable* total_dados_voos,int* passageiros_voo,voo** hash_voos,int n_voos,int output);

void choose_queries_testes(btree_registos_ano** anos_registos_utilizadores,btree_registos_reservas** anos_registos_reservas
                          ,btree_registos_voos** anos_registos_voos,aeroporto_arvore* arvore_todos_voos,char** matriz_passageiros,int linhas_matriz
                          ,char* querie,char* detalhes,reservas_arvore** total_dados_reservas,reserva** hash_reservas,btree_utilizadores** arvores_por_inicial
                          ,GHashTable* dados_utilizadores_id,GHashTable* total_dados_voos,int* passageiros_voo,voo** hash_voos
                          ,int n_voos,int output,char* ficheiros_corretos,int* q_erradas);



int identificar_id (char* chave); 
double querie3 (reservas_arvore* arvore_selecionada);
void querie4 (reservas_arvore* arvore_selecionada,FILE* ficheiro_output);
void querie4F (reservas_arvore* arvore,FILE* ficheiro_output);
void querie5 (aeroporto_arvore* voos,FILE* arqv,int data_inicio[6],int data_fim[6]);
void querie5F (aeroporto_arvore* voos,FILE* arqv,int data_inicio[6],int data_fim[6]);
void querie6 (GHashTable* dados_aeroportos,int ano, int N,FILE* ficheiro_output,int F);
void querie7 (GHashTable* total_dados_voos,int N,FILE *ficheiro_output,int n_voos,int F);
void querie8(reservas_arvore* arvore,FILE* ficheiro_output,int data_inicio[3],int data_fim[3]);
void querie10 (int data[2],char** matriz_passageiros,int linhas_matriz,aeroporto_arvore* arvore_todos_voos,FILE* ficheiro_output,btree_registos_ano** anos_registos_utilizadores,btree_registos_reservas** anos_registos_reservas,btree_registos_voos** anos_registos_voos,int n_voos,int F);

void  querie10_interativa (int data[2],char** matriz_passageiros,int linhas_matriz,aeroporto_arvore* arvore_todos_voos,char* resposta,btree_registos_ano** anos_registos_utilizadores,btree_registos_reservas** anos_registos_reservas,btree_registos_voos** anos_registos_voos,int n_voos,int F);

int verificar_querie (FILE* ficheiro_output,FILE* ficheiro_output_correto,char* resposta);


#endif