#include <stdio.h>
#include <string.h>

#define max_size 1000

void crypt(int tamanho,int posicoes[],char frase[],int tamanho_string);

int main(void)
{
    //Input da ordem
   int max_posicao;
   if(scanf("%d", &max_posicao) != 1 || max_posicao > 99999999)
   {
      return 1;
   }  
    
    //Conta o tamanho da ordem
    int tamanho = 0;
    for(int i = max_posicao; i > 0; i/=10)
    {
        tamanho++;
    }

    //Guarda as posições no array
    int posicoes[tamanho];
    int div;
    for (int i = 0; i < tamanho; i++)
    {
        div = (max_posicao % 10);
        posicoes[tamanho - 1 - i] = div;
        max_posicao /= 10;
    }

   //Posições não podem ser repetidas
   int t = 1; //Para não se compararem indices iguais
   for (int i = 0; i < tamanho; i++)
   {
    for(int j = t; j < tamanho; j++)
    {
        if(posicoes[i] == posicoes[j])
        {
            return 1;
        }
    }
    t++;
   }

//Input da string
char frase[max_size];
if(scanf("%s",frase) != 1)
{
    return 1;
}

//Tamanho da frase
int tamanho_frase = strlen(frase);

//Print da solução
crypt(tamanho,posicoes,frase,tamanho_frase);
}

//Encripta e dá print da mensagem
void crypt(int tamanho, int posicoes[], char frase[],int tamanho_frase) {
    
    int num_blocos = tamanho_frase / tamanho; //Quantas casas tem de se mover para a frente
    int indice = 0;

    for (int i = 0; i < tamanho; i++) //Dá print de todas as palavras diferentes
    {
        for (int j = 0; j <= num_blocos; j++) //Dá print de uma palavra
        {
            indice = (j * tamanho) + (posicoes[i] - 1); // (j*tamanho) dá me quantas casas tenho de avançar e retiro 1 ás posições pois temos de contar a casa 0 do array
            if(indice < tamanho_frase)
            {
              printf("%c", frase[indice]);
            }
        }
    }
    printf("\n");
}