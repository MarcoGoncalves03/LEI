#include <stdio.h>

void final(int num_comandos, int begin, int max_andar, int comandos[]);

int main(void)
{
    int begin,num_comandos,max_andar;
    if(scanf("%d", &begin) !=1 || scanf("%d", &max_andar) != 1 || scanf("%d", &num_comandos) != 1)
    {
        return 1;
    }

    int comandos[num_comandos];

    for(int i = 0; i < num_comandos; i++)
    {
        if((scanf("%d", &comandos[i]) != 1) || ((comandos[i] != -1) && (comandos[i] != 1)))
        {
            return 1;
        }
    }

    final(num_comandos,begin,max_andar,comandos);


   
}

void final(int num_comandos, int begin, int max_andar, int comandos[])
{
    for(int i = 0; i < num_comandos; i++)
    {
        {
            if(comandos[i] == 1)
            {
                 begin++;
            }   
            if(comandos[i] == (-1))
            {
                begin--;
            }
            if(begin > max_andar)
            {
                begin--;
            }
            if(begin < 0)
            {
                begin++;
            }
        }  
    }
    printf("%d\n", begin);
}

