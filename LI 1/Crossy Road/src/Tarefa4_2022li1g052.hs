{- |
Module      : Tarefa4_2022li1g052
Description : Determinar se o jogo terminou
Copyright   : Marco Soares Gonçalves <a104614@alunos.uminho.pt>
              Salvador Duarte Magalhães Barreto <a104520@alunos.uminho.pt>

Módulo para a realização da Tarefa 4 do projeto de LI1 em 2022/23.
-}
module Tarefa4_2022li1g052 where

import LI12223
import Data.List 

{- |
O objectivo desta tarefa é implementar a função 'jogoTerminou':

@
jogoTerminou (Jogo (Jogador (x,y)) (Mapa l [])) = True
jogoTerminou (Jogo (Jogador (x,y)) (Mapa l ts)) = if x < 0 || x > (l-1) || y > 6
                                                  then True
                                                  else isOver (Jogador (x,y)) (selecionaLinha y ts)
@

== Propriedades:
prop> jogoTerminou (Jogo (Jogador (x,y)) (Mapa l [])) = True

== Exemplos de utilização:

>>> jogoTerminou (Jogo (Jogador (0,1)) (Mapa 5 [(Relva,[Arvore,Nenhum,Arvore,Nenhum ,Arvore]),(Rio 2, [Nenhum,Tronco,Tronco,Nenhum ,Tronco])]))
True
>>> jogoTerminou (Jogo (Jogador (1,2)) (Mapa 4 [(Rio (-3),[Tronco,Tronco,Nenhum,Tronco]),(Relva,[Arvore,Arvore,Nenhum,Arvore]),(Rio 2,[Tronco,Tronco,Nenhum,Nenhum])]))
False
-}

jogoTerminou :: Jogo        -- ^ Recebe um jogo
                    -> Bool -- ^ Avisa se o jogo terminou
jogoTerminou (Jogo (Jogador (x,y)) (Mapa l [])) = True
jogoTerminou (Jogo (Jogador (x,y)) (Mapa l ts)) = if x < 0 || x > (l-1) || y > 6
                                                  then True
                                                  else isOver (Jogador (x,y)) (selecionaLinha y ts)

{-| 
A função 'selecionaLinha' seleciona, dado um conjunto de linhas, a linha de ordem y

@
selecionaLinha 0 ((terreno,obs):t) = (terreno,obs)
selecionaLinha y ((terreno,obs):t) = selecionaLinha (y-1) t
@

== Exemplos de utilização: 

>>> selecionaLinha 2 [(Rio 3,[Tronco,Nenhum ,Tronco]),(Estrada 2 ,[Carro,Nenhum ,Carro]),(Relva,[Arvore,Arvore,Nenhum])]
(Relva,[Arvore,Arvore,Nenhum])
-}                                                                                  

selecionaLinha :: Int -> [(Terreno,[Obstaculo])] -> (Terreno,[Obstaculo])
selecionaLinha 0 ((terreno,obs):t) = (terreno,obs)
selecionaLinha y ((terreno,obs):t) = selecionaLinha (y-1) t

{-| 
A função 'isOver' está dividida em 3 partes:

1. Caso o jogador esteja num terreno Rio, a função verifica se o jogador não está num Tronco
2. Caso o jogador esteja num terreno Relva, então a função avisa que o jogo ainda não terminou
3. Caso o jogador esteja num terreno Estrada, então a função verifica se o jogador se encontra em "debaixo" do carro 

@
isOver :: Jogador -> (Terreno,[Obstaculo]) -> Bool
isOver (Jogador (x,y)) (Rio v,obs) = elem x (elemIndices Nenhum obs)
isOver (Jogador (x,y)) (Relva,_) = False 
isOver (Jogador (x,y)) (Estrada v,obs) = elem x (elemIndices Carro obs) 
@

== Exemplos de utilização: 

>>>  isOver (Jogador (0,2)) (Estrada 1,[Carro,Carro,Nenhum])
True 
>>> isOver (Jogador  (2,3)) (Relva,[Arvore,Arvore,Nenhum])
False 
-}                     

isOver :: Jogador -> (Terreno,[Obstaculo]) -> Bool
isOver (Jogador (x,y)) (Rio v,obs) = elem x (elemIndices Nenhum obs)
isOver (Jogador (x,y)) (Relva,_) = False 
isOver (Jogador (x,y)) (Estrada v,obs) = elem x (elemIndices Carro obs) 