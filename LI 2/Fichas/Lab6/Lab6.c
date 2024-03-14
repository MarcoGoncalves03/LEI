#include <stdio.h>
#include <string.h>

void removeChar(char nome[],char ch);
int verifica_anagrama(char anagramas[],char nome[]);
int main(void)
{
    int n_casos;
    int indice[100] = {0}; //Array que guarda os meu indices
    int resultados[100][100] = {0}; //Array que guarda os meu resultados
    
    
    //Input do numero de casos
    if(scanf("%d", &n_casos) != 1)
    {
        return 1;
    }

    int candidatos;
    char nome[100];
    for(int repeticoes = 0; repeticoes < n_casos; repeticoes++)
    {
        if(scanf("%d\n", &candidatos) != 1) //Input do numero de candidatos
        {
            return 1;
        }

        if(fgets(nome,sizeof(nome),stdin) == NULL) //Input do nome original
        {
            return 1;
        }

        strcpy(nome,strtok(nome, "\n"));

        char anagramas[candidatos][100]; //Array que guarda os meus candidatos a anagrama
        
        for(int j = 0; j < candidatos; j++)
        {
            if(fgets(anagramas[j],sizeof(anagramas[j]),stdin) == NULL) //Input dos candidatos
            {
                return 1;
            }

            strcpy(anagramas[j],strtok(anagramas[j], "\n")); //Retira o \n que o fgets coloca automaticamente

            int finish = verifica_anagrama(anagramas[j],nome);
            
            if(finish == 1) 
            {
                resultados[repeticoes][indice[repeticoes]] = j + 1;  //Caso seja anagrama guardamos no array de resultados a linha onde foi encontrado
                indice[repeticoes]++; //E temos de aumentar o indice
            }
        }

        if(repeticoes == n_casos-1) //Caso estejamos na última iteração então podemos dar print
        {
            for(int i2 = 0; i2 < n_casos;i2++)
            {
                if(indice[i2] == 0) //Se o meu indice for 0 então não foi encontrado nenhum anagrama
                {
                    int r = -1;
                    printf("%d", r);
                }

             for(int l = 0; l < indice[i2]; l++)
                {
                    if(l == indice[i2] - 1)
                    {
                        printf("%d", resultados[i2][l]);
                    }
                    else
                    {
                    printf("%d ", resultados[i2][l]); //vai ter um espaço a mais no final
                    }
                }
            printf("\n");
            }
        }
       
    }
    return 0;
}


int verifica_anagrama(char anagramas[],char nome[])
{
    char nome_Aux[strlen(nome)];
    strcpy(nome_Aux, nome);
    removeChar(nome_Aux,' ');  //Remove os espaços de ambas as palavras
    removeChar(anagramas,' ');

    int size1 = strlen(nome_Aux);
    int guarda_size = size1;  //-1 para o \n
    int size2 = strlen(anagramas);
    int counter = 0;
    int acc = 0;

//POSSO AINDA VERIFICAR SE OS SIZES SAO DIFERENTES!
 
    for(int i = 0; i < size1; i++)
    {
        for(int j = 0; j < size2; j++)
        {
            if(anagramas[j] == nome_Aux[i])  //Se as letras forem iguais incrementa 1 ao counter
            {
                counter++;
            }
        }
        if(counter != 0)    //Se o meu counter for diferente de 0 entao à letras iguais, logo temos de as remover da string
        {
            removeChar(nome_Aux,nome_Aux[i]);
            i--;
            size1 = strlen(nome_Aux);   //O size tem de mudar pois a string mudou
        }
        acc += counter;
        counter = 0;
    } 
    
    if(acc == guarda_size)  //Se o meu counter for igual ao tamanho incial entao e anagrama e devolvemos 1 
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

void removeChar(char nome[],char ch) //Remove um dado char de uma string
{
    int size = strlen(nome);
    char aux[size+1];
    int counter = 0;
    for(int i = 0; i < size; i++)
    {
        if(nome[i] != ch)
        {
            aux[counter] = nome[i];
            counter++;
        }
    }
    aux[counter] = '\0';
    strcpy(nome,aux);
}


