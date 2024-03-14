#include <stdlib.h>
#include <glib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "../include/struct_voos.h"
#include "../include/struct_reserva.h"
#include "../include/struct_utilizador.h"
#include "../include/utilidade_tempo.h"
#include "../include/erros.h"

#define HASH_VOOS_ID 6000
#define MES 1
#define ANO 2

struct VOO
{
   char id[11]; 
   char airline[35];
   char model[20];
   char total_seats[4];
   char origin[4];
   char destination[4];
   int schedule_departure_date[6];
   int schedule_arrival_date[6];
   int real_departure_date[6];
   int real_arrival_date[6];
};

struct AEROPORTO_ARVORE
{
    int vinte_um;
    int vinte_dois;
    int vinte_tres;
    char pais[4];
    voo* Nodo;
    aeroporto_arvore* esquerda;
    aeroporto_arvore* direita;
};


struct BTREE_REGISTOS_VOOS
{
    int Ano_todo;
    int Janeiro [31];
    int Fevereiro [31];
    int Marco [31];
    int Abril [31];
    int Maio [31];
    int Junho [31];
    int Julho [31];
    int Agosto [31];
    int Setembro [31];
    int Outubro [31];
    int Novembro [31];
    int Decembro [31];
};


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void* parser_voos (char** total_dados_voos,GHashTable* hash_tree,int* passageiros_voo, voo*** hash_voos,int n_voos_validos,btree_registos_voos** registos_voos,aeroporto_arvore** arvore_todos_voos) 
{
    size_t hash_voos_id = HASH_VOOS_ID;
    hash_tree = g_hash_table_new(g_str_hash,g_str_equal);
    voo** hash_voo = *hash_voos;
    aeroporto_arvore* arvore_todos_voos_local = NULL;

    int contador = 0;                                  
    int t = 0;
    int t_anterior = 0;

    while (contador < n_voos_validos) 
    {
        char dados_voos [13][126]; 
        char linha_temp [520];
        strcpy (linha_temp,total_dados_voos[contador]);
    
        dividirLinha_voo (linha_temp,dados_voos);    //separamos os elementos de cada voo e guardamos numa struct voo

        voo* voo = cria_voo();
        guarda_voo_T(voo,dados_voos[0],dados_voos[1],dados_voos[2],dados_voos[3],dados_voos[4],dados_voos[5],dados_voos[6], 
                         dados_voos[7],dados_voos[8],dados_voos[9],dados_voos[10],dados_voos[11],dados_voos[12]);
        
        int indice_registo = (voo->schedule_departure_date[0] - 2010); //0 é ano  1 é mes  2 é dia
        registos_voos [indice_registo]->Ano_todo++;
        int endereco_dia = voo->schedule_departure_date[2] - 1;
        if      (voo->schedule_departure_date[1] == 1) registos_voos [indice_registo]->Janeiro[endereco_dia]++;
        else if (voo->schedule_departure_date[1] == 2) registos_voos [indice_registo]->Fevereiro[endereco_dia]++;
        else if (voo->schedule_departure_date[1] == 3) registos_voos [indice_registo]->Marco[endereco_dia]++;
        else if (voo->schedule_departure_date[1] == 4) registos_voos [indice_registo]->Abril[endereco_dia]++;
        else if (voo->schedule_departure_date[1] == 5) registos_voos [indice_registo]->Maio[endereco_dia]++;
        else if (voo->schedule_departure_date[1] == 6) registos_voos [indice_registo]->Junho[endereco_dia]++;
        else if (voo->schedule_departure_date[1] == 7) registos_voos [indice_registo]->Julho[endereco_dia]++;
        else if (voo->schedule_departure_date[1] == 8) registos_voos [indice_registo]->Agosto[endereco_dia]++;
        else if (voo->schedule_departure_date[1] == 9) registos_voos [indice_registo]->Setembro[endereco_dia]++;
        else if (voo->schedule_departure_date[1] ==10) registos_voos [indice_registo]->Outubro[endereco_dia]++;
        else if (voo->schedule_departure_date[1] ==11) registos_voos [indice_registo]->Novembro[endereco_dia]++;
        else if (voo->schedule_departure_date[1] ==12) registos_voos [indice_registo]->Decembro[endereco_dia]++;    

        
        t = atoi(dados_voos[0]) -1;

        if (t > t_anterior + 1)
        {
             t_anterior++;
            while (t_anterior < t)
            {
                hash_voo[t_anterior] = NULL;
                t_anterior++;
            }
        }

        if((t + 100) >= hash_voos_id)
        {
            hash_voos_id *= 2;
            hash_voo = realloc(hash_voo,hash_voos_id*sizeof(struct voo*));
        } 

        hash_voo[t] = voo;
           
        arvore_todos_voos_local = inserir_voo (arvore_todos_voos_local,voo,passageiros_voo,t);


        gpointer hash = g_hash_table_lookup(hash_tree,voo->origin);
        gpointer hash_destination = g_hash_table_lookup(hash_tree,voo->destination);       //atraves do id do aerorporto de chegada e destino

        if(hash == NULL)
        {                                                                           //inserimos o voo e contabilizamos o numero de passageiros para ambos os aeroportos
            aeroporto_arvore* nova_arvore = NULL;
            nova_arvore = inserir_voo (nova_arvore,voo,passageiros_voo,t);
            g_hash_table_insert (hash_tree,voo->origin,nova_arvore);
        }
        else 
        {   
            inserir_voo (hash,voo,passageiros_voo,t);
        }

        if(hash_destination == NULL) 
            {
                aeroporto_arvore* arvore_vazia_destino = NULL;
                arvore_vazia_destino = contar_destination (arvore_vazia_destino,voo,passageiros_voo,t);
                g_hash_table_insert (hash_tree,voo->destination,arvore_vazia_destino);
            } 
            else 
            {
                contar_destination (hash_destination,voo,passageiros_voo,t);
            }
            
        t_anterior = t;
        contador++;
     }
    
    *arvore_todos_voos = arvore_todos_voos_local;
    *hash_voos = hash_voo;
    return hash_tree;
}


btree_registos_voos** criar_lista_registos_voos() 
{
    btree_registos_voos** registos = malloc (sizeof(btree_registos_voos*) * 14); //2003 a 2023
    int i = 0;
    while (i < 14)
    {
    registos [i] = criar_ano_voos ();
    i++;
    }
    return registos;
}

btree_registos_voos* criar_ano_voos ()
{
    btree_registos_voos* novo_ano = calloc (1,sizeof(btree_registos_voos));
    return novo_ano;
}

aeroporto_arvore* contar_destination (aeroporto_arvore* arvore,voo* voo_chegada,int* passageiros_voo,int t) //contabiliza os passageiros nos aeroportos de destino
{
         if (arvore == NULL)
        {
            arvore = criar_aeroporto_vazio();
            strcpy (arvore->pais,voo_chegada->destination); 
                        
            if (voo_chegada->schedule_departure_date[0] == 2021) {arvore->vinte_um   += passageiros_voo[t];}
            else if (voo_chegada->schedule_departure_date[0] == 2022) {arvore->vinte_dois += passageiros_voo[t];}
            else {arvore->vinte_tres += passageiros_voo[t];}  
        }
        else 
        {
            
        if (voo_chegada->schedule_departure_date[0] == 2021) {arvore->vinte_um   += passageiros_voo[t];}
        else if (voo_chegada->schedule_departure_date[0] == 2022) {arvore->vinte_dois += passageiros_voo[t];}
        else {arvore->vinte_tres += passageiros_voo[t];}  

        }
        return arvore;
}

voo* hash_do_voo (int id_novo_voo,voo** hash_voos)
{
    return (hash_voos[id_novo_voo-1]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

aeroporto_arvore* criar_aeroporto_vazio() 
{
    aeroporto_arvore* arvore = malloc (sizeof (aeroporto_arvore));
    arvore->vinte_um = 0;
    arvore->vinte_dois = 0;
    arvore->vinte_tres = 0;
    arvore->Nodo = NULL;
    arvore->direita = NULL;
    arvore->esquerda = NULL;
    return arvore;
}


aeroporto_arvore* inserir_voo (aeroporto_arvore* arvore, voo* Nodo_novo,int* passageiros_voo,int t) //empate ver pelo id
    {
        if (arvore == NULL)             //insere e contabiliza voos pelo aeroporto de origem
        {
            arvore = criar_aeroporto_vazio();
            strcpy (arvore->pais,Nodo_novo->origin);
            if (Nodo_novo->schedule_departure_date[0] == 2021) {arvore->vinte_um   += passageiros_voo[t];}
            else if (Nodo_novo->schedule_departure_date[0] == 2022) {arvore->vinte_dois += passageiros_voo[t];}
            else {arvore->vinte_tres += passageiros_voo[t];}  
            arvore->Nodo = Nodo_novo;  
        }
        else 
        { 
        //strcpy (arvore->pais,Nodo_novo->origin);    
        if (Nodo_novo->schedule_departure_date[0] == 2021) {arvore->vinte_um   += passageiros_voo[t];}
        else if (Nodo_novo->schedule_departure_date[0] == 2022) {arvore->vinte_dois += passageiros_voo[t];}
        else {arvore->vinte_tres += passageiros_voo[t];}   
         
        if (arvore->Nodo == NULL)
        {
            arvore->Nodo = Nodo_novo;
        }
        else 
        {
        int valor;
        valor = compara_data_voos(arvore->Nodo->schedule_departure_date,Nodo_novo->schedule_departure_date); //Compara datas está na reservas

        if (valor == 1)
            {
                arvore->esquerda = inserir_voo_simple (arvore->esquerda,Nodo_novo,passageiros_voo,t);  
            }
            else if (valor == 2)
            {
                 arvore->direita = inserir_voo_simple (arvore->direita,Nodo_novo,passageiros_voo,t); 
            }
             else                        //desempate pelo id de voo
             {
               if (compara_ids_voo(arvore->Nodo->id,Nodo_novo->id) == 1)
                 {
                    arvore->direita = inserir_voo_simple (arvore->direita,Nodo_novo,passageiros_voo,t);
                 }
                 else 
                 {
                     arvore->esquerda = inserir_voo_simple (arvore->esquerda,Nodo_novo,passageiros_voo,t);
                 }
             }
            }
        }
        return arvore;
    } 

aeroporto_arvore* inserir_voo_simple (aeroporto_arvore* arvore, voo* Nodo_novo,int* passageiros_voo,int t) //empate ver pelo id
    {
        if (arvore == NULL)             //insere e contabiliza voos pelo aeroporto de origem
        {
            arvore = criar_aeroporto_vazio();
            arvore->Nodo = Nodo_novo;  
        }
        else 
        { 
        if (arvore->Nodo == NULL)
        {
            arvore->Nodo = Nodo_novo;
        }
        else 
        {
        int valor;
        valor = compara_data_voos(arvore->Nodo->schedule_departure_date,Nodo_novo->schedule_departure_date); //Compara datas está na reservas

        if (valor == 1)
            {
                arvore->esquerda = inserir_voo_simple (arvore->esquerda,Nodo_novo,passageiros_voo,t);  
            }
            else if (valor == 2)
            {
                 arvore->direita = inserir_voo_simple (arvore->direita,Nodo_novo,passageiros_voo,t); 
            }
             else                        //desempate pelo id de voo
             {
               if (compara_ids_voo(arvore->Nodo->id,Nodo_novo->id) == 1)
                 {
                    arvore->direita = inserir_voo_simple (arvore->direita,Nodo_novo,passageiros_voo,t);
                 }
                 else 
                 {
                     arvore->esquerda = inserir_voo_simple (arvore->esquerda,Nodo_novo,passageiros_voo,t);
                 }
             }
            }
        }
        return arvore;
    }   


int compara_data_voos(int data_inicial[6], int data_final[6]) {
    for (int i = 0; i < 6; i++)                                 
    {
        if (data_inicial[i] > data_final[i]) 
        {
            return 1; // 1 se 1 for maior
        } else if (data_inicial[i] < data_final[i]) {
            return 2;  // 2 se 2 for maior
        }
    }
    return 3;  //3 se for igual 
}    

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

voo* cria_voo() 
{
    voo* novo_aeroporto = malloc(sizeof(struct VOO));
    return novo_aeroporto;
}

voo* guarda_voo_T (voo* novo_voo ,char* id,char* airline,char* model,char* total_seats,char* origin,char* destination,char* schedule_departure_date
                         ,char* schedule_arrival_date,char* real_departure_date,char* real_arrival_date,char* pilot,char* copilot,char* notes) 
{
        
        strcpy (novo_voo->id,id);
        strcpy (novo_voo->airline,airline);
        strcpy (novo_voo->model,model);
        strcpy (novo_voo->total_seats,total_seats);
        strcpy (novo_voo->origin,origin);
        strcpy (novo_voo->destination,destination);
        for(int i = 0 ; i < 3; i++)
        {
           novo_voo->origin[i] = toupper(novo_voo->origin[i]);
           novo_voo->destination[i] = toupper(novo_voo->destination[i]);
        }
        converter_schedule (schedule_departure_date,novo_voo->schedule_departure_date);
        converter_schedule (schedule_arrival_date,novo_voo->schedule_arrival_date);     //guardamos as datas como inteiros
        converter_schedule (real_departure_date,novo_voo->real_departure_date);
        converter_schedule (real_arrival_date,novo_voo->real_arrival_date);
        return novo_voo;
}

void converter_schedule (char letras[],int data[])
{
    char* token;
    char* save_tok;
    token = strtok_r(letras,"/",&save_tok);  //pegar ano
    data[0] = atoi (token);
    token = strtok_r(NULL,"/",&save_tok); //pegar mes
    data[1] = atoi (token);
    token = strtok_r(NULL," ",&save_tok); //pegar o dia
    data[2] = atoi (token);
    token = strtok_r(NULL,":",&save_tok); //pegar as horas
    data[3] = atoi (token);
    token = strtok_r(NULL,":",&save_tok); //pegar os minutos
    data[4] = atoi (token);
    const char* delimiter = "\"";
    token = strtok_r(NULL,delimiter,&save_tok); //pegar os segundos
    data[5] = atoi (token);
}

void departure_date_simple (voo* viagem,int data_saida[3])
{
    for (int i = 0; i < 3; i++)
    {
    data_saida[i] = viagem->schedule_departure_date[i];
    }
}

void departure_date (voo* viagem,int data_saida[6])
{
    for (int i = 0; i < 6; i++)
    {
    data_saida[i] = viagem->schedule_departure_date[i];
    }
}





//////////////////////////////////////////////QUERIE 1 V///////////////////////////////////////////////////////////////

int atraso_aviao (int data_real [6],int data_planeada [6]) 
{
    int segundos_r = 0;
    int segundos_p = 0;

    segundos_r += data_real[5];
    segundos_r += data_real[4] * 60;
    segundos_r += data_real[3] * 3600;
    segundos_p += data_planeada[5];
    segundos_p += data_planeada[4] * 60;
    segundos_p += data_planeada[3] * 3600;
    int res = segundos_r - segundos_p;
    return (res > 0 ? res : 0);
}

int retorna_id (voo* voo_novo)
{
    return (atoi (voo_novo->id));
}

void querie1_V_interativa (voo** hash_voos,int* passageiros_voo,char* id,char*resposta,int F)
{
    int select = atoi(id) - 1;
    if (hash_voos[select] == NULL)
    {
        sprintf (resposta, "O voo nao existe\n");
    }
    else 
    {
    int atraso = atraso_aviao (hash_voos[select]->real_departure_date,hash_voos[select]->schedule_departure_date);
    if (F == 0)
    {
    sprintf(resposta,"%s;%s;%s;%s;%d/%02d/%02d %02d:%02d:%02d;%d/%02d/%02d %02d:%02d:%02d;%d;%d\n",
    hash_voos[select]->airline,
    hash_voos[select]->model,
    hash_voos[select]->origin,
    hash_voos[select]->destination,
    hash_voos[select]->schedule_departure_date [0],
    hash_voos[select]->schedule_departure_date [1],
    hash_voos[select]->schedule_departure_date [2],
    hash_voos[select]->schedule_departure_date [3],
    hash_voos[select]->schedule_departure_date [4],
    hash_voos[select]->schedule_departure_date [5],
    hash_voos[select]->schedule_arrival_date [0],
    hash_voos[select]->schedule_arrival_date [1],
    hash_voos[select]->schedule_arrival_date [2],
    hash_voos[select]->schedule_arrival_date [3],
    hash_voos[select]->schedule_arrival_date [4],
    hash_voos[select]->schedule_arrival_date [5],
    passageiros_voo [select],
    atraso
    );
     }
    else 
    {
    sprintf(resposta,"--- 1 ---\nairline: %s\nplane_model: %s\norigin: %s\ndestination: %s\nschedule_departure_date: %d/%02d/%02d %02d:%02d:%02d\nschedule_arrival_date: %d/%02d/%02d %02d:%02d:%02d\npassengers: %d\ndelay: %d\n",
    hash_voos[select]->airline,
    hash_voos[select]->model,
    hash_voos[select]->origin,
    hash_voos[select]->destination,
    hash_voos[select]->schedule_departure_date [0],
    hash_voos[select]->schedule_departure_date [1],
    hash_voos[select]->schedule_departure_date [2],
    hash_voos[select]->schedule_departure_date [3],
    hash_voos[select]->schedule_departure_date [4],
    hash_voos[select]->schedule_departure_date [5],
    hash_voos[select]->schedule_arrival_date [0],
    hash_voos[select]->schedule_arrival_date [1],
    hash_voos[select]->schedule_arrival_date [2],
    hash_voos[select]->schedule_arrival_date [3],
    hash_voos[select]->schedule_arrival_date [4],
    hash_voos[select]->schedule_arrival_date [5],
    passageiros_voo [select],
    atraso
    );
    }
    }
}

void print_querie_1_V (voo** hash_voos,int* passageiros_voo,char* id,FILE* ficheiro_output,int F)
{
    int select = atoi(id) - 1;
    if (hash_voos[select] != NULL)
    {
    int atraso = atraso_aviao (hash_voos[select]->real_departure_date,hash_voos[select]->schedule_departure_date);
    if (F == 0)
    {
    fprintf(ficheiro_output,"%s;%s;%s;%s;%d/%02d/%02d %02d:%02d:%02d;%d/%02d/%02d %02d:%02d:%02d;%d;%d\n",
    hash_voos[select]->airline,
    hash_voos[select]->model,
    hash_voos[select]->origin,
    hash_voos[select]->destination,
    hash_voos[select]->schedule_departure_date [0],
    hash_voos[select]->schedule_departure_date [1],
    hash_voos[select]->schedule_departure_date [2],
    hash_voos[select]->schedule_departure_date [3],
    hash_voos[select]->schedule_departure_date [4],
    hash_voos[select]->schedule_departure_date [5],
    hash_voos[select]->schedule_arrival_date [0],
    hash_voos[select]->schedule_arrival_date [1],
    hash_voos[select]->schedule_arrival_date [2],
    hash_voos[select]->schedule_arrival_date [3],
    hash_voos[select]->schedule_arrival_date [4],
    hash_voos[select]->schedule_arrival_date [5],
    passageiros_voo [select],
    atraso
    );
     }
    else 
    {
    fprintf(ficheiro_output,"--- 1 ---\nairline: %s\nplane_model: %s\norigin: %s\ndestination: %s\nschedule_departure_date: %d/%02d/%02d %02d:%02d:%02d\nschedule_arrival_date: %d/%02d/%02d %02d:%02d:%02d\npassengers: %d\ndelay: %d\n",
    hash_voos[select]->airline,
    hash_voos[select]->model,
    hash_voos[select]->origin,
    hash_voos[select]->destination,
    hash_voos[select]->schedule_departure_date [0],
    hash_voos[select]->schedule_departure_date [1],
    hash_voos[select]->schedule_departure_date [2],
    hash_voos[select]->schedule_departure_date [3],
    hash_voos[select]->schedule_departure_date [4],
    hash_voos[select]->schedule_departure_date [5],
    hash_voos[select]->schedule_arrival_date [0],
    hash_voos[select]->schedule_arrival_date [1],
    hash_voos[select]->schedule_arrival_date [2],
    hash_voos[select]->schedule_arrival_date [3],
    hash_voos[select]->schedule_arrival_date [4],
    hash_voos[select]->schedule_arrival_date [5],
    passageiros_voo [select],
    atraso
    );
    }
    }
}





/////////////////////////////////////////////////QUERIE 5////////////////////////////////////////////////////////////////////

void querie5_interativa (aeroporto_arvore* arvore_o,char* resposta,int data_inicio[6],int data_fim[6],int* contador,int F)
{
    if (arvore_o == NULL) return;
    if (arvore_o->Nodo == NULL) return;


    if (compara_data_voos ((arvore_o->Nodo->schedule_departure_date),data_fim) == 1 ) // se a data for maior q a data de fim do range
    {
        querie5_interativa (arvore_o->esquerda,resposta,data_inicio,data_fim,contador,F);  //esquerda pq data era muito recente
    }    
    else if (compara_data_voos ((arvore_o->Nodo->schedule_departure_date),data_inicio) == 2) // se a data for menor q a data de inicio do range
    { 
        querie5_interativa (arvore_o->direita,resposta,data_inicio,data_fim,contador,F); //direita pq data era muito antiga
    }
    else 
    {
    querie5_interativa (arvore_o->direita,resposta,data_inicio,data_fim,contador,F); 
    
    if (F == 0)
    {
    sprintf(resposta + strlen(resposta),"%s;",arvore_o->Nodo->id); 
    sprintf(resposta + strlen(resposta),"%d/%02d/%02d ",arvore_o->Nodo->schedule_departure_date[0],arvore_o->Nodo->schedule_departure_date[1],arvore_o->Nodo->schedule_departure_date[2]);
    sprintf(resposta + strlen(resposta),"%02d:%02d:%02d;",arvore_o->Nodo->schedule_departure_date[3],arvore_o->Nodo->schedule_departure_date[4],arvore_o->Nodo->schedule_departure_date[5]);
    sprintf(resposta + strlen(resposta),"%s;%s;%s\n",arvore_o->Nodo->destination,arvore_o->Nodo->airline,arvore_o->Nodo->model); 
    }
    else
    {
    sprintf(resposta+ strlen (resposta),"--- %d ---\n",*contador);
    (*contador)++;

    sprintf(resposta+ strlen (resposta),"id: %s\n",arvore_o->Nodo->id); 

    sprintf(resposta+ strlen (resposta),"schedule_departure_date: "); 
    sprintf(resposta+ strlen (resposta),"%d/%02d/%02d ",arvore_o->Nodo->schedule_departure_date[0],arvore_o->Nodo->schedule_departure_date[1],arvore_o->Nodo->schedule_departure_date[2]);
    sprintf(resposta+ strlen (resposta),"%02d:%02d:%02d\n",arvore_o->Nodo->schedule_departure_date[3],arvore_o->Nodo->schedule_departure_date[4],arvore_o->Nodo->schedule_departure_date[5]);
    
    sprintf(resposta+ strlen (resposta),"destination: %s\nairline: %s\nplane_model: %s\n",arvore_o->Nodo->destination,arvore_o->Nodo->airline,arvore_o->Nodo->model);
    sprintf(resposta+ strlen (resposta)," \n"); 
    }

    querie5_interativa (arvore_o->esquerda,resposta,data_inicio,data_fim,contador,F);   
    }
}

void print_querie_5 (aeroporto_arvore* arvore_o,FILE* ficheiro_output,int data_inicio[6],int data_fim[6])
{
    if (arvore_o == NULL) return;
    if (arvore_o->Nodo == NULL) return;
    

    if (compara_data_voos ((arvore_o->Nodo->schedule_departure_date),data_fim) == 1 ) // se a data for maior q a data de fim do range
    {
        print_querie_5 (arvore_o->esquerda,ficheiro_output,data_inicio,data_fim);  //esquerda pq data era muito recente
    }    
    else if (compara_data_voos ((arvore_o->Nodo->schedule_departure_date),data_inicio) == 2) // se a data for menor q a data de inicio do range
    { 
        print_querie_5 (arvore_o->direita,ficheiro_output,data_inicio,data_fim); //direita pq data era muito antiga
    }
    else 
    {
    print_querie_5 (arvore_o->direita,ficheiro_output,data_inicio,data_fim); 
    
    fprintf(ficheiro_output,"%s;",arvore_o->Nodo->id); 

    fprintf(ficheiro_output,"%d/%02d/%02d ",arvore_o->Nodo->schedule_departure_date[0],arvore_o->Nodo->schedule_departure_date[1],arvore_o->Nodo->schedule_departure_date[2]);
    fprintf(ficheiro_output,"%02d:%02d:%02d;",arvore_o->Nodo->schedule_departure_date[3],arvore_o->Nodo->schedule_departure_date[4],arvore_o->Nodo->schedule_departure_date[5]);
    
    fprintf(ficheiro_output,"%s;%s;%s\n",arvore_o->Nodo->destination,arvore_o->Nodo->airline,arvore_o->Nodo->model); 

    print_querie_5 (arvore_o->esquerda,ficheiro_output,data_inicio,data_fim);   
    }
}

void print_querie_5F (aeroporto_arvore* arvore_o,FILE* ficheiro_output,int data_inicio[6],int data_fim[6],int* contador)
{
    if (arvore_o == NULL) return;
    if (arvore_o->Nodo == NULL) return;

    if (compara_data_voos ((arvore_o->Nodo->schedule_departure_date),data_fim) == 1 ) // sigual a print_querie5
    {
        print_querie_5F (arvore_o->esquerda,ficheiro_output,data_inicio,data_fim,contador);  
    }    
    else if (compara_data_voos ((arvore_o->Nodo->schedule_departure_date),data_inicio) == 2) 
    { 
        print_querie_5F (arvore_o->direita,ficheiro_output,data_inicio,data_fim,contador); 
    }
    else 
    {
    print_querie_5F (arvore_o->direita,ficheiro_output,data_inicio,data_fim,contador); 

    if (*contador != 1) fprintf(ficheiro_output,"\n");
    fprintf(ficheiro_output,"--- %d ---\n",*contador);
    (*contador)++;

    fprintf(ficheiro_output,"id: %s\n",arvore_o->Nodo->id); 

    fprintf(ficheiro_output,"schedule_departure_date: "); 
    fprintf(ficheiro_output,"%d/%02d/%02d ",arvore_o->Nodo->schedule_departure_date[0],arvore_o->Nodo->schedule_departure_date[1],arvore_o->Nodo->schedule_departure_date[2]);
    fprintf(ficheiro_output,"%02d:%02d:%02d\n",arvore_o->Nodo->schedule_departure_date[3],arvore_o->Nodo->schedule_departure_date[4],arvore_o->Nodo->schedule_departure_date[5]);
    
    fprintf(ficheiro_output,"destination: %s\nairline: %s\nplane_model: %s\n",arvore_o->Nodo->destination,arvore_o->Nodo->airline,arvore_o->Nodo->model); 

    print_querie_5F (arvore_o->esquerda,ficheiro_output,data_inicio,data_fim,contador); 
    }
}

void querie6_interativa (GHashTable* hash_tree,int ano,int N,char* resposta,int F)
{

    size_t tamanho_array = 35;
    int indice = 0;
    int valores [tamanho_array];
    char paises[tamanho_array][4];
    int e = 0;

    for (int p = 0; p < tamanho_array;p++)
    {
        valores[p] = 0;
    }

    GHashTableIter iter;
    g_hash_table_iter_init(&iter, hash_tree);
    
    gpointer key, value;
    aeroporto_arvore* arvore = NULL;
    while (g_hash_table_iter_next(&iter, &key, &value)) 
    {
        arvore = value;
        if (ano == 2021) {valores [indice] = arvore->vinte_um; e = 1;}
        if (ano == 2022) {valores [indice] = arvore->vinte_dois;e = 1;}
        if (ano == 2023) {valores [indice] = arvore->vinte_tres; e = 1;}
        strcpy (paises[indice],arvore->pais);
        indice++;
    }

    if (e == 0) 
    {
        strcpy (resposta, "Nao existem dados para esse ano!");
        return;
    }
    
    int contador = 0;
    if (N > indice) N = indice;
    if (F == 0)
    {
    while (contador < N)
        {
        int maior = max_indi (valores,paises,indice);            //a funcao retorna o indice com o maior numero de passageiros 
        sprintf (resposta + strlen (resposta),"%s;%d\n",paises[maior],valores[maior]); //sao imprimidos n vezes 
        valores[maior] = 0; //valor alterado para 0 pois ja foi imprimido
        contador++;         
        }                   //nao foi levado em conta o caso de N > contador mas nesse caso seria imprimido um pais com 0 passageiros no ano repetidamente
    }
    else 
    {
    while (contador < N)
        {
        int maior = max_indi (valores,paises,indice);
        sprintf(resposta + strlen (resposta),"--- %d ---\n",contador + 1);           //apenas adicionamos o cabecalho 
        sprintf (resposta + strlen (resposta),"name: %s\npassengers: %d\n",paises[maior],valores[maior]);
        sprintf(resposta + strlen (resposta)," \n");
        valores[maior] = 0;
        contador++;
        }
    }

}

void print_querie_6(GHashTable* hash_tree,int ano, int N,FILE* ficheiro_output,int F)
{
    size_t tamanho_array = 35;
    int indice = 0;
    int valores [tamanho_array];
    char paises [tamanho_array][4];

    for (int p = 0; p < tamanho_array;p++)
    {
        valores[p] = 0;
    }

    GHashTableIter iter;
    g_hash_table_iter_init(&iter, hash_tree);
    
    gpointer key, value;
    aeroporto_arvore* arvore = NULL;
    while (g_hash_table_iter_next(&iter, &key, &value)) 
    {
        arvore = value;
        if (ano == 2021) valores [indice] = arvore->vinte_um;
        if (ano == 2022) valores [indice] = arvore->vinte_dois;
        if (ano == 2023) valores [indice] = arvore->vinte_tres;
        strcpy (paises[indice],arvore->pais);
        indice++;
    }
    
    int contador = 0;
    if (N > indice) N = indice;
    if (F == 0)
    {
    while (contador < N)
        {
        int maior = max_indi (valores,paises,indice);            //a funcao retorna o indice com o maior numero de passageiros 
        fprintf (ficheiro_output,"%s;%d\n",paises[maior],valores[maior]); //sao imprimidos n vezes 
        valores[maior] = 0; //valor alterado para 0 pois ja foi imprimido
        contador++;         
        }                   //nao foi levado em conta o caso de N > contador mas nesse caso seria imprimido um pais com 0 passageiros no ano repetidamente
    }
    else 
    {
    while (contador < N)
        {
        int maior = max_indi (valores,paises,indice);
        if (contador != 0) fprintf(ficheiro_output,"\n");
        fprintf(ficheiro_output,"--- %d ---\n",contador + 1);           //apenas adicionamos o cabecalho 
        fprintf (ficheiro_output,"name: %s\npassengers: %d\n",paises[maior],valores[maior]);
        valores[maior] = 0;
        contador++;
        }
    }

}

///////////////////////////////////////////////////////////QUERIE 7//////////////////////////////////////////////////////////////

void querie7_interativa (GHashTable* hash_tree,int N,char* resposta,int n_voos,int F)
{
    int medianas [N];
    char Aeroportos [N][4];
    int preenchido = 0;


    GHashTableIter iter;
    g_hash_table_iter_init(&iter, hash_tree);

    gpointer key, value;
    aeroporto_arvore* arvore = NULL;
    while (g_hash_table_iter_next(&iter, &key, &value)) 
    {
        arvore = value;
        if (arvore->Nodo != NULL)
        {
        if (preenchido < N )
            {
            medianas [preenchido] = fazer_mediana_aeroporto (arvore,n_voos);
            strcpy (Aeroportos [preenchido], arvore->pais);
            preenchido++;
            }
            else 
            {
                int mediana_nova = fazer_mediana_aeroporto (arvore,n_voos);
                int indice = substituir_menor (medianas,mediana_nova,Aeroportos,N,arvore->pais); //desempate pelo nome
                if (indice != -1) 
                {
                strcpy (Aeroportos[indice],arvore->pais);
                medianas[indice] = mediana_nova;
                } 
             } 
        }
    }


    heapsort (medianas,Aeroportos,preenchido);


    if(F == 1)
    {
        int counter = 1;

        for(int j = preenchido - 1; j >= preenchido - N && j >= 0; j--)
        {
            sprintf(resposta + strlen (resposta),"--- %d ---\n",counter);
            counter++;
            sprintf(resposta + strlen (resposta),"name: %s\n",Aeroportos[j]);
            sprintf(resposta + strlen (resposta),"median: %d\n",medianas[j]);
            sprintf(resposta + strlen (resposta)," \n");
        }
    }
    else  //quando F == 0
    {
        for(int j = preenchido - 1; j >= preenchido - N && j >= 0; j--)
        {
            sprintf(resposta + strlen (resposta),"%s;%d\n",Aeroportos[j],medianas[j]);
        }
    }

}

void print_querie_7 (GHashTable* hash_tree,int N,FILE *ficheiro_output,int n_voos,int F)
{
    int medianas [N];
    char Aeroportos [N][4];
    int preenchido = 0;


    GHashTableIter iter;
    g_hash_table_iter_init(&iter, hash_tree);

    gpointer key, value;
    aeroporto_arvore* arvore = NULL;
    while (g_hash_table_iter_next(&iter, &key, &value)) 
    {
        arvore = value;
        if (arvore->Nodo != NULL)
        {
        if (preenchido < N )
            {
            medianas [preenchido] = fazer_mediana_aeroporto (arvore,n_voos);
            strcpy (Aeroportos [preenchido], arvore->pais);
            preenchido++;
            }
            else 
            {
                int mediana_nova = fazer_mediana_aeroporto (arvore,n_voos);
                int indice = substituir_menor (medianas,mediana_nova,Aeroportos,N,arvore->pais); //desempate pelo nome
                if (indice != -1) 
                {
                strcpy (Aeroportos[indice],arvore->pais);
                medianas[indice] = mediana_nova;
                } 
             } 
        }
    }


    heapsort (medianas,Aeroportos,preenchido);


    if(F == 1)
    {
        int counter = 1;

        for(int j = preenchido - 1; j >= preenchido - N && j >= 0; j--)
        {
            if(counter != 1) fprintf(ficheiro_output,"\n");
            fprintf(ficheiro_output,"--- %d ---\n",counter);
            counter++;
            fprintf(ficheiro_output,"name: %s\n",Aeroportos[j]);
            fprintf(ficheiro_output,"median: %d\n",medianas[j]);
        }
    }
    else  //quando F == 0
    {
        for(int j = preenchido - 1; j >= preenchido - N && j >= 0; j--)
        {
            fprintf(ficheiro_output,"%s;%d\n",Aeroportos[j],medianas[j]);
        }
    }

}

void swap(int *indice_nova_mediana,int *indice_mediana_antiga,char aeroportos_novo[4],char aeroporto_antigo[4]) 
{
    int temp_mediana = *indice_nova_mediana;
    char temp_aeroporto[30];
    strcpy(temp_aeroporto,aeroportos_novo);

    *indice_nova_mediana = *indice_mediana_antiga;
    *indice_mediana_antiga = temp_mediana; 

    strcpy(aeroportos_novo,aeroporto_antigo);
    strcpy(aeroporto_antigo,temp_aeroporto);

}


void heapify(int medianas[], char Aeroportos[][4], int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n)
    {
       if (medianas[left] > medianas[largest] || (medianas[left] == medianas[largest] && (strcmp (Aeroportos[left],Aeroportos[largest])) < 0)) {
           largest = left;
       }
    }
    if (right < n)
    {
      if (medianas[right] > medianas[largest] || (medianas[right] == medianas[largest] && (strcmp (Aeroportos[right],Aeroportos[largest])) < 0)) {
          largest = right;
      }
    }
    if (largest != i)
        {
        swap(&medianas[i], &medianas[largest], Aeroportos[i], Aeroportos[largest]);
        heapify(medianas, Aeroportos, n, largest);
        }
}

void heapsort(int medianas[], char Aeroportos[][4], int n) {
    // Build heap (rearrange array)
    for (int i = n / 2 - 1; i >= 0; i--) {
        heapify(medianas, Aeroportos, n, i);
    }

    // One by one extract an element from the heap
    for (int i = n - 1; i > 0; i--) {
        swap(&medianas[0], &medianas[i], Aeroportos[0], Aeroportos[i]);
        heapify(medianas, Aeroportos, i, 0);
    }
}

int substituir_menor (int medianas[],int mediana_nova,char Aeroportos[][4],int N,char pais[4])
{
    int indice_menor,menor_valor,i;
    indice_menor = -1;
    menor_valor = mediana_nova;
    for (i = 0; i < N ;i++)
    {
        if (medianas [i] < menor_valor)
        {
        menor_valor = medianas[i];
        indice_menor = i;
        }
        else if (menor_valor == medianas[i])
        {
            if (indice_menor != -1 )
            {
            if (strcmp (Aeroportos[i],Aeroportos[indice_menor]) > 0) indice_menor = i;
            }
            else 
            {
            if (strcmp (Aeroportos[i],pais) > 0) indice_menor = i;
            }
        }
    }
    return indice_menor;
}

int fazer_mediana_aeroporto (aeroporto_arvore* aeroporto,int n_voos) 
{
    if (aeroporto->Nodo == NULL) return 0;
    size_t tamanho_array = (n_voos/2);
    int preenchido = 0;
    int array [tamanho_array];
    for (int i = 0; i < tamanho_array;i++) {array[i] = 0;}
    int resultado;
    inserir_atraso_lista (aeroporto,array,&preenchido,&tamanho_array);

    int array_calcular[preenchido];
    for (int i = 0; i < preenchido;i++) {array_calcular[i] = array[i];}

    merge_sort (array_calcular,preenchido);
    if (preenchido %2 == 1)
    {                       
        resultado = (array_calcular [preenchido/2]);
    }
    else
    {
        resultado = ((array_calcular[preenchido/2 - 1] + array_calcular[preenchido/2])/2);
    }
    return resultado;
}

void merge(int arr[], int left[], int left_size, int right[], int right_size) {
    int i = 0, j = 0, k = 0;

    while (i < left_size && j < right_size) {
        if (left[i] <= right[j]) {
            arr[k] = left[i];
            i++;
        } else {
            arr[k] = right[j];
            j++;
        }
        k++;
    }

    while (i < left_size) {
        arr[k] = left[i];
        i++;
        k++;
    }

    while (j < right_size) {
        arr[k] = right[j];
        j++;
        k++;
    }
}

void merge_sort(int arr[], int size) {
    if (size > 1) {
        int mid = size / 2;
        int *left = (int *)malloc(mid * sizeof(int));
        int *right = (int *)malloc((size - mid) * sizeof(int));

        for (int i = 0; i < mid; i++) {
            left[i] = arr[i];
        }

        for (int i = mid; i < size; i++) {
            right[i - mid] = arr[i];
        }

        merge_sort(left, mid);
        merge_sort(right, size - mid);
        merge(arr, left, mid, right, size - mid);

        free(left);
        free(right);
    }
}

void inserir_atraso_lista (aeroporto_arvore* aeroporto,int* array,int* preenchido,size_t* tamanho_array)
{
    if (aeroporto == NULL) return;
    if (aeroporto->Nodo == NULL) return;
    inserir_atraso_lista (aeroporto->esquerda,array,preenchido,tamanho_array);


    array[*preenchido] = calcula_atraso_voo (aeroporto->Nodo->schedule_departure_date,aeroporto->Nodo->real_departure_date);
    (*preenchido)++;

    inserir_atraso_lista (aeroporto->direita,array,preenchido,tamanho_array);
}

int calcula_atraso_voo (int data_prevista[6],int data_real [6])
{
    
    int atraso = 0;
    int calcular_dias_prevista [3] = {data_prevista[0],data_prevista[1],data_prevista[2]};
    int calcular_dias_real [3] = {data_real[0],data_real[1],data_real[2]};
    atraso -= (diferenca_dias_atrasos (calcular_dias_prevista,calcular_dias_real)) * 3600 *24;
    atraso -= (data_prevista[3] - data_real[3]) * 3600;
    atraso -= (data_prevista[4] - data_real[4]) * 60;
    atraso -= data_prevista[5] - data_real[5];

    if (atraso < 0) return 0;
    return atraso;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int max_indi (int* valores,char paises[][4],int n)
{
    int maior_i = 0,i = 0;
    int valor_maior = 0;
    while (i < n)
    {
            if (valores[i] > valor_maior)
            {
                valor_maior = valores[i];
                maior_i = i;
            }
            else if (valores[i] == valor_maior && strcmp (paises [i],paises[maior_i])  < 0)
            {
                maior_i = i;
            }
        i++;
    }
    return maior_i;
}

//////////////////////////////////////////////////////QUERIE 9////////////////////////////////////////////////////////////////////

void encontrar_voos_data (int data[2],aeroporto_arvore* arvore_todos_voos,int* voos_a_contar,int* tempo_do_voo,int tipo)
{
    if (arvore_todos_voos == NULL) return;
    if (arvore_todos_voos->Nodo == NULL) return;

    if (tipo == 0)
    {
        if (arvore_todos_voos->Nodo->schedule_departure_date[0] < data[0])  //ano maior q arvore
        {
            encontrar_voos_data (data,arvore_todos_voos->direita,voos_a_contar,tempo_do_voo,0);
        }
        else if (arvore_todos_voos->Nodo->schedule_departure_date[0] > data[0]) //ano menor q arvore
        {
            encontrar_voos_data (data,arvore_todos_voos->esquerda,voos_a_contar,tempo_do_voo,0);
        }
        else  if (arvore_todos_voos->Nodo->schedule_departure_date[1] < data[1])  //mes maior q arvore
        {
            encontrar_voos_data (data,arvore_todos_voos->direita,voos_a_contar,tempo_do_voo,0);
        }
        else if (arvore_todos_voos->Nodo->schedule_departure_date[1] > data[1]) //mes menor q arvore
        {
            encontrar_voos_data (data,arvore_todos_voos->esquerda,voos_a_contar,tempo_do_voo,0);
        }
        else 
        {
            encontrar_voos_data (data,arvore_todos_voos->esquerda,voos_a_contar,tempo_do_voo,0);
            
            voos_a_contar [atoi (arvore_todos_voos->Nodo->id)-1] = 1;
            tempo_do_voo [atoi (arvore_todos_voos->Nodo->id)-1] = arvore_todos_voos->Nodo->schedule_departure_date[2];
            
    
            encontrar_voos_data (data,arvore_todos_voos->direita,voos_a_contar,tempo_do_voo,0);
    }
    }
    else 
    {
            if (arvore_todos_voos->Nodo->schedule_departure_date[0] < data[0])  //ano maior q arvore
       {
           encontrar_voos_data (data,arvore_todos_voos->direita,voos_a_contar,tempo_do_voo,1);
       }
       else if (arvore_todos_voos->Nodo->schedule_departure_date[0] > data[0]) //ano menor q arvore
       {
           encontrar_voos_data (data,arvore_todos_voos->esquerda,voos_a_contar,tempo_do_voo,1);
       }
       else    
       {
          encontrar_voos_data (data,arvore_todos_voos->esquerda,voos_a_contar,tempo_do_voo,1);
           
           voos_a_contar [atoi (arvore_todos_voos->Nodo->id)-1] = 1;
           tempo_do_voo [atoi (arvore_todos_voos->Nodo->id)-1] = arvore_todos_voos->Nodo->schedule_departure_date[1];
           
   
           encontrar_voos_data (data,arvore_todos_voos->direita,voos_a_contar,tempo_do_voo,1);
    }
    }
}

void encontrar_voos_data_todos (int data[2],aeroporto_arvore* arvore_todos_voos,int* ano_dos_voos)
{
    if (arvore_todos_voos == NULL) return;
    if (arvore_todos_voos->Nodo == NULL) return;

    encontrar_voos_data_todos (data,arvore_todos_voos->esquerda,ano_dos_voos);
           
           
    ano_dos_voos [atoi (arvore_todos_voos->Nodo->id)-1] = arvore_todos_voos->Nodo->schedule_departure_date[0];
           

    encontrar_voos_data_todos (data,arvore_todos_voos->direita,ano_dos_voos);
}





void calcular_voos_data (int data[2],btree_registos_voos** anos_registos_voos,int numeros_voos[],int tipo)
{
    int ano = data[0] - 2010;
    int i = 0;
    if (tipo == MES)
    {
        switch (data[1])
        {
            case 1:
                    for (i = 0; i < 31;i++)  numeros_voos[i] = anos_registos_voos[ano]->Janeiro[i];
                    break;
            case 2:
                    for (i = 0; i < 31;i++) numeros_voos[i] = anos_registos_voos[ano]->Fevereiro[i];
                    break;
            case 3:
                   for (i = 0; i < 31;i++)  numeros_voos[i] = anos_registos_voos[ano]->Marco[i];
                    break;
            case 4:
                    for (i = 0; i < 31;i++) numeros_voos[i] = anos_registos_voos[ano]->Abril[i];
                    break;
            case 5:
                   for (i = 0; i < 31;i++)  numeros_voos[i] = anos_registos_voos[ano]->Maio[i];
                    break;
            case 6:
                    for (i = 0; i < 31;i++) numeros_voos[i] = anos_registos_voos[ano]->Junho[i];
                    break;
            case 7:     
                    for (i = 0; i < 31;i++) numeros_voos[i] = anos_registos_voos[ano]->Julho[i];
                    break;
            case 8:
                    for (i = 0; i < 31;i++) numeros_voos[i] = anos_registos_voos[ano]->Agosto[i];
                    break;
            case 9:
                    for (i = 0; i < 31;i++) numeros_voos[i] = anos_registos_voos[ano]->Setembro[i];
                    break;
            case 10:
                    for (i = 0; i < 31;i++) numeros_voos[i] = anos_registos_voos[ano]->Outubro[i];
                    break;
            case 11:
                    for (i = 0; i < 31;i++) numeros_voos[i] = anos_registos_voos[ano]->Novembro[i];
                    break;
            case 12:
                    for (i = 0; i < 31;i++) numeros_voos[i] = anos_registos_voos[ano]->Decembro[i];
                    break;
        }
    } else if (tipo == ANO)
    {
        numeros_voos[0] = sum (anos_registos_voos[ano]->Janeiro,30);
        numeros_voos[1] = sum (anos_registos_voos[ano]->Fevereiro,30);
        numeros_voos[2] = sum (anos_registos_voos[ano]->Marco,30);
        numeros_voos[3] = sum (anos_registos_voos[ano]->Abril,30);
        numeros_voos[4] = sum (anos_registos_voos[ano]->Maio,30);
        numeros_voos[5] = sum (anos_registos_voos[ano]->Junho,30);
        numeros_voos[6] = sum (anos_registos_voos[ano]->Julho,30);
        numeros_voos[7] = sum (anos_registos_voos[ano]->Agosto,30);
        numeros_voos[8] = sum (anos_registos_voos[ano]->Setembro,30);
        numeros_voos[9] = sum (anos_registos_voos[ano]->Outubro,30);
        numeros_voos[10] = sum (anos_registos_voos[ano]->Novembro,30);
        numeros_voos[11] = sum (anos_registos_voos[ano]->Decembro,30);
    }
    else 
    {
        numeros_voos[0]  = somar_ano_voos (anos_registos_voos[0]);
        numeros_voos[1]  = somar_ano_voos (anos_registos_voos[1]);
        numeros_voos[2]  = somar_ano_voos (anos_registos_voos[2]);
        numeros_voos[3]  = somar_ano_voos (anos_registos_voos[3]);
        numeros_voos[4]  = somar_ano_voos (anos_registos_voos[4]);
        numeros_voos[5]  = somar_ano_voos (anos_registos_voos[5]);
        numeros_voos[6]  = somar_ano_voos (anos_registos_voos[6]);
        numeros_voos[7]  = somar_ano_voos (anos_registos_voos[7]);
        numeros_voos[8]  = somar_ano_voos (anos_registos_voos[8]);
        numeros_voos[9]  = somar_ano_voos (anos_registos_voos[9]);
        numeros_voos[10] = somar_ano_voos (anos_registos_voos[10]);
        numeros_voos[11] = somar_ano_voos (anos_registos_voos[11]);
        numeros_voos[12] = somar_ano_voos (anos_registos_voos[12]);
        numeros_voos[13] = somar_ano_voos (anos_registos_voos[13]);
    }
}


int somar_ano_voos (btree_registos_voos* anos_registos_voos)
{
    int valor = 0;
       valor+= sum (anos_registos_voos->Janeiro,30);
       valor+= sum (anos_registos_voos->Fevereiro,30);
       valor+= sum (anos_registos_voos->Marco,30);
       valor+= sum (anos_registos_voos->Abril,30);
       valor+= sum (anos_registos_voos->Maio,30);
       valor+= sum (anos_registos_voos->Junho,30);
       valor+= sum (anos_registos_voos->Julho,30);
       valor+= sum (anos_registos_voos->Agosto,30);
       valor+= sum (anos_registos_voos->Setembro,30);
       valor+= sum (anos_registos_voos->Outubro,30);
       valor+= sum (anos_registos_voos->Novembro,30);
       valor+= sum (anos_registos_voos->Decembro,30);
    return valor;
}


int compara_ids_voo (char* id1,char* id2)
{
    if (atoi (id1) > atoi (id2)) 
    {
        return 1;
    }
    return 0;
}

///////////////////////////////////////////////////frees//////////////////////////////////////////////////

void free_registos_voos(btree_registos_voos** anos_registo_voos)
{
    int p ;
    for (p = 0; p < 14;p++)
    {
        free (anos_registo_voos[p]);
    }
    free (anos_registo_voos);
}


void free_aeroporto (aeroporto_arvore* aeroporto)
{
    if (aeroporto != NULL)
    {
        free_aeroporto(aeroporto->esquerda);
        free(aeroporto->Nodo);
        free_aeroporto(aeroporto->direita);
        free (aeroporto);
    }
}

void free_aeroporto_lite (aeroporto_arvore* aeroporto)
{
    if (aeroporto != NULL)
    {
        free_aeroporto_lite(aeroporto->esquerda);
        free_aeroporto_lite(aeroporto->direita);
        free (aeroporto);
    }
}


void free_voos (GHashTable* hash_aeroportos,voo** hash_voos)
{
    GHashTableIter iter;
    g_hash_table_iter_init(&iter, hash_aeroportos);
    
    gpointer key, value;
    while (g_hash_table_iter_next(&iter, &key, &value)) 
    {
        aeroporto_arvore* destruir = value;
        free_aeroporto_lite (destruir);
    }
    free (hash_voos);

    g_hash_table_destroy (hash_aeroportos);
}


