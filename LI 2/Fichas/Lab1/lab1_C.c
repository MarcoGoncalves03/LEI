#include <stdio.h>

int main(void)
{
    int n1,n2,n3;
    int p1,p2,p3;

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


if(n1 > n2)    
    {        
        p1 = n2;        
        p2 = n1;    
    }    
    else     
    {        
        p1 = n1;        
        p2 = n2;    
    }    
    if(p1 > n3)    
    {        
        p3 = p1;        
        p1 = n3;    
    }    
    else    
    {        
        p3 = n3;    
    }     
    if(p2 >= p3)
    {
        int l = p3;
        p3 = p2;
        p2 = l;
    }
    printf("%d %d %d\n", p1, p2, p3);     
    return 0; 
}