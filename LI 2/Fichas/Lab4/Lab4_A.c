#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAX_SIZE 1000

int isVogal(char v)   // função que verifica se um caracter é uma vogal 
{
    if (v == 'A' || v == 'E' || v == 'I' || v == 'O' || v == 'U' || v == 'Y') 
    {
        return 1;
    }
    else 
    {
        return 0;
    }
}

int isConsoant(char c)    // função que verifica se um caracter é uma consoante 
{
    return isalpha(c) && !strchr("AEIOUY", c);
    // a função isalpha retorna 1 se c é uma letra do alfabeto, e 0 caso contrário
    // a função strchr procura a primeira aparição do caracter na string "AEIOUY" e retorna um pointer para essa ocorrencia ou NULL se não encontrar
    // o operador ! nega o resultado da busca, retornando 1 se c não for uma vogal 
}

int isAlternado(char *str) 
{
    int tamanho = strlen(str);     // calcula o tamanho da substring

    for (int i = 0; i < tamanho - 1; i++)    // tamanho - 1 pois comparamos a posição 1 com i+1, ou seja, evitar ultrapassar o tamanho
    {
        if ((isVogal(str[i]) && isVogal(str[i+1])) || (isConsoant(str[i]) && isConsoant(str[i+1]))) 
        {
            return 0;    // se encontrar duas vogais seguidas ou duas consoantes seguidas, da return 0
        }
    }

    return 1;    // caso não encontre, quer dizer que a substring é formada alternadamente por vogais e consoantes
}

 
int main() 
{
    int linhas;

    if (scanf("%d", &linhas) != 1) 
    {
        return 1;
    }

    getchar(); // consume o caractere de nova linha pendente (\n)

    int resultado[linhas];    // array que vai armazenar os resultados

    for (int i = 0; i < linhas; i++) 
    {
        char frase[MAX_SIZE];   // array de chars onde vai estar a string
        if (fgets(frase, sizeof(frase), stdin) == NULL)   // le a string do teclado 
        {
            return 1;
        }   

        int res = 0;
        char *token = strtok(frase, " ");    // parte a string lida em substrings toda a vez que aparece um espaço

        while (token != NULL) 
        {
            if (isAlternado(token) == 1)
            {
                res++;
            }
            token = strtok(NULL, " ");     // depois de trabalhada o primeiro token, continua de onde parou
        }

        resultado[i] = res;
    }

    for (int k = 0; k < linhas; k++) 
    {
        printf("%d\n", resultado[k]);
    }
    
    return 0;
}