#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <glib.h>
#include "../include/struct_utilizador.h"
#include "../include/parser.h"
#include "../include/erros.h"
#include "../include/struct_reserva.h"


#define HASH_ERROS 2000
#define HASH_PASSAGEIROS 2000
#define TAMANHO_LINHA 512
#define TAMANHO 6000
#define RESERVA 0
#define VOO 1
#define PASSAGEIROS 2
#define UTILIZADORES 3



void* parser_com_hash (FILE *parse,char *** total_dados,char *ficheiro_erros,GHashTable* erros_utilizadores,int** erros_voos,char* header,int* n_utilizadores)
  {
    erros_utilizadores = g_hash_table_new(g_str_hash,g_str_equal);
    size_t tamanho_total = TAMANHO;
    int* erro_voos = * erros_voos;
    char linha[TAMANHO_LINHA];
    fgets (linha,sizeof(linha),parse);      //ignoramos a linha inicial
    int counter = 0;
    
    FILE* arqv = fopen(ficheiro_erros,"w"); //abrimos o ficheiro de erros para imprimir os mesmos
    fprintf (arqv,"%s\n",header);
    while(fgets (linha,512,parse))
    { 
      if(testa_linha(linha,UTILIZADORES,erros_utilizadores,erro_voos,NULL,NULL) == 1) //funcao testa cada linha dependendo do valor select
      {                                                                 // que permite identificar o tipo de conteudo na linha
            (*total_dados)[counter] = strdup (linha);
            (*n_utilizadores)++;
            counter++;      
      }
      else 
      {
          char temp[1000];
          strcpy(temp,linha);
          char* token;
          char* save_token;
          token = strtok_r(temp,";",&save_token); //Vai guardar nomes quando o id for ;;

          char comparar[100];
          strcpy (comparar,token);
          g_hash_table_insert(erros_utilizadores,g_strdup(comparar),"erro");
          
        fprintf(arqv,"%s",linha);
      }
      if ((counter+2) >= tamanho_total) //alloca espaco quando necessario 
      {
        tamanho_total *= 2;
        (*total_dados) = realloc ((*total_dados),tamanho_total*sizeof(char*));
      }  
    }
    fclose (arqv);
    *erros_voos = erro_voos;

    return erros_utilizadores;
  }

void parser (FILE *parse,char *** total_dados,int select,char *ficheiro_erros,GHashTable* erros_utilizadores,int* passageiros_voo
            ,int** erros_voos,char* header,GHashTable* dados_utilizadores_id,int* n_voos,int* voos_validos,int* n_passageiros
            ,int* n_reservas,void* registos_reservas,GHashTable* verificar_reserva)
  {
    
    size_t tamanho_erros = HASH_ERROS;
    size_t tamanho_total = TAMANHO;
    int* erro_voo_local = * erros_voos;
    char linha[TAMANHO_LINHA];
    fgets (linha,sizeof(linha),parse);      //ignoramos a linha inicial
    int counter = 0;
    int l = 0;
    
    FILE* arqv = fopen(ficheiro_erros,"w"); //abrimos o ficheiro de erros para imprimir os mesmos
    fprintf (arqv,"%s\n",header);
    while(fgets (linha,512,parse))
    { 
      int teste = testa_linha(linha,select,erros_utilizadores,erro_voo_local,registos_reservas,verificar_reserva);
         if(teste == 1) //funcao testa cada linha dependendo do valor select
         {                                                                 // que permite identificar o tipo de conteudo na linha
               (*total_dados)[counter] = malloc (strlen(linha) + 1);
               strcpy ((*total_dados)[counter],linha);
               counter++;      
               if (select == RESERVA) 
               {
                 (*n_reservas)++;
               }
               if (select == PASSAGEIROS )              
               {
                 
                 char* token;
                 char* save_token;
                 token = strtok_r (linha,";",&save_token);
   
                 (*n_passageiros)++;
                 int v = atoi (token) - 1;
                 (passageiros_voo[v]) += 1;
                 token = strtok_r (NULL,"\n",&save_token);
                 aumentar_numero_voos (token,dados_utilizadores_id);
               }
               if (select == VOO)
               {
                 char* token;
                 char* save_token;
                 token = strtok_r (linha,";",&save_token);
                 
                int id_voo = atoi (token) - 1;

                 if (l < (id_voo - 1))
                 {
                  while (l < id_voo - 1) {l++;erro_voo_local[l] = 0;(*n_voos)++;}
                 } 

                 l = id_voo;
                 (*n_voos)++;
                 erro_voo_local[l] = 1;
                 (*voos_validos)++;
               }
         }     
         else
         {
           if(select == VOO)         //se for um voo invalido guardamos no vetor de voos errados
           {
             char temp[1000];
             strcpy(temp,linha);
             char* token;
             char* save_token;
             token = strtok_r(temp,";",&save_token); //Vai guardar nomes quando o id for ;;
             if (atoi (token) != 0)
             {
                int id_voo = atoi (token) - 1;

                 if (l < (id_voo - 1))
                 {
                  while (l < id_voo - 1) {l++;erro_voo_local[l] = 0; l++;(*n_voos)++;}
                 } 
              l = id_voo;
               erro_voo_local[l] = 0;
               (*n_voos)++;
             }
             (*n_voos)++;
  
           } 
           if (teste == 0) fprintf(arqv,"%s",linha);
      }


        if (l + 20 >= tamanho_erros)
            {
               tamanho_erros *= 2;
               (erro_voo_local) = realloc ((erro_voo_local),tamanho_erros * sizeof (int));
            }
         if ((counter + 10) >= tamanho_total) //alloca espaco quando necessario 
         {
           tamanho_total *= 2;
           (*total_dados) = realloc ((*total_dados),tamanho_total*sizeof(char*));
         }  

    } //FIM DO WHILE


    *erros_voos = erro_voo_local;
    fclose (arqv);
  }


void free_matriz (char** total_dados_utilizadores,int numero_utilizadores)
 {
   int i = 0;
  for (i = 0; i < numero_utilizadores; i++) 
    {
        free(total_dados_utilizadores[i]);
    }
  free (total_dados_utilizadores);
 }









  