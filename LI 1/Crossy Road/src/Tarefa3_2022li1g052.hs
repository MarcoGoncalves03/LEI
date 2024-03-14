{- |
Module      : Tarefa3_2022li1g052
Description : Movimentação do personagem e obstáculos
Copyright   : Marco Soares Gonçalves <a104614@alunos.uminho.pt>
              Salvador Duarte Magalhães Barreto <a104520@alunos.uminho.pt>

Módulo para a realização da Tarefa 3 do projeto de LI1 em 2022/23.
-}
module Tarefa3_2022li1g052 where

import LI12223
import Data.List (elemIndices)
import Tarefa4_2022li1g052

{- | 
O objectivo desta tarefa é implementar a função 'animaJogo'.

@
animaJogo (Jogo (Jogador (x,y)) (Mapa l ts)) jg = if jogoTerminou (Jogo (isOnTronco (Jogador (nX,nY)) (loc nY ts)) (Mapa l (moveObstaculo ts)))
                                                  then (Jogo (isOnTronco (Jogador (nX,nY)) (loc nY ts)) (Mapa l ([(fst (verificaCarro (Jogador (nX,nY)) ((loc nY ts),0)))] ++ (drop 1 (moveObstaculo ts)))))
                                                  else (Jogo (isOnTronco (Jogador (nX,nY)) (loc nY ts)) (Mapa l (moveObstaculo ts)))
                                   where (Jogador (nX,nY)) = betterMoveJogador (Jogador (x,y)) (Mapa l ts) jg
@

== Exemplos de utilização:

>>> animaJogo (Jogo (Jogador (0,1)) (Mapa 4 [(Estrada 3,[Nenhum,Nenhum,Carro,Carro]),(Rio 1,[Tronco,Tronco,Tronco,Nenhum])])) (Move Direita)
(Jogo (Jogador (2,1)) (Mapa 4 [(Estrada 3,[Nenhum,Carro,Carro,Nenhum]),(Rio 1,[Nenhum,Tronco,Tronco,Tronco])]))
>>> animaJogo (Jogo (Jogador (0,0)) (Mapa 4 [(Relva,[Nenhum,Nenhum,Arvore,Arvore]),(Rio 1,[Tronco,Nenhum,Tronco,Nenhum])])) Parado
(Jogo (Jogador (0,0)) (Mapa 4 [(Relva,[Nenhum,Nenhum,Arvore,Arvore]),(Rio 1,[Nenhum,Tronco,Nenhum,Tronco])]))
-}

animaJogo :: Jogo -> Jogada -> Jogo
animaJogo (Jogo (Jogador (x,y)) (Mapa l ts)) jg = if jogoTerminou (Jogo (isOnTronco (Jogador (nX,nY)) (loc nY ts)) (Mapa l (moveObstaculo ts)))
                                                  then (Jogo (isOnTronco (Jogador (nX,nY)) (loc nY ts)) (Mapa l ([(fst (verificaCarro (Jogador (nX,nY)) ((loc nY ts),0)))] ++ (drop 1 (moveObstaculo ts)))))
                                                  else (Jogo (isOnTronco (Jogador (nX,nY)) (loc nY ts)) (Mapa l (moveObstaculo ts)))
                                   where (Jogador (nX,nY)) = betterMoveJogador (Jogador (x,y)) (Mapa l ts) jg
                         
{-|
1. A função 'moveObstaculo' é responsável por deslocar os obstáculos ao longo de um rio ou estrada, conforme a velocidade do terreno:

@
moveObstaculo ((Relva,obs):t) = (Relva,obs) : moveObstaculo t
moveObstaculo ((Rio v,obs):t) = (Rio v,(desl v obs)) : moveObstaculo t
moveObstaculo ((Estrada v,obs):t) = (Estrada v,(desl v obs)) : moveObstaculo t
@

== Propriedades:
prop> moveObstaculo [] = []

== Exemplos de utilização:

>>> moveObstaculo [(Relva,[Arvore,Nenhum,Nenhum,Arvore]),(Rio 2,[Nenhum,Tronco,Tronco,Nenhum])]
[(Relva,[Arvore,Nenhum,Nenhum,Arvore]),(Rio 2,[Tronco,Nenhum,Nenhum,Tronco])]
>>> moveObstaculo [(Rio 2,[Tronco,Tronco,Tronco,Nenhum]),(Rio (-1),[Nenhum,Nenhum,Tronco,Tronco])]
[(Rio 2,[Tronco,Nenhum,Tronco,Tronco]),(Rio (-1),[Nenhum,Tronco,Tronco,Nenhum])]
-}

moveObstaculo :: [(Terreno,[Obstaculo])] -> [(Terreno,[Obstaculo])] 
moveObstaculo [] = []
moveObstaculo ((Relva,obs):t) = (Relva,obs) : moveObstaculo t
moveObstaculo ((Rio v,obs):t) = (Rio v,(desl v obs)) : moveObstaculo t
moveObstaculo ((Estrada v,obs):t) = (Estrada v,(desl v obs)) : moveObstaculo t

{-|
Para a função anterior foi ulitizada a função auxiliar 'desl':

@
desl v obs 
    | v == 0 = obs
    | otherwise = let aux = mod v (length obs) in 
                  drop (length obs - aux) obs ++ take (length obs - aux) obs
@
-}
    
desl :: Int -> [Obstaculo] -> [Obstaculo] 
desl v obs 
    | v == 0 = obs
    | otherwise = let aux = mod v (length obs) in 
                  drop (length obs - aux) obs ++ take (length obs - aux) obs

{-|
A função 'betterMoveJogador' impede o jogador de subir árvores durante o seu movimento:

@
betterMoveJogador :: Jogador -> Mapa -> Jogada -> Jogador 
betterMoveJogador (Jogador (x,y)) (Mapa l ts) jg = if isOnArvore (Jogador (nX,nY)) (loc nY ts)
                                                   then (Jogador (x,y)) 
                                                   else (Jogador (nX,nY))
                              where (Jogador (nX,nY)) = moveJogador l (Jogador (x,y)) jg 
@

==Exemplo de utilização: 
>>> betterMoveJogador (Jogador (1,2)) (Mapa 3 [(Relva,[Arvore,Nenhum,Arvore]),(Rio 3,[Tronco,Tronco,Nenhum])]) (Move Cima)
Jogador (1,1)
-}
           
betterMoveJogador :: Jogador -> Mapa -> Jogada -> Jogador 
betterMoveJogador (Jogador (x,y)) (Mapa l ts) jg = if isOnArvore (Jogador (nX,nY)) (loc nY ts)
                                                   then (Jogador (x,y)) 
                                                   else (Jogador (nX,nY))
                              where (Jogador (nX,nY)) = moveJogador l (Jogador (x,y)) jg 


{-|
A função 'moveJogador' encarrega-se de mover o jogador consoante a jogada que foi dada e ao mesmo tempo prevenir o jogador de sair do mapa. É utilizada como uma função auxiliar na 'betterMoveJogador'

@
moveJogador _ (Jogador (x,y)) Parado = (Jogador (x,y))
moveJogador l (Jogador (x,y)) (Move dir) 
    | dir == Cima = if y-1 < 0 
                    then (Jogador (x,y)) 
                    else (Jogador (x,y-1))
    | dir == Baixo = (Jogador (x,y+1))
    | dir == Esquerda = if x-1 < 0 
                        then (Jogador (x,y)) 
                        else (Jogador (x-1,y))
    | dir == Direita = if x+1 > l 
                       then (Jogador (x,y)) 
                       else (Jogador (x+1,y))
@

== Exemplos de utilização:

>>> moveJogador 4 (Jogador (0,0)) Parado
(Jogador (0,0))
>>> moveJogador 5 (Jogador (0,3)) (Move Esquerda)
(Jogador (0,3))
>>> moveJogador 3 (Jogador (1,2)) (Move Baixo)
(Jogador (1,3))
-}

moveJogador :: Int -> Jogador -> Jogada -> Jogador
moveJogador _ (Jogador (x,y)) Parado = (Jogador (x,y))
moveJogador l (Jogador (x,y)) (Move dir) 
    | dir == Cima = if y-1 < 0 
                    then (Jogador (x,y)) 
                    else (Jogador (x,y-1))
    | dir == Baixo = (Jogador (x,y+1))
    | dir == Esquerda = if x-1 < 0 
                        then (Jogador (x,y)) 
                        else (Jogador (x-1,y))
    | dir == Direita = if x+1 >= l 
                       then (Jogador (x,y)) 
                       else (Jogador (x+1,y))

{-|
A função isOnArvore verifica se o jogador está em cima de uma Árvore:

@
isOnArvore :: Jogador -> (Terreno,[Obstaculo]) -> Bool 
isOnArvore (Jogador (x,y)) (terr,obs) = if elem x (elemIndices Arvore obs)
                                        then True
                                        else False 
@

==Exemplo de Utilização:
>>>isOnArvore  (Jogador (1,0)) (Relva,[Arvore,Nenhum,Arvore])
False

-}

isOnArvore :: Jogador -> (Terreno,[Obstaculo]) -> Bool 
isOnArvore (Jogador (x,y)) (terr,obs) = if elem x (elemIndices Arvore obs)
                                        then True
                                        else False 



{-|
A função 'isOnTronco' ocupa-se de mover o jogador juntamente com o tronco, caso este se encontre em cima do mesmo:

@
isOnTronco (Jogador (x,y)) (Rio v,obs) = if elem x (elemIndices Tronco obs) 
                                         then (Jogador (x+v,y))
                                         else (Jogador (x,y))
@

== Propriedades:
prop> isOnTronco (Jogador (x,y)) (Estrada _,_) = (Jogador (x,y))
prop> isOnTronco (Jogador (x,y)) (Relva,_) = (Jogador (x,y))

== Exemplos de utilização:

>>> isOnTronco (Jogador (1,2)) (Rio 2,[Nenhum,Tronco,Tronco,Nenhum])
(Jogador (3,2))
>>> isOnTronco (Jogador (0,0)) (Estrada 2,[Nenhum,Carro,Carro])
(Jogador (0,0))
-}

isOnTronco :: Jogador -> (Terreno,[Obstaculo]) -> Jogador
isOnTronco (Jogador (x,y)) (Estrada _,_) = (Jogador (x,y))
isOnTronco (Jogador (x,y)) (Relva,_) = (Jogador (x,y))
isOnTronco (Jogador (x,y)) (Rio v,obs) = if elem x (elemIndices Tronco obs) 
                                         then (Jogador (x+v,y))
                                         else (Jogador (x,y))

{-|
A função 'loc' é uma função auxiliar responsável por localizar qual a linha onde o jogador se encontra:

@
loc y ((terreno,obs):t) = loc (y-1) t
@

== Propriedades:
prop> loc 0 ((terreno,obs):t) = (terreno,obs)

== Exemplos de utilização:

>>> loc 1 [(Relva,[Arvore,Nenhum,Arvore]),(Estrada 2,[Nenhum,Carro,Carro]),(Rio 1,[Tronco,Nenhum,Nenhum])]
(Estrada 2,[Nenhum,Carro,Carro])
-}
                             
loc :: Int -> [(Terreno,[Obstaculo])] -> (Terreno,[Obstaculo])
loc 0 ((terreno,obs):t) = (terreno,obs)
loc y ((terreno,obs):t) = loc (y-1) t


---------------------------------- Documentar esta função e a principal -----------------


{-|
A função 'verificaCarro' está encarregue de parar o carro quando o jogador morrer na estrada:

@
verificaCarro ::  Jogador -> ((Terreno,[Obstaculo]),Int)  -> ((Terreno,[Obstaculo]),Int) 
verificaCarro (Jogador (x,y)) ((Estrada 0,(ob:obs)),n) = ((Estrada n,(ob:obs)),n)
verificaCarro (Jogador (x,y)) ((Estrada v,(ob:obs)),n) = if v > 0 
                                                         then if isOver (Jogador (x,y)) (Estrada v,(ob:obs))
                                                              then ((Estrada (v+n),(ob:obs)), n )
                                                              else verificaCarro (Jogador (x,y)) ((Estrada (v-1),(desl 1 (ob:obs))),(n+1)) 
                                                         else if isOver (Jogador (x,y)) (Estrada v,(ob:obs))
                                                              then ((Estrada (v+n),(ob:obs)), n )
                                                              else verificaCarro (Jogador (x,y)) ((Estrada (v+1),(desl 1 (ob:obs))),(n-1)) 
verificaCarro _ (terr,n) = (terr,n)
@

==Exemplo de Utilização:
>>> verificaCarro (Jogador (1,0)) ((Estrada 2,[Carro,Nenhum,Carro,Carro,Nenhum]),0)
((Estrada 2,[Nenhum,Carro,Nenhum,Carro,Carro]),1)

-}

verificaCarro ::  Jogador -> ((Terreno,[Obstaculo]),Int)  -> ((Terreno,[Obstaculo]),Int) 
verificaCarro (Jogador (x,y)) ((Estrada 0,(ob:obs)),n) = ((Estrada n,(ob:obs)),n)
verificaCarro (Jogador (x,y)) ((Estrada v,(ob:obs)),n) = if v > 0 
                                                         then if isOver (Jogador (x,y)) (Estrada v,(ob:obs))
                                                              then ((Estrada (v+n),(ob:obs)), n )
                                                              else verificaCarro (Jogador (x,y)) ((Estrada (v-1),(desl 1 (ob:obs))),(n+1)) 
                                                         else if isOver (Jogador (x,y)) (Estrada v,(ob:obs))
                                                              then ((Estrada (v+n),(ob:obs)), n )
                                                              else verificaCarro (Jogador (x,y)) ((Estrada (v+1),(desl 1 (ob:obs))),(n-1)) 
verificaCarro _ (terr,n) = (terr,n)




