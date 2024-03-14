#include <stdio.h>

int main(void)
{
    int n1,n2,n3;

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

    if((n1 >= n2 && n2 >= n3) || (n1 <= n2 && n2 <= n3))
    {
        printf("OK\n");
    }
    else
    {
        printf("NAO\n");
    }
}