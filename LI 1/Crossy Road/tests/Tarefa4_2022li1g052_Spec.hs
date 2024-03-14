module Tarefa4_2022li1g052_Spec where

import LI12223
import Tarefa4_2022li1g052
import Test.HUnit

testsT4 = test [
         "Teste 0" ~: False ~=? jogoTerminou (Jogo (Jogador (1,2)) (Mapa 4 [(Rio (-3),[Tronco,Tronco,Nenhum,Tronco]),(Relva,[Arvore,Arvore,Nenhum,Arvore]),(Rio 2,[Tronco,Tronco,Nenhum,Nenhum])])),
         "Teste 0.1" ~: True ~=? jogoTerminou (Jogo (Jogador (0,1)) (Mapa 5 [(Relva,[Arvore,Nenhum,Arvore,Nenhum ,Arvore]),(Rio 2, [Nenhum,Tronco,Tronco,Nenhum ,Tronco])])),
         "Teste 0.2" ~: True ~=? jogoTerminou (Jogo (Jogador (3,0)) (Mapa 5 [(Estrada 2,[Carro,Nenhum,Nenhum,Carro,Carro]),(Rio 2,[Tronco,Tronco,Tronco,Nenhum,Nenhum])])),
         "Teste 0.3" ~: False ~=? jogoTerminou (Jogo (Jogador (2,0)) (Mapa 3 [(Relva,[Arvore,Arvore ,Nenhum])])),
         "Teste 1" ~: (Relva,[Arvore,Arvore,Nenhum]) ~=? selecionaLinha 2 [(Rio 3,[Tronco,Nenhum ,Tronco]),(Estrada 2 ,[Carro,Nenhum ,Carro]),(Relva,[Arvore,Arvore,Nenhum])],            
         "Teste 2" ~: True ~=? isOver (Jogador (1,3)) (Rio 3,[Tronco,Nenhum,Nenhum]),
         "Teste 2.1" ~: True ~=? isOver (Jogador (0,2)) (Estrada 1,[Carro,Carro,Nenhum]),
         "Teste 2.2" ~: False ~=? isOver (Jogador  (2,3)) (Relva,[Arvore,Arvore,Nenhum])
                ]
