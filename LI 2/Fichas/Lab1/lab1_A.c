#include <stdio.h>

int main(void)
{
    int n1,n2,n3,n4,n5;
    int biscoitos = 0;
    int contagem = 0;

    if(scanf("%d", &n1) != 1)
    {
        return 1;
    }
    if(scanf("%d", &n2) != 1)
    {
        return 1;
    }
    if(scanf("%d", &n3) != 1)
    {
        return 1;
    }
    if(scanf("%d", &n4) != 1)
    {
        return 1;
    }
    if(scanf("%d", &n5) != 1)
    {
        return 1;
    }


    if(n1 > biscoitos)
    {
        biscoitos = n1;
        contagem = 1;
    }
    if(n2 > biscoitos)
    {
        biscoitos = n2;
        contagem = 2;
    }
    if(n3 > biscoitos)
    {
        biscoitos = n3;
        contagem = 3;
    }
    if(n4 > biscoitos)
    {
        biscoitos = n4;
        contagem = 4;
    }
    if(n5 > biscoitos)
    {
        biscoitos = n5;
        contagem = 5;
    }
    printf("%d\n", contagem);
    
    return 0;
}