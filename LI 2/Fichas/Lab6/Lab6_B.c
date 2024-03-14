#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

typedef struct Candidatos   //Struct que tem todas as informações de um cozinheiro
{
    char nome[100];
    int peso;
    int altura;
} candidatos;

void ordena_cozinheiros(candidatos cozinheiros[], int n_cozinheiros);

int main(void)
{
    int n_cozinheiros;
    int i;

    if(scanf("%d", &n_cozinheiros) != 1) //Recebe o número de cozinheiros
    {
        return 1;
    }

    getchar();  //Apaga o \n que aparece depois do scanf

    candidatos cozinheiro[n_cozinheiros]; //Inicia um array de cozinheiros com n_cozinheiros

    for(i = 0; i < n_cozinheiros; i++)
    {
        if(scanf("%s %d %d", cozinheiro[i].nome, &cozinheiro[i].peso , &cozinheiro[i].altura) != 3)   //Input das informações sobre o cozinheiro
        {
            return 1;
        }
    }
    
    ordena_cozinheiros(cozinheiro,n_cozinheiros);  //Ordena a lista de cozinheiros

    for(int i = 0; i < n_cozinheiros; i++)
    {
        printf("%s %d %d\n", cozinheiro[i].nome, cozinheiro[i].peso , cozinheiro[i].altura);    //print da solução
    }

    return 0;
}

void ordena_cozinheiros(candidatos cozinheiros[], int n_cozinheiros) 
{
    candidatos temporario;
    int aux = n_cozinheiros;
    while (aux > 1) 
    {
        for(int i = 0; i < aux - 1; i++) 
        {
            if (abs(cozinheiros[i+1].peso - 90) < abs(cozinheiros[i].peso - 90)) 
            {
                temporario = cozinheiros[i];
                cozinheiros[i] = cozinheiros[i+1];
                cozinheiros[i+1] = temporario;
            } else if (abs(cozinheiros[i+1].peso - 90) == abs(cozinheiros[i].peso - 90)) 
            {
                if (cozinheiros[i+1].altura > cozinheiros[i].altura) 
                {
                    temporario = cozinheiros[i];
                    cozinheiros[i] = cozinheiros[i+1];
                    cozinheiros[i+1] = temporario;
                } else if (cozinheiros[i+1].altura == cozinheiros[i].altura) 
                {
                    if (strcmp(cozinheiros[i].nome, cozinheiros[i+1].nome) > 0) 
                    {
                        temporario = cozinheiros[i];
                        cozinheiros[i] = cozinheiros[i+1];
                        cozinheiros[i+1] = temporario;
                    }
                }
            }
        }
        aux--;
    }
}

/*for(int i = 0; i < n_cozinheiros; i++)
    {
        for(int j = 1 + i; j < n_cozinheiros; j++)
        {
            if(abs(cozinheiros[j].peso - 90) > abs(cozinheiros[i].peso - 90))
            {
                temporario = cozinheiros[i];
                cozinheiros[i] = cozinheiros[j];
                cozinheiros[j] = temporario;
            }
            else if(abs(cozinheiros[j].peso - 90) == abs(cozinheiros[i].peso - 90))
            {
                if(abs(cozinheiros[j].altura) > abs(cozinheiros[i].altura))
                {
                    temporario = cozinheiros[i];
                    cozinheiros[i]= cozinheiros[j];
                    cozinheiros[j] = temporario;
                }
                else if(strcmp(cozinheiros[i].nome,cozinheiros[j].nome) < 0)
                {
                    temporario = cozinheiros[i];
                    cozinheiros[i]= cozinheiros[j];
                    cozinheiros[j] = temporario;
                }
            }
        }
    }
}
*/






