module Tarefa1_2022li1g052_Spec where

import LI12223
import Tarefa1_2022li1g052
import Test.HUnit

-- Os testes estão divididos por cada alínea, isto é, para cada alínea, existe um teste que dá True e os restantes testam para casos específicos em que a função tem de dar False. 

testsT1 = test  [
             "Teste 0" ~: True ~=? mapaValido (Mapa 6 [(Relva,[Arvore,Nenhum,Arvore,Arvore,Arvore,Nenhum]),(Rio 3,[Nenhum,Tronco,Tronco,Tronco,Tronco,Tronco]),(Rio (-2),[Tronco,Nenhum,Tronco,Nenhum,Nenhum,Tronco])]),
             "Teste 0.1" ~: False ~=? mapaValido (Mapa 4 []),
             "Teste 0.2" ~: False ~=? mapaValido (Mapa 4 [(Rio 3,[Tronco,Tronco,Arvore]),(Relva,[Carro,Nenhum])]),
             "Teste 1" ~: True ~=? mapaValido (Mapa 2 [(Relva,[Arvore,Nenhum]),(Rio 2,[Tronco,Nenhum]),(Estrada (-2),[Carro,Nenhum])]),
             "Teste 1.1" ~: False ~=? mapaValido (Mapa 4 [(Estrada 1,[Arvore,Nenhum,Carro,Nenhum]),(Relva,[Arvore,Nenhum,Nenhum,Arvore])]),
             "Teste 1.2" ~: False ~=? mapaValido (Mapa 3 [(Relva,[Arvore,Nenhum,Nenhum]),(Estrada (-2),[Tronco,Nenhum,Carro])]),
             "Teste 1.3" ~: False ~=? mapaValido (Mapa 2 [(Rio (-3),[Carro,Nenhum]),(Estrada (-2),[Carro,Nenhum])]),
             "Teste 2" ~: True ~=? mapaValido (Mapa 3 [(Relva,[Arvore,Nenhum,Arvore]),(Rio 2,[Nenhum,Tronco,Nenhum]),(Rio (-3),[Tronco,Tronco,Nenhum])]),
             "Teste 2.1" ~: False ~=? mapaValido (Mapa 3 [(Rio 2,[Nenhum,Tronco,Tronco]),(Rio 1,[Tronco,Nenhum,Nenhum])]),
             "Teste 3" ~: True ~=? mapaValido (Mapa 6 [(Relva,[Nenhum,Nenhum,Arvore,Nenhum,Arvore,Arvore]),(Rio 3,[Tronco,Tronco,Nenhum,Tronco,Nenhum,Tronco])]),
             "Teste 3.1" ~: False ~=? mapaValido (Mapa 7 [(Rio 3,[Tronco,Tronco,Tronco,Tronco,Tronco,Nenhum,Tronco]),(Estrada 2,[Carro,Carro,Nenhum,Nenhum,Carro,Nenhum,Carro])]),
             "Teste 3.2" ~: False ~=? mapaValido (Mapa 7 [(Relva,[Nenhum,Nenhum,Arvore,Nenhum,Arvore,Arvore,Nenhum]),(Rio 1,[Tronco,Tronco,Tronco,Tronco,Tronco,Tronco,Tronco])]),
             "Teste 4" ~: True ~=? mapaValido (Mapa 4 [(Rio 2,[Tronco,Nenhum,Nenhum,Tronco]),(Estrada 2,[Carro,Carro,Nenhum,Nenhum])]),
             "Teste 4.1" ~: False ~=? mapaValido (Mapa 4 [(Estrada 1,[Carro,Carro,Carro,Carro]),(Relva,[Arvore,Nenhum,Nenhum,Arvore])]),
             "Teste 4.2" ~: False ~=? mapaValido (Mapa 5 [(Relva,[Arvore,Nenhum,Nenhum,Arvore,Arvore]),(Estrada 1,[Carro,Carro,Carro,Nenhum,Carro])]),
             "Teste 5" ~: True ~=? mapaValido (Mapa 3 [(Estrada 3,[Nenhum,Carro,Carro]),(Relva,[Arvore,Nenhum,Nenhum]),(Rio 2,[Tronco,Nenhum,Tronco])]),
             "Teste 5.1" ~: False ~=? mapaValido (Mapa 3 [(Relva,[Arvore,Arvore,Arvore])]),
             "Teste 6" ~: True ~=? mapaValido (Mapa 2 [(Rio 1,[Tronco,Nenhum]),(Relva,[Arvore,Nenhum]),(Estrada 1,[Carro,Nenhum])]),
             "Teste 6.1" ~: False ~=? mapaValido (Mapa 3 [(Estrada 2,[Carro,Carro,Nenhum,Carro]),(Relva,[Nenhum,Arvore,Arvore])]),
             "Teste 7" ~: True ~=? mapaValido (Mapa 4 [(Relva,[Arvore,Nenhum,Nenhum,Arvore]),(Relva,[Nenhum,Arvore,Arvore,Arvore]),(Rio 5,[Tronco,Tronco,Nenhum,Nenhum]),(Estrada 2,[Nenhum,Carro,Nenhum,Nenhum])]),
             "Teste 7.1" ~: False ~=? mapaValido (Mapa 2 [(Relva,[Arvore,Nenhum]),(Relva,[Arvore,Nenhum]),(Relva,[Nenhum,Nenhum]),(Relva,[Nenhum,Arvore]),(Relva,[Nenhum,Arvore]),(Relva,[Arvore,Nenhum])]),
             "Teste 7.2" ~: False ~=? mapaValido (Mapa 2 [(Estrada 1,[Carro,Nenhum]),(Estrada 5,[Nenhum,Nenhum]),(Estrada (-2),[Nenhum,Nenhum]),(Estrada 1,[Nenhum,Carro]),(Estrada (-7),[Carro,Nenhum]),(Estrada 1,[Carro,Nenhum])]),
             "Teste 7.3" ~: False ~=? mapaValido (Mapa 2 [(Relva,[Arvore,Nenhum]),(Rio 2,[Tronco,Nenhum]),(Rio (-2),[Nenhum,Nenhum]),(Rio 1,[Tronco,Nenhum]),(Rio (-1),[Nenhum,Tronco]),(Rio 3,[Tronco,Nenhum])])
                ]