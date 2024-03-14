module Tarefa3_2022li1g052_Spec where

import LI12223
import Tarefa3_2022li1g052
import Test.HUnit

testsT3 = test  [
             "Teste 0" ~: (Jogo (Jogador (0,0)) (Mapa 4 [(Relva,[Nenhum,Nenhum,Arvore,Arvore]),(Rio 1,[Nenhum,Tronco,Nenhum,Tronco])])) ~=? animaJogo (Jogo (Jogador (0,0)) (Mapa 4 [(Relva,[Nenhum,Nenhum,Arvore,Arvore]),(Rio 1,[Tronco,Nenhum,Tronco,Nenhum])])) Parado,
             "Teste 0.1" ~: (Jogo (Jogador (0,1)) (Mapa 4 [(Relva,[Nenhum,Nenhum,Arvore,Arvore]),(Estrada 1,[Nenhum,Nenhum,Carro,Carro])])) ~=? animaJogo (Jogo (Jogador (0,0)) (Mapa 4 [(Relva,[Nenhum,Nenhum,Arvore,Arvore]),(Estrada 1,[Nenhum,Carro,Carro,Nenhum])])) (Move Baixo),
             "Teste 0.2" ~: (Jogo (Jogador (2,1)) (Mapa 4 [(Estrada 3,[Nenhum,Carro,Carro,Nenhum]),(Rio 1,[Nenhum,Tronco,Tronco,Tronco])])) ~=? animaJogo (Jogo (Jogador (0,1)) (Mapa 4 [(Estrada 3,[Nenhum,Nenhum,Carro,Carro]),(Rio 1,[Tronco,Tronco,Tronco,Nenhum])])) (Move Direita),
             "Teste 1" ~: [(Relva,[Arvore,Nenhum,Nenhum,Arvore]),(Rio 2,[Tronco,Nenhum,Nenhum,Tronco])] ~=? moveObstaculo [(Relva,[Arvore,Nenhum,Nenhum,Arvore]),(Rio 2,[Nenhum,Tronco,Tronco,Nenhum])],
             "Teste 1.1" ~: [(Rio 2,[Tronco,Nenhum,Tronco,Tronco]),(Rio (-1),[Nenhum,Tronco,Tronco,Nenhum])] ~=? moveObstaculo [(Rio 2,[Tronco,Tronco,Tronco,Nenhum]),(Rio (-1),[Nenhum,Nenhum,Tronco,Tronco])],
             "Teste 1.2" ~: [(Estrada (-2),[Nenhum,Carro,Carro,Carro,Nenhum]),(Relva,[Nenhum,Arvore,Arvore,Nenhum,Nenhum])] ~=? moveObstaculo [(Estrada (-2),[Carro,Nenhum,Nenhum,Carro,Carro]),(Relva,[Nenhum,Arvore,Arvore,Nenhum,Nenhum])],
             "Teste 2" ~: (Jogador (0,0)) ~=? moveJogador 4 (Jogador (0,0)) Parado,
             "Teste 2.1" ~: (Jogador (1,3)) ~=? moveJogador 3 (Jogador (1,2)) (Move Baixo),
             "Teste 2.2" ~: (Jogador (1,0)) ~=? moveJogador 3 (Jogador (0,0)) (Move Direita),
             "Teste 2.3" ~: (Jogador (0,3)) ~=? moveJogador 5 (Jogador (0,3)) (Move Esquerda),
             "Teste 2.4" ~: (Jogador (5,2)) ~=? moveJogador 5 (Jogador (5,2)) (Move Direita),
             "Teste 3" ~: (Jogador (3,2)) ~=? isOnTronco (Jogador (1,2)) (Rio 2,[Nenhum,Tronco,Tronco,Nenhum]),
             "Teste 3.1" ~: (Jogador (1,1)) ~=? isOnTronco (Jogador (1,1)) (Relva,[Arvore,Nenhum,Nenhum]),
             "Teste 3.2" ~: (Jogador (0,0)) ~=? isOnTronco (Jogador (0,0)) (Estrada 2,[Nenhum,Carro,Carro])
                 ]