#include <stdio.h>
#include <stdlib.h>

#define MAX_SIZE 100

int is_cicloinfernal (int linha[],int contador);
int escreve_linha(int linha[],int n_guiches,int guiche_inicial,int resultados[]);


int main(void)
{
    //Input do número de casos
    int n_casos;
    if(scanf("%d", &n_casos) != 1)
    {
        return 1;
    }

    int guarda_guiches[n_casos]; //Guarda quantas guiches tem numa linha
    int guarda_posicoes[n_casos]; //Guarda as posições iniciais de cada linha
    int guarda_linhas[n_casos][MAX_SIZE]; //Matriz que guarda a linha que o utilizador deu input
    int resultados[n_casos][MAX_SIZE]; //Guarda as respostas




    for(int i = 0; i < n_casos; i++)
    {
        if(scanf("%d", &guarda_guiches[i]) != 1) //Input de quantas guiches tem a linha
        {
            return 1;
        }
        
        if(scanf("%d", &guarda_posicoes[i]) != 1) //Input da primeira guiche
        {
            return 1;
        }
        
        for(int j = 0; j < guarda_guiches[i]; j++) //Input da linha
        {
            if(scanf("%d", &guarda_linhas[i][j]) != 1) 
            {
                return 1;
            }
        }
    }

    for(int i = 0; i < n_casos;i++ )
    {
        resultados[i][0] = guarda_posicoes[i];  //A primeira posição é sempre dada
        int contador = escreve_linha(guarda_linhas[i],guarda_guiches[i],guarda_posicoes[i],resultados[i]);
    
        if(contador > 101) //Se estiver num ciclo infernal o meu contador será sempre maior do que 101
        {
            for(int k = 0; k < contador - 101 ; k++)
            {
            printf("%d ", resultados[i][k]);
            }
            printf("CICLO INFERNAL");
        }
        else 
        {
        for(int k = 0; k < contador; k++)
            {
                if (k == contador - 1)             
                {
                    printf("%d", resultados[i][k]);
                }
                else 
                printf("%d ", resultados[i][k]);
            }
             
        }
        printf("\n");
    }
}

//Verifica se uma linha é um ciclo infernal
int is_cicloinfernal (int linha[],int contador)
{
    for(int i = 0; i < contador; i++)
    {
        if(linha[contador] == linha[i]) //O contador vem da função escreve_linha e representa a guiche do fim
        {                               //Se a guiche final for repetida então estamos num ciclo infernal 
            return 0;
        }
    }
    return 1;
}


//Ordena a linha
int escreve_linha(int guarda_linhas[],int n_guiches,int guiche_inicial,int resultados[])
{
    int contador;
    for(contador = 1; contador <= n_guiches; contador++)
    {
        resultados[contador] = guarda_linhas[guiche_inicial-1]; //Ordena a linha
        guiche_inicial = resultados[contador]; //Atualiza a guiche inicial
        if(resultados[contador] == 0) //Se a linha terminar em 0 então retornamos o contador 
        {
           break;
        }
        if(is_cicloinfernal(resultados,contador) != 1) //Se estivermos num ciclo infernal dá-mos "break" ao ciclo for
        {
            contador = 100 + contador;
        }
    }
    return contador;
}

