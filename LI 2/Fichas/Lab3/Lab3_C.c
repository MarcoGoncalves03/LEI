#include <stdio.h>

int compara_anao(int alturas[],int k);

int main(void)
{
    //Input do número de casos
    int casos;
    if(scanf("%d", &casos) != 1)
    {
        return 1;
    }

    int k;
    int acc[casos];
    for(int i = 0; i < casos; i++) //Número de linhas 
    {
        if(scanf("%d", &k) != 1) //Número de inteiros por linha
        {
            return 1;
        }
        int alturas[k];
        for (int j = 0; j < k; j++) //Input dos inteiros de uma linha
        {
            if(scanf("%d", &alturas[j]) != 1 || alturas[j] < 0)
            {
                return 1;
            }
        }
       acc[i] = compara_anao(alturas,k); //Número de anaões visivéis numa linha
    }

    //Print da solução
    for (int i = 0; i < casos; i++)
    {
        printf("%d\n", acc[i]);
    }
}

//Verifica quantos anões são visíveis numa dada linha
int compara_anao(int alturas[],int k)
{
    int maior_altura = alturas[0];
    int acc = 1;
    for (int i = 1; i < k; i++)
    {
        if(alturas[i] > maior_altura) 
        {
            acc++;
            maior_altura = alturas[i];
        }
    }
    return acc;
}