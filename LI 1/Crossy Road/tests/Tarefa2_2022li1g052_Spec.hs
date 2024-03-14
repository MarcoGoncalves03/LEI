module Tarefa2_2022li1g052_Spec where

import LI12223
import Tarefa2_2022li1g052
import Test.HUnit

testsT2 = test [
          "Teste 0" ~: Mapa 3 [(Estrada 1,[Nenhum,Nenhum,Carro]),(Rio 3,[Tronco,Nenhum,Tronco]),(Relva,[Arvore,Arvore,Nenhum])] ~=? estendeMapa (Mapa 3 [(Rio 3,[Tronco,Nenhum,Tronco]),(Relva,[Arvore,Arvore,Nenhum])]) 26 ,
          "Teste 0.1" ~: Mapa 3 [(Estrada (-1),[Nenhum,Nenhum,Carro]),(Rio 3,[Tronco,Nenhum,Tronco]),(Rio (-7),[Tronco,Tronco,Nenhum]),(Rio 2,[Nenhum,Nenhum,Tronco]),(Rio (-3),[Nenhum,Tronco,Nenhum]),(Relva,[Arvore,Arvore,Nenhum])] ~=? estendeMapa (Mapa 3 [(Rio 3,[Tronco,Nenhum,Tronco]),(Rio (-7),[Tronco,Tronco,Nenhum]),(Rio 2,[Nenhum,Nenhum,Tronco]),(Rio (-3),[Nenhum,Tronco,Nenhum]),(Relva,[Arvore,Arvore,Nenhum])]) 79,
          "Teste 0.2" ~: Mapa 3 [(Rio 1,[Nenhum,Nenhum,Tronco]),(Relva,[Arvore,Arvore,Nenhum]),(Relva,[Arvore,Arvore,Nenhum]),(Relva,[Nenhum,Arvore,Nenhum]),(Relva,[Arvore,Nenhum,Arvore]),(Relva,[Nenhum,Nenhum,Arvore])] ~=? estendeMapa (Mapa 3 [(Relva,[Arvore,Arvore,Nenhum]),(Relva,[Arvore,Arvore,Nenhum]),(Relva,[Nenhum,Arvore,Nenhum]),(Relva,[Arvore,Nenhum,Arvore]),(Relva,[Nenhum,Nenhum,Arvore])]) 54,
          "Teste 0.3" ~: Mapa 3 [(Relva,[Arvore,Nenhum,Arvore]),(Estrada 2,[Carro,Nenhum,Carro]),(Estrada (-3),[Carro,Carro,Nenhum]),(Estrada 4,[Nenhum,Carro,Carro]),(Estrada 7,[Carro,Carro,Nenhum]),(Estrada (-3),[Nenhum,Nenhum,Carro])] ~=?  estendeMapa (Mapa 3 [(Estrada 2,[Carro,Nenhum,Carro]),(Estrada (-3),[Carro,Carro,Nenhum]),(Estrada 4,[Nenhum,Carro,Carro]),(Estrada 7,[Carro,Carro,Nenhum]),(Estrada (-3),[Nenhum,Nenhum,Carro])]) 37,
          "Teste 0.4" ~: Mapa 6 [(Rio (-1),[Tronco,Nenhum,Nenhum,Tronco,Nenhum,Tronco]),(Rio 3,[Tronco,Nenhum,Tronco,Tronco,Nenhum,Tronco]),(Relva,[Arvore,Arvore,Nenhum,Arvore,Nenhum,Nenhum]),(Estrada (-3),[Carro,Carro,Nenhum,Nenhum,Nenhum,Carro])] ~=?  estendeMapa (Mapa 6 [(Rio 3,[Tronco,Nenhum,Tronco,Tronco,Nenhum,Tronco]),(Relva,[Arvore,Arvore,Nenhum,Arvore,Nenhum,Nenhum]),(Estrada (-3),[Carro,Carro,Nenhum,Nenhum,Nenhum,Carro])]) 45,
          "Teste 1 "  ~: [Estrada 0,Relva] ~=? proximosTerrenosValidos (Mapa 4 [(Rio 3,[Tronco,Tronco,Nenhum,Nenhum]),(Rio (-3),[Nenhum,Tronco,Nenhum,Tronco]),(Rio 5, [Tronco,Tronco,Tronco,Nenhum]),(Rio (-1),[Tronco,Nenhum,Nenhum,Nenhum])]),
          "Teste 1.1" ~: [Rio 0,Estrada 0] ~=? proximosTerrenosValidos (Mapa 3 [(Relva,[Arvore,Arvore,Nenhum,Nenhum]),(Relva,[Nenhum,Nenhum,Arvore,Arvore]),(Relva,[Arvore,Nenhum,Arvore,Nenhum]),(Relva,[Nenhum,Arvore,Nenhum,Nenhum]),(Relva,[Nenhum,Arvore,Arvore,Arvore])]),
          "Teste 1.2" ~: [Rio 0,Relva] ~=? proximosTerrenosValidos (Mapa 3 [(Estrada (-2),[Nenhum,Carro,Nenhum,Carro]),(Estrada 3,[Carro,Carro,Carro,Nenhum]),(Estrada (-1),[Nenhum,Carro,Carro,Nenhum ]),(Estrada 2,[Nenhum,Carro,Carro,Nenhum]),(Estrada 5,[Carro,Carro,Nenhum,Carro])]),
          "Teste 1.3" ~: [Rio 0,Estrada 0,Relva] ~=?  proximosTerrenosValidos (Mapa 5 [(Rio 4,[Tronco,Tronco,Nenhum,Tronco,Nenhum]),(Estrada (-5),[Carro,Carro,Nenhum,Nenhum,Carro]),(Relva,[Arvore,Arvore,Nenhum,Arvore,Nenhum])]),
          "Teste 2" ~: [Nenhum] ~=? proximosObstaculosValidos 7 (Rio 3,[Tronco,Nenhum,Tronco,Tronco,Tronco,Tronco]),
          "Teste 2.1" ~: [Nenhum] ~=? proximosObstaculosValidos 7 (Estrada 2,[Carro,Carro,Nenhum ,Nenhum ,Nenhum ,Carro]), 
          "Teste 2.2" ~: [Arvore,Nenhum] ~=? proximosObstaculosValidos 7 (Relva,[Arvore,Arvore,Arvore]),
          "Teste 2.3" ~: [Nenhum] ~=? proximosObstaculosValidos 5 (Relva,[Arvore,Arvore,Arvore,Arvore]),
          "Teste 2.4" ~: [] ~=? proximosObstaculosValidos 5 (Estrada 3,[Carro,Nenhum,Carro,Nenhum,Nenhum])
          ]  
    
