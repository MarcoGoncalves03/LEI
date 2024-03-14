#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SIZE 1000
#define MAX_NOME 20
#define MAX_FUNCIONARIOS 40


int min_index(int faltas[], int acc);
int compara_nomes(char str[], char *token);


int main() 
{
    int n_linhas; 
    int contador = 0;
    char funcionarios[MAX_FUNCIONARIOS][MAX_NOME]; //Matriz que guarda os nomes dos funcionarios
    int faltas[MAX_FUNCIONARIOS] = {0};  //Inicializa-se com 0 para depois se incrementar

    //Input do número de linhas
    if (scanf("%d\n", &n_linhas) != 1) 
    {
        return 1;
    }
    

    //Trata a primeira linha em separado pois a nesta é impossível haver repetidos 
    char linha[MAX_SIZE];

    if (fgets(linha, MAX_SIZE, stdin) == NULL) 
    {
        return 1;
    }

    char *token = strtok(linha, " "); //Divide a linha nos espaços

    while (token != NULL && contador < MAX_FUNCIONARIOS)  //Enquanto a linha não estiver completamente dividida repete-se o processo
    {
        strcpy(funcionarios[contador], token); //Copia para a matriz o token que foi separado da string
        faltas[contador]++; //Como foi encontrado um funcionario, aumenta-se a sua variável faltas
        contador++; //Contador tem de aumentar para avançar para o próximo funcionário

        token = strtok(NULL, " ");  //Continua a partir a string
    }

    // Tratamento das linhas seguintes
    for (int i = 0; i < n_linhas - 1; i++) 
    {
        if (fgets(linha, MAX_SIZE, stdin) == NULL)  
        {
            return 1;
        }

        token = strtok(linha, " ");

        while (token != NULL && contador < MAX_FUNCIONARIOS) 
        {
            int finish = 0; //Variável que verifica se existem nomes repetidos
            for (int j = 0; j < contador; j++) 
            {
                if (compara_nomes(funcionarios[j], token) == 0) //Se existirem nomes repetidos, então temos de incrementar as suas faltas
                {
                    faltas[j]++;
                    finish = 1;
                    break;
                }
            }

            if (finish != 1) //Caso não seja repetido então temos de o guardar no array
            {
                strcpy(funcionarios[contador], token);
                faltas[contador]++;
                contador++;
            }

            token = strtok(NULL, " ");
        }
    }

    //Menor index 
    int menor_index = min_index(faltas, contador);

    //Nome menos frequente
    printf("%s\n", funcionarios[menor_index]);

    return 0;
}

//Função que verifica qual é o menor index
int min_index(int faltas[], int acc) 
{
    int index = faltas[0];
    int resp = 0;

    for (int i = 1; i < acc; i++) 
    {
        if (faltas[i] < index) 
        {
            index = faltas[i];
            resp = i;
        }
    }

    return resp;
}


//Função que verifica se um dado nome está presente na frase
int compara_nomes(char str[], char *token) 
{
    int size = strlen(token) - 1;

    for (int i = 0; i < size; i++) 
    {
        if (str[i] != token[i]) 
        {
            return 1;
        }
    }
    return 0;
}

