#include <stdio.h>

void tarou(int x, int y,int num_cartas,int cartas_usadas[]);

int main(void)
{
    int num_cartas;
    int x = 0, y = 0;
   
    if (scanf("%d", &num_cartas) != 1)
    {
        return 1;
    }
       
    int cartas_usadas[num_cartas];

    for(int i = 0; i < num_cartas; i++)
    {
        if(scanf("%d", &cartas_usadas[i]) != 1 || cartas_usadas[i] < 1 || cartas_usadas[i] > 78)
        {
            return 1;
        }
    }
    
    tarou(x,y,num_cartas,cartas_usadas);
    
    return 0;
}


void tarou(int x, int y,int num_cartas,int cartas_usadas[])
{
    for (int i = 0; i < num_cartas; i++)
    {
        while(cartas_usadas[i] > 4) 
        {
            cartas_usadas[i] -= 4;
        }
        if(cartas_usadas[i] == 4)
        {
            x++;
        }
        if(cartas_usadas[i] == 2)
        {
            y++;
        }
        if(cartas_usadas[i] == 3)
        {
            x--;
        }
        if(cartas_usadas[i] == 1)
        {
            y--;
        }
    }
    printf("%d %d\n",x, y); 
}
