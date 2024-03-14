#include <stdio.h>

int main(void)
{
    int jogadas;
    int win_cmd = 0 ,win_inzel = 0,empate = 0;
    char inzel,cmd;
    if(scanf("%d", &jogadas) != 1)
    {
        return 1;
    }

    for(int i = 0; i < jogadas; i++)
    {
        if(scanf(" %c", &inzel) != 1 || scanf(" %c", &cmd) != 1)
        {
            return 1;
        }
        if(inzel == '@')
        {
            if(cmd == '*')
            {
                empate++;
            }
            else if(cmd == '-')
            {
                win_cmd++;
            }
            else if(cmd == '+')
            {
                win_inzel++;
            }
            else
            {
                return 1;
            }
        }
        else if(inzel == '|')
        {
            if(cmd == '-')
            {
                empate++;
            }
            else if(cmd == '+')
            {
                win_cmd++;
            }
            else if(cmd == '*')
            {
                win_inzel++;
            }
            else
            {
                return 1;
            }
        }
        else if(inzel == 'X')
        {
            if(cmd == '+')
            {
                empate++;
            }
            else if(cmd == '-')
            {
                win_inzel++;
            }
            else if(cmd == '*')
            {
                win_cmd++;
            }
            else
            {
                return 1;
            }
        }
         else
            {
                return 1;
            }
    }
    printf("%d %d %d\n", win_inzel, win_cmd, empate);
}

