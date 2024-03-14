#ifndef parser_h
#define parser_h
#include <stdio.h>
#include <stdlib.h>
#include <glib.h>

void parser (FILE *parse,char *** total_dados,int select,char *ficheiro_erros,GHashTable* erros_utilizadores,int* passageiros_voo
            ,int** erros_voos,char* header,GHashTable* dados_utilizadores_id,int* n_voos,int* voos_validos,int* n_passageiros
            ,int* n_reservas,void* registos_reservas,GHashTable* verificar_reserva);
            
void* parser_com_hash (FILE *parse,char *** total_dados,char *ficheiro_erros,GHashTable* erros_utilizadores,int** erros_voos,char* header,int* n_utilizadores);


void free_matriz (char** total_dados_utilizadores,int numero_utilizadores);
#endif