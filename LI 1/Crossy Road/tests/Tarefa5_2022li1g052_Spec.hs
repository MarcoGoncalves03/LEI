module Tarefa5_2022li1g052_Spec where

import LI12223
import Tarefa5_2022li1g052
import Test.HUnit

testsT5 = test [
            "Teste 0" ~: Jogo (Jogador (1,3)) (Mapa 3 [(Estrada (-2),[Nenhum,Nenhum,Carro]),(Relva,[Arvore,Nenhum,Arvore]),(Rio 3,[Tronco,Tronco,Nenhum])]) ~=? deslizaJogo 25 (Jogo (Jogador (1,2)) (Mapa 3 [(Relva,[Arvore,Nenhum,Arvore]),(Rio 3,[Tronco,Tronco,Nenhum]),(Estrada 3,[Carro,Carro,Nenhum])])),
            "Teste 1" ~: Jogo (Jogador (0,1)) (Mapa 4 [(Rio 2,[Nenhum,Tronco,Nenhum,Tronco]),(Relva,[Nenhum,Nenhum,Arvore,Arvore])]) ~=? deslizaJogo 66 (Jogo (Jogador (0,0)) (Mapa 4 [(Relva,[Nenhum,Nenhum,Arvore,Arvore]),(Estrada 1,[Nenhum,Carro,Carro,Nenhum])])),
            "Teste 2" ~: Jogo (Jogador (0,1)) (Mapa 4 [(Rio 1,[Tronco,Nenhum,Nenhum,Tronco]),(Relva,[Nenhum,Nenhum,Arvore,Arvore])]) ~=? deslizaJogo 40 (Jogo (Jogador (0,0)) (Mapa 4 [(Relva,[Nenhum,Nenhum,Arvore,Arvore]),(Rio 1,[Tronco,Nenhum,Tronco,Nenhum])])),
            "Teste 3" ~: Jogo (Jogador (0,2)) (Mapa 4 [(Estrada 1,[Nenhum,Nenhum,Nenhum,Carro]),(Estrada 3,[Nenhum,Nenhum,Carro,Carro])]) ~=? deslizaJogo 99  (Jogo (Jogador (0,1)) (Mapa 4 [(Estrada 3,[Nenhum,Nenhum,Carro,Carro]),(Rio 1,[Tronco,Tronco,Tronco,Nenhum])])),
            "Teste 4" ~: Jogo (Jogador (3,1)) (Mapa 5 [(Rio 2,[Tronco,Tronco,Nenhum,Nenhum,Tronco]),(Estrada 2,[Carro,Nenhum,Nenhum,Carro,Carro])]) ~=? deslizaJogo 1 (Jogo (Jogador (3,0)) (Mapa 5 [(Estrada 2,[Carro,Nenhum,Nenhum,Carro,Carro]),(Rio 2,[Tronco,Tronco,Tronco,Nenhum,Nenhum])]))
               ]

