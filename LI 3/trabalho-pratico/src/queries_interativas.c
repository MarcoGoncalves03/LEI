#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ncurses.h>
#include <time.h>
#include <stdbool.h>
#include <string.h>

#include "../include/struct_utilizador.h"
#include "../include/struct_reserva.h"
#include "../include/struct_voos.h"
#include "../include/struct_passageiro.h"
#include "../include/parser.h"
#include "../include/interpreter.h"
#include "../include/modo_interativo.h"
#include "../include/queries.h"


void choose_queries_interativas(int modo,char* querie,char* detalhes,reservas_arvore** total_dados_reservas,reserva** hash_reservas,GHashTable* arvores_por_inicial,GHashTable* dados_utilizadores_id,GHashTable* total_dados_voos,int* passageiros_voo,voo** hash_voos,int n_voos,int output)
{

}
