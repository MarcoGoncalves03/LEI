{- |
Module      : Tarefa2_2022li1g052
Description : Geração contínua de um mapa
Copyright   : Marco Soares Gonçalves <a104614@alunos.uminho.pt>
              Salvador Duarte Magalhães Barreto <a104520@alunos.uminho.pt>

Módulo para a realização da Tarefa 2 do projeto de LI1 em 2022/23.
-}
module Tarefa2_2022li1g052 where

import LI12223
import System.Random
import Data.List 

{- | 
O objectivo desta tarefa é implementar a função 'estendeMapa':

@
estendeMapa (Mapa l ((ter,obs):t)) seed = if passagemImpossivel (ter,obs) (newTerVel,newObs) 
                                          then estendeMapa m (seed*2)
                                          else (Mapa l ((newTerVel,newObs):((ter,obs):t))) 
     where 
          m = (Mapa l ((ter,obs):t))
          newTer = (!!) (proximosTerrenosValidos m) (mod (randomNum seed) (length (proximosTerrenosValidos m)))
          newObs = proxObs seed l (newTer,[])
          newTerVel = (addVel (mapaToTerreno (Mapa l ((newTer,newObs):((ter,obs):t)))) seed l)
@

== Exemplos de utilização:

>>> estendeMapa (Mapa 3 [(Rio 3,[Tronco,Nenhum,Tronco]),(Rio (-7),[Tronco,Tronco,Nenhum]),(Rio 2,[Nenhum,Nenhum,Tronco]),(Rio (-3),[Nenhum,Tronco,Nenhum]),(Relva,[Arvore,Arvore,Nenhum])]) 79
Mapa 3 [(Estrada (-1),[Nenhum,Nenhum,Carro]),(Rio 3,[Tronco,Nenhum,Tronco]),(Rio (-7),[Tronco,Tronco,Nenhum]),(Rio 2,[Nenhum,Nenhum,Tronco]),(Rio (-3),[Nenhum,Tronco,Nenhum]),(Relva,[Arvore,Arvore,Nenhum])]>>> estendeMapa (Mapa 6 [(Rio 3,[Tronco,Nenhum,Tronco,Tronco,Nenhum,Tronco]),(Relva,[Arvore,Arvore,Nenhum,Arvore,Nenhum,Nenhum]),(Estrada (-3),[Carro,Carro,Nenhum,Nenhum,Nenhum,Carro])]) 45
-}

estendeMapa :: Mapa -> Int -> Mapa
estendeMapa (Mapa l ((ter,obs):t)) seed = if passagemImpossivel (ter,obs) (newTerVel,newObs) 
                                          then estendeMapa m (seed*2)
                                          else (Mapa l ((newTerVel,newObs):((ter,obs):t))) 
     where 
          m = (Mapa l ((ter,obs):t))
          newTer = (!!) (proximosTerrenosValidos m) (mod (randomNum seed) (length (proximosTerrenosValidos m)))
          newObs = proxObs seed l (newTer,[])
          newTerVel = (addVel (mapaToTerreno (Mapa l ((newTer,newObs):((ter,obs):t)))) seed l)

{- | 
A função 'randomNum' recebe um número inteiro e devolve um aleatório:

@
randomNum seed = head $ randoms (mkStdGen seed)
@
-}

randomNum :: Int -> Int 
randomNum seed = head $ randoms (mkStdGen seed)

{- | 
A função 'mapaToTerreno' agrupa numa lista todos os terrenos de um mapa:

@
mapaToTerreno (Mapa l ((ter,obs):ters)) = ter : mapaToTerreno (Mapa l ters)
@

== Propriedades:
prop> mapaToTerreno (Mapa _ []) = []

== Exemplos de utilização:

>>> mapaToTerreno (Mapa 3 [(Rio 3,[Tronco,Nenhum,Tronco]),(Estrada 5,[Carro,Carro,Nenhum]),(Relva,[Arvore,Arvore ,Nenhum])])
[Rio 3,Estrada 5,Relva]
-}

mapaToTerreno :: Mapa -> [Terreno]
mapaToTerreno (Mapa _ []) = []
mapaToTerreno (Mapa l ((ter,obs):ters)) = ter : mapaToTerreno (Mapa l ters)

{- | 
A função 'addVel' está encarregue de adicionar uma velociade válida à nova linha do mapa:

@
addVel (Relva:t) _ _ = Relva
addVel ((Estrada v):t) seed largura 
     | randomNum seed > 0 = Estrada ((mod (randomNum seed) 2)+1)
     | otherwise = Estrada (-((mod (randomNum seed) 2)+1))
addVel ((Rio v):(Rio v2):t) seed largura 
     | v2 > 0 = Rio (-((mod (randomNum seed) 2)+1))
     | otherwise = Rio ((mod (randomNum seed) 2)+1)
addVel ((Rio v):t) seed largura = Rio ((mod (randomNum seed) 2)+1)
@

== Exemplos de utilização:

>>> addVel [Rio 0,Estrada 8,Relva,Rio (-3),Rio 2] 6 4
Rio 1
-}

addVel :: [Terreno] -> Int -> Int -> Terreno
addVel (Relva:t) _ _ = Relva
addVel ((Estrada v):t) seed largura 
     | randomNum seed > 0 = Estrada ((mod (randomNum seed) 2)+1)
     | otherwise = Estrada (-((mod (randomNum seed) 2)+1))
addVel ((Rio v):(Rio v2):t) seed largura 
     | v2 > 0 = Rio (-((mod (randomNum seed) 2)+1))
     | otherwise = Rio ((mod (randomNum seed) 2)+1)
addVel ((Rio v):t) seed largura = Rio ((mod (randomNum seed) 2)+1)

{- | 
A função 'proxObs' preenche uma lista com obstáculos válidos:

@
proxObs seed l (ter,obs) 
     | l == length obs = obs
     | otherwise = proxObs seed l (ter,((!!) (proximosObstaculosValidos l (ter,obs)) (mod (randomNum newSeed) (length (proximosObstaculosValidos l (ter,obs))))):obs)
          where newSeed = seed * (length obs) 
@

== Exemplos de utilização:

>>> proxObs 10 5 (Rio 3, [Tronco,Tronco,Nenhum])
[Tronco,Tronco,Tronco,Tronco,Nenhum]
-}

proxObs :: Int -> Int -> (Terreno,[Obstaculo]) -> [Obstaculo]
proxObs seed l (ter,obs) 
     | l == length obs = obs
     | otherwise = proxObs seed l (ter,((!!) (proximosObstaculosValidos l (ter,obs)) (mod (randomNum newSeed) (length (proximosObstaculosValidos l (ter,obs))))):obs)
          where newSeed = seed * (length obs) 

{- |
A função 'proximosTerrenosValidos' indica quais são os terrenos disponíveis para adiconar há nova linha do mapa:

@
proximosTerrenosValidos (Mapa l ((terreno,obs):t)) 
     | replicate 5 1 == take 5 (listaTerrenos ((terreno,obs):t)) = [Rio 0,Estrada 0]
     | replicate 4 2 == take 4 (listaTerrenos ((terreno,obs):t)) = [Estrada 0 ,Relva]
     | replicate 5 3 == take 5 (listaTerrenos ((terreno,obs):t)) = [Rio 0,Relva]
     | otherwise = [Rio 0, Estrada 0,Relva]
@

Foi utilizada a seguinte função auxiliar:

@
listaTerrenos [] = []
listaTerrenos ((Relva,_):t) = 1 : listaTerrenos t 
listaTerrenos ((Rio _,_):t) = 2 : listaTerrenos t 
listaTerrenos ((Estrada _,_):t) = 3 : listaTerrenos t
@

== Propriedades:
prop> proximosTerrenosValidos (Mapa l []) = [Rio 0, Estrada 0,Relva]

== Exemplos de utilização:

>>>proximosTerrenosValidos (Mapa 3 [(Rio 3, [Tronco,Nenhum,Tronco]),(Rio (-5), [Tronco,Tronco,Nenhum]), (Rio 6, [Nenhum,Nenhum,Tronco]),(Rio 1,[Nenhum,Tronco,Nenhum]),(Relva,[Arvore,Arvore,Nenhum])])
[Estrada 0,Relva]
-}

proximosTerrenosValidos :: Mapa -> [Terreno]
proximosTerrenosValidos (Mapa l []) = [Rio 0, Estrada 0,Relva]
proximosTerrenosValidos (Mapa l ((terreno,obs):t)) 
     | replicate 5 1 == take 5 (listaTerrenos ((terreno,obs):t)) = [Rio 0,Estrada 0]
     | replicate 4 2 == take 4 (listaTerrenos ((terreno,obs):t)) = [Estrada 0 ,Relva]
     | replicate 5 3 == take 5 (listaTerrenos ((terreno,obs):t)) = [Rio 0,Relva]
     | otherwise = [Rio 0, Estrada 0,Relva]
     where
          listaTerrenos :: [(Terreno,[Obstaculo])] -> [Int] 
          listaTerrenos [] = []
          listaTerrenos ((Relva,_):t) = 1 : listaTerrenos t 
          listaTerrenos ((Rio _,_):t) = 2 : listaTerrenos t 
          listaTerrenos ((Estrada _,_):t) = 3 : listaTerrenos t

{- | 
A função 'proximosObstaculosValidos' indica quais são os obstáculos disponíveis para adiconar há nova linha do mapa:

@
proximosObstaculosValidos l (Rio v ,(ob:obs)) 
     | length (ob:obs) == l = []
     | length (ob:obs) == 5 && take 5 (ob:obs) == replicate 5 Tronco = [Nenhum]
     | length (ob:obs) > 5 && last obs /= Nenhum = proximosObstaculosValidos l (Rio v ,(last obs) : (init (ob:obs)))
     | length (ob:obs) > 5 && last obs == Nenhum && take 5 (ob:obs) == replicate 5 Tronco = [Nenhum]
     | otherwise  = [Tronco,Nenhum]
proximosObstaculosValidos l (Estrada v ,(ob:obs)) 
     | length (ob:obs) == l = []
     | length (ob:obs) == 3 && take 3 (ob:obs) == replicate 3 Carro = [Nenhum]
     | length (ob:obs) > 3 && last obs /= Nenhum = proximosObstaculosValidos l (Estrada v ,(last obs) : (init (ob:obs)))
     | length (ob:obs) > 3 && last obs == Nenhum && take 3 (ob:obs) == replicate 3 Carro = [Nenhum]
     | otherwise  = [Carro,Nenhum] 
proximosObstaculosValidos l (Relva,(ob:obs))
    | length (ob:obs) >= l = []
    | length (ob:obs) == l-1 && (replicate (l-1) Arvore) == (ob:obs) = [Nenhum]
    | otherwise = [Arvore,Nenhum]
@

== Propriedades:
prop> proximosObstaculosValidos _ (Rio _,[]) = [Tronco,Nenhum]
prop> proximosObstaculosValidos _ (Estrada _,[]) = [Carro,Nenhum] 
prop> proximosObstaculosValidos _ (Relva,[]) = [Arvore,Nenhum]

== Exemplos de utilização:

>>> proximosObstaculosValidos 7 (Relva,[Arvore,Arvore,Arvore])
[Arvore,Nenhum]
-}

proximosObstaculosValidos :: Int -> (Terreno, [Obstaculo]) -> [Obstaculo]
proximosObstaculosValidos _ (Rio _,[]) = [Tronco,Nenhum]
proximosObstaculosValidos l (Rio v ,(ob:obs)) 
     | length (ob:obs) == l = []
     | length (ob:obs) < 5 && notElem Nenhum (ob:obs) = [Nenhum]
     | length (ob:obs) == 5 && take 5 (ob:obs) == replicate 5 Tronco = [Nenhum]
     | length (ob:obs) > 5 && last obs /= Nenhum = proximosObstaculosValidos l (Rio v ,(last obs) : (init (ob:obs)))
     | length (ob:obs) > 5 && last obs == Nenhum && take 5 (ob:obs) == replicate 5 Tronco = [Nenhum]
     | otherwise  = [Tronco,Nenhum]
proximosObstaculosValidos _ (Estrada _,[]) = [Carro,Nenhum] 
proximosObstaculosValidos l (Estrada v ,(ob:obs)) 
     | length (ob:obs) == l = []
     | length (ob:obs) < 3 && notElem Nenhum (ob:obs) = [Nenhum]
     | length (ob:obs) == 3 && take 3 (ob:obs) == replicate 3 Carro = [Nenhum]
     | length (ob:obs) > 3 && last obs /= Nenhum = proximosObstaculosValidos l (Estrada v ,(last obs) : (init (ob:obs)))
     | length (ob:obs) > 3 && last obs == Nenhum && take 3 (ob:obs) == replicate 3 Carro = [Nenhum]
     | otherwise  = [Carro,Nenhum] 
proximosObstaculosValidos _ (Relva,[]) = [Arvore,Nenhum]
proximosObstaculosValidos l (Relva,(ob:obs))
    | length (ob:obs) >= l = []
    | length (ob:obs) == l-1 && (replicate (l-1) Arvore) == (ob:obs) = [Nenhum] 
    | otherwise = [Arvore,Nenhum]


{- | 
A função passagem impossível ,verifica se a nova linha gerada impossibilita a passagem ao jogador:

@

passagemImpossivel :: (Terreno,[Obstaculo]) -> (Terreno,[Obstaculo]) -> Bool
passagemImpossivel (ter,obs) (ter2,obs2) = case ter of Rio _ -> case ter2 of Rio _ -> null $ intersect (elemIndices Tronco obs) (elemIndices Tronco obs2)
                                                                             Estrada _ -> null $ intersect (elemIndices Tronco obs) (elemIndices Nenhum obs2) 
                                                                             _ -> False 
                                                       Estrada _ -> case ter2 of Estrada _ -> null $ intersect (elemIndices Nenhum obs) (elemIndices Nenhum obs2)
                                                                                 Rio _ -> null $ intersect (elemIndices Nenhum obs) (elemIndices Tronco obs2)
                                                                                 _ -> False
                                                       Relva -> case ter2 of Relva -> null $ intersect (elemIndices Nenhum obs) (elemIndices Nenhum obs2)
                                                                             _ -> False

@

== Exemplos de utilização:
>>> passagemImpossivel (Rio 3,[Tronco,Tronco,Tronco,Nenhum,Nenhum,Nenhum]) (Rio (-3),[Nenhum,Nenhum,Nenhum,Tronco,Tronco,Tronco])
True
-}

passagemImpossivel :: (Terreno,[Obstaculo]) -> (Terreno,[Obstaculo]) -> Bool
passagemImpossivel (ter,obs) (ter2,obs2) = case ter of Rio _ -> case ter2 of Rio _ -> null $ intersect (elemIndices Tronco obs) (elemIndices Tronco obs2)
                                                                             Estrada _ -> null $ intersect (elemIndices Tronco obs) (elemIndices Nenhum obs2) 
                                                                             _ -> False 
                                                       Estrada _ -> case ter2 of Estrada _ -> null $ intersect (elemIndices Nenhum obs) (elemIndices Nenhum obs2)
                                                                                 Rio _ -> null $ intersect (elemIndices Nenhum obs) (elemIndices Tronco obs2)
                                                                                 _ -> False
                                                       Relva -> case ter2 of Relva -> null $ intersect (elemIndices Nenhum obs) (elemIndices Nenhum obs2)
                                                                             _ -> False

