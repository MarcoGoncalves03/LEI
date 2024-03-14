#include <stdio.h>

int main(void)
{
    //Input das linhas
    int num_linhas, posi_inicial = 5;
    if(scanf("%d", &num_linhas) != 1)
    {
        return 1;
    }

    //Array com as direções
    char direcao[20];
    int r[num_linhas];


    for(int i = 0; i < num_linhas; i++)
    {
        r[i] = posi_inicial; //Guarda a posição anterior 
        if(scanf("%s",direcao) != 1)
        {
            return 1;
        }

        for(int j = 0; direcao[j] != '\0'; j++) //Verifica se a string chegou ao final
        {
            if (direcao[j] == 'C')
            {
                if(r[i] < 7) //Assegura-se que não sai do teclado numérico
                {
                  r[i] += 3;
                }
            }
            else if (direcao[j] == 'B')
            {
                if(r[i] > 3)  //Assegura-se que não sai do teclado numérico
                {
                  r[i] -= 3;
                }
            }
            else if (direcao[j] == 'E')
            {
                if(r[i] != 4 && r[i] != 1 && r[i]!= 7)  //Assegura-se que não sai do teclado numérico
                {
                    r[i]--;
                }
            }
            else if (direcao[j] == 'D')
            {
                if(r[i] % 3 != 0)  //Assegura-se que não sai do teclado numérico
                {
                    r[i]++;
                }  
            }
            else 
            {
                return 1; //Caso não cumpra as condições acima fecha
            }
            posi_inicial = r[i]; //Atualiza a posição inicial
        }
    }

    //Print da solução
    for(int i = 0; i < num_linhas; i++)
    {
        printf("%d", r[i]);
    }

    printf("\n");

    return 0;
}
