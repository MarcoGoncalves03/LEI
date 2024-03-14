module Tarefa5_2022li1g052 where

import LI12223
import Tarefa2_2022li1g052

{-|
A função 'deslizaJogo' está encarregue de mover o mapa verticalmente:

@
deslizaJogo :: Int -> Jogo -> Jogo
deslizaJogo seed (Jogo (Jogador (x,y)) (Mapa l ((ter,obs):t))) = (Jogo (Jogador (x,y+1)) newMap)
    where m = (Mapa l ((ter,obs):t))
          (Mapa l2 (newLine:ts)) = estendeMapa m seed
          newMap = (Mapa l2 (newLine:(init ts)))
@

==Exemplo de Utilização:
>>> deslizaJogo 25 (Jogo (Jogador (1,2)) (Mapa 3 [(Relva,[Arvore,Nenhum,Arvore]),(Rio 3,[Tronco,Tronco,Nenhum]),(Estrada 3,[Carro,Carro,Nenhum])]))
Jogo (Jogador (1,3)) (Mapa 3 [(Estrada (-2),[Nenhum,Nenhum,Carro]),(Relva,[Arvore,Nenhum,Arvore]),(Rio 3,[Tronco,Tronco,Nenhum])])
-}

deslizaJogo :: Int -> Jogo -> Jogo
deslizaJogo seed (Jogo (Jogador (x,y)) (Mapa l ((ter,obs):t))) = (Jogo (Jogador (x,y+1)) newMap)
    where m = (Mapa l ((ter,obs):t))
          (Mapa l2 (newLine:ts)) = estendeMapa m seed
          newMap = (Mapa l2 (newLine:(init ts)))



