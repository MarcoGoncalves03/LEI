#include <stdio.h>
#include <string.h>

char repete(char linha[]);

int main(void)
{
    int n_linhas;

    //Input do utilizador 
    if (scanf("%d", &n_linhas) != 1)
    {
        return 1;
    }

    char linhas[1000];
    char repetidas[n_linhas];

    //n linhas
    for (int i = 0; i < n_linhas; i++)
    {
        if(scanf("%s", linhas) != 1)
        {
            return 1;
        }
        repetidas[i] = repete(linhas); //guarda a letra que se repete
    }

    //Print da solução
    for (int i = 0; i < n_linhas; i++)
    {
        printf("%c", repetidas[i]);
    }
    printf("\n");

    return 0;
}

//Verifica qual é a letra que se repete
char repete(char linha[])
{
    for (int i = 0; linha[i] != '\0'; i++)
    {
        for (int j = i + 1; linha[j] != '\0'; j++) // i + 1 para não repetir posições
        {
            if (linha[i] == linha[j]) 
            {
                return linha[i];
            }
        }
    }
    return 1;
}
