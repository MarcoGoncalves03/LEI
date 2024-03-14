#include <stdio.h>
#include <string.h>

#define MAX_SIZE 1000

int irrepetido(char linha[], int particao);

int main(void)
{
    //Input do número de linhas
    int n_casos;
    if(scanf("%d", &n_casos) != 1)
    {
        return 1;
    }

    int particao;
    char linha[MAX_SIZE];
    int resp[n_casos];

    for (int i = 0; i < n_casos; i++)
    {
        if(scanf("%d", &particao) != 1) //Input da partição
        {
            return 1;
        } 
        if(scanf("%s", linha) != 1) //Input da linha
        {
            return 1;
        } 
        resp[i] = irrepetido(linha, particao); 
    }

    //Print da solução
    for (int i = 0; i < n_casos; i++)
    {
        printf("%d\n", resp[i]);
    }
}


//Verifica se não existem repetições
int irrepetido(char linha[], int particao)
{
    int count = 0;
    int acc = 0;
    int tamanho = strlen(linha);

    for (int k = 0; k <= tamanho - particao; k++) //Tamanho - partição para não entrar em erros de memória
    {
        for (int i = k; i < particao + k; i++)
        {
            for (int j = i + 1; j < particao + k; j++)
            {
                if (linha[i] == linha[j]) //Caso sejam iguais incrementa o count
                {
                    count++;
                }
            }
        }

        if (count != 0) //Caso o count seja diferente de 0 então a palavra tinha repetições
        {
            acc++; //Incrementamos o acc porque temos de devolver onde foi encontrada o local sem repetições
            count = 0; //Retornamos o valor a 0
        }
        else
        {
            return acc; //Caso o count seja 0 então encontramos a secção sem repetições
        }
    }
    return (-1); //Se chegarmos a este caso então não existem secções sem repetições
}

