#include <stdio.h>

#define MAX_HORAS 24
#define MAX_AGENTS 100

int main(void)
{
    //Input do número de agentes
    int A;
    if(scanf("%d", &A) != 1 || A < 1 || A > 100)
    {
        return 1;
    }

    //Input do número de linhas
    int N;
    if(scanf("%d", &N) != 1 || N < 1 || N > 5000)
    {
        return 1;
    }

    int horas[MAX_AGENTS][MAX_HORAS] = {0}; //Guarda nas linhas os agentes e nas colunas as horas
    int codigo;
    int chegada;
    int saida;


    for(int i = 0; i < N;i++)
    {
        if(scanf("%d", &codigo) != 1)
        {
            return 1;
        }

        if(scanf("%d", &chegada) != 1)
        {
            return 1;
        }
        if(scanf("%d", &saida) != 1)
        {
            return 1;
        }

        for(int h = chegada; h <= saida; h++)
        {
            horas[codigo-1][h]++; //Guarda no array, sempre que um agente esteja presente numa dada hora imcrenta 1 nessa posição exata
        }
    }
 

int finish; //Serve para ver se 2 ou mais agentes estavam presentes

  for(int h = 0; h < MAX_HORAS;h++)
    {
        finish = 0;
        for(int i = 0; i < A ;i++)
        {
            if(horas[i][h] != 0)
            {
                finish++; //Sempre que esteja alguem presente o finish incrementa
            }
        }

        if(finish > 1) //Caso estejam mais do que 1 agente no mesmo local, printa os números dos agentes
        {
            printf("%d", h);
            for(int i = 0; i < A;i++)
            {
                if(horas[i][h] != 0)
                {
                    printf(" %d",i+1); //i + 1 para compensar a posição 0
                }
            }
             printf("\n");
        }
    }
}
    

