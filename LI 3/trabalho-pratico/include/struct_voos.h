#ifndef struct_voos_h
#define struct_voos_h
#include <stdio.h>
#include <stdlib.h>
#include <glib.h>

typedef struct VOO voo;
typedef struct AEROPORTO_ARVORE aeroporto_arvore;
typedef struct BTREE_REGISTOS_VOOS btree_registos_voos;


voo* guarda_voo_T (voo* novo_voo ,char* id,char* airline,char* model,char* total_seats,char* origin,char* destination,char* schedule_departure_date
                         ,char* schedule_arrival_date,char* real_departure_date,char* real_arrival_date,char* pilot,char* copilot,char* notes);
voo* cria_voo();
aeroporto_arvore* inserir_voo (aeroporto_arvore* arvore, voo* Nodo_novo,int* passageiros_voo,int id);  
aeroporto_arvore* contar_destination (aeroporto_arvore* arvore,voo* voo_chegada,int* passageiros_voo,int id);                       
aeroporto_arvore* criar_aeroporto_vazio();


int compara_ids_voo (char* id1,char* id2);
void* parser_voos (char** total_dados_voos,GHashTable* hash_tree,int* passageiros_voo, voo*** hash_voos,int n_voos,btree_registos_voos** registos,aeroporto_arvore** arvore_todos_voos);
void converter_schedule (char letras[],int data[]);
void departure_date (voo* viagem,int data_saida[6]);
int atraso_aviao (int data_real [6],int data_planeada [6]);
int retorna_id (voo* voo_novo);
btree_registos_voos** criar_lista_registos_voos();
btree_registos_voos* criar_ano_voos ();
void print_querie_1_V (voo** hash_voos,int* passageiros_voo,char* id,FILE* ficheiro_output,int F);
void querie1_V_interativa (voo** hash_voos,int* passageiros_voo,char* id,char*resposta,int F);
void encontrar_voos_data (int data[2],aeroporto_arvore* arvore_todos_voos,int* voos_a_contar,int* dia_do_voo,int tipo);
void encontrar_voos_data_todos (int data[2],aeroporto_arvore* arvore_todos_voos,int* ano_dos_voos);
void free_registos_voos(btree_registos_voos** anos_registo_voos);
void print_querie_5 (aeroporto_arvore* total_dados_voos,FILE* ficheiro_output,int data_inicio[6],int data_fim[6]);
void querie5_interativa (aeroporto_arvore* arvore_o,char* resposta,int data_inicio[6],int data_fim[6],int* contador,int F);
void print_querie_5F (aeroporto_arvore* total_dados_voos,FILE* ficheiro_output,int data_inicio[6],int data_fim[6],int* contador);
void querie6_interativa (GHashTable* hash_tree,int ano,int N,char* resposta,int F);
void print_querie_6(GHashTable* hash_tree,int ano, int N,FILE* ficheiro_output,int F);
void print_querie_7 (GHashTable* hash_tree,int N,FILE *ficheiro_output,int n_voos,int F);
void querie7_interativa (GHashTable* hash_tree,int N,char* resposta,int n_voos,int F);
int fazer_mediana_aeroporto (aeroporto_arvore* aeroporto,int n_voos);
aeroporto_arvore* inserir_voo_simple (aeroporto_arvore* arvore, voo* Nodo_novo,int* passageiros_voo,int t);
void swap(int *indice_nova_mediana,int *indice_mediana_antiga,char aeroportos_novo[4],char aeroporto_antigo[4]);
void merge(int arr[], int left[], int left_size, int right[], int right_size);
void merge_sort(int arr[], int size);
int substituir_menor (int medianas[],int mediana_nova,char Aeroportos[][4],int N,char pais[4]);
void inserir_atraso_lista (aeroporto_arvore* aeroporto,int* array,int* preenchido,size_t* tamanho_array);
int calcula_atraso_voo (int data_prevista[6],int data_real [6]);
int max_indi (int* valores,char paises[][4],int n);
void calcular_voos_data (int data[2],btree_registos_voos** anos_registos_voos,int numeros_voos[],int tipo);
int somar_ano_voos (btree_registos_voos* anos_registos_voos);
int compara_data_voos(int data_inicial[6], int data_final[6]);
void departure_date_simple (voo* viagem,int data_saida[3]);
voo* hash_do_voo (int id_novo_voo,voo** hash_voos);

void free_voos (GHashTable* hash_aeroportos,voo** hash_voos);
void free_aeroporto (aeroporto_arvore* aeroporto);
void free_aeroporto_lite (aeroporto_arvore* aeroporto);


void heapify(int medianas[], char Aeroportos[][4], int n, int i);
void heapsort(int medianas[], char Aeroportos[][4], int n);

#endif


