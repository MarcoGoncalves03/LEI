#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct
{
    int num_pedido;
    char dificuldade;
    int preco;
} menu;

void ordena_pedidos(menu pedidos[], int n_pedidos);

int main(void)
{
    int n_pedidos;
    if(scanf("%d", &n_pedidos) != 1)
    {
        return 1;
    } 

    menu pedidos[n_pedidos];

    for(int i = 0; i < n_pedidos; i++)
    {
        if(scanf("%d %c %d", &pedidos[i].num_pedido, &pedidos[i].dificuldade, &pedidos[i].preco) != 3)
        {
            return 1;
        }
    }

    ordena_pedidos(pedidos,n_pedidos);

    for(int i = 0; i < n_pedidos; i++)
    {
        printf("%d %c %d\n",pedidos[i].num_pedido, pedidos[i].dificuldade, pedidos[i].preco);
    }

    return 0;
}


void ordena_pedidos(menu pedidos[], int n_pedidos)
{
    menu temporario;
    int aux = n_pedidos;

    while (aux > 1)
    {
        for(int j = 0; j < aux - 1; j++)
        {
            if(pedidos[j].preco < pedidos[j+1].preco)
            {
                temporario = pedidos[j];
                pedidos[j] = pedidos[j+1];
                pedidos[j+1] = temporario;
            }
            else if(pedidos[j].preco == pedidos[j+1].preco)
            {
                if(pedidos[j].dificuldade > pedidos[j+1].dificuldade)
                {
                    temporario = pedidos[j];
                    pedidos[j] = pedidos[j+1];
                    pedidos[j+1] = temporario;
                }
                else if(pedidos[j].dificuldade == pedidos[j+1].dificuldade)
                {
                    if(pedidos[j].num_pedido > pedidos[j+1].num_pedido)
                    {
                        temporario = pedidos[j];
                        pedidos[j] = pedidos[j+1];
                        pedidos[j+1] = temporario;
                    }
                }
            }
        }
        aux--;
    }
    
}