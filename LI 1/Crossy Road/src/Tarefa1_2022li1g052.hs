{- |
Module      : Tarefa1_2022li1g052
Description : Validação de um mapa
Copyright   : Marco Soares Gonçalves <a104614@alunos.uminho.pt>
              Salvador Duarte Magalhães Barreto <a104520@alunos.uminho.pt>

Módulo para a realização da Tarefa 1 do projeto de LI1 em 2022/23.
-}
module Tarefa1_2022li1g052 where

import LI12223
import Data.List (group)

{- | 
O objectivo desta tarefa é implementar a função 'mapaValido'.

@
mapaValido m = terrenoValido m && rioValido m && obstaculosValidos m && linhaNaoCheia m && comprimentoValido m && terrenosContiguos m
@

== Propriedades:
prop> mapaValido (Mapa l []) = False

== Exemplos de utilização:

>>> mapaValido (Mapa 6 [(Relva,[Arvore,Nenhum,Arvore,Arvore,Arvore,Nenhum]),(Rio 3,[Nenhum,Tronco,Tronco,Tronco,Tronco,Tronco]),(Rio (-2),[Tronco,Nenhum,Tronco,Nenhum,Nenhum,Tronco])])
True
>>> mapaValido (Mapa 4 [(Rio 3,[Tronco,Tronco,Arvore]),(Relva,[Carro,Nenhum])])
False
-}

mapaValido :: Mapa      -- ^ recebe um mapa
                -> Bool -- ^ apresenta se este é válido ou não
mapaValido (Mapa l []) = False
mapaValido m = terrenoValido m && rioValido m && troncosValidos m && carrosValidos m && linhaNaoCheia m && comprimentoValido m && terrenosContiguos m
 
{- |
1. A função 'terrenoValido' está encarregue de verificar que não existem obstáculos em terrenos impróprios, isto é, troncos em estradas ou relvas, árvores em rios ou estradas, ou carros em rios ou relvas:

@
terrenoValido (Mapa l ((Relva,(ob:obs)):t)) = (ob == Arvore || ob == Nenhum ) && terrenoValido (Mapa l ((Relva,obs):t)) && terrenoValido (Mapa l t)
terrenoValido (Mapa l ((Estrada v,(ob:obs)):t)) = (ob == Carro || ob == Nenhum) && terrenoValido (Mapa l ((Estrada v ,obs):t)) && terrenoValido (Mapa l t)
terrenoValido (Mapa l ((Rio v,(ob:obs)):t)) = (ob == Tronco || ob == Nenhum) && terrenoValido (Mapa l ((Rio v ,obs):t)) && terrenoValido (Mapa l t)
@

== Propriedades:
prop> terrenoValido (Mapa l []) = True

== Exemplos de utilização:

>>> terrenoValido (Mapa 2 [(Relva,[Arvore,Nenhum]),(Rio 2,[Tronco,Nenhum]),(Estrada (-2),[Carro,Nenhum])])
True
>>> terrenoValido (Mapa 3 [(Relva,[Arvore,Nenhum,Nenhum]),(Estrada (-2),[Tronco,Nenhum,Carro])])
False
-}

terrenoValido ::  Mapa -> Bool
terrenoValido (Mapa l []) = True
terrenoValido (Mapa l ((_,[]):t)) = terrenoValido (Mapa l t)
terrenoValido (Mapa l ((Relva,(ob:obs)):t)) = (ob == Arvore || ob == Nenhum ) && terrenoValido (Mapa l ((Relva,obs):t)) && terrenoValido (Mapa l t)
terrenoValido (Mapa l ((Estrada v,(ob:obs)):t)) = (ob == Carro || ob == Nenhum) && terrenoValido (Mapa l ((Estrada v ,obs):t)) && terrenoValido (Mapa l t)
terrenoValido (Mapa l ((Rio v,(ob:obs)):t)) = (ob == Tronco || ob == Nenhum) && terrenoValido (Mapa l ((Rio v ,obs):t)) && terrenoValido (Mapa l t)
    
{- |
2. A função 'rioValido' é responsável por verificar se rios contíguos têm direções opostas:

@
rioValido (Mapa l [ts]) = True
rioValido (Mapa l ((Estrada v,ob):t)) = rioValido (Mapa l t)
rioValido (Mapa l ((Relva,ob):t)) = rioValido (Mapa l t)
rioValido (Mapa l ((Rio v,ob):(Rio v1,ob1):t)) = (v * v1 < 0) && rioValido (Mapa l ((Rio v1,ob1):t))
rioValido (Mapa l ((Rio v,ob):(terreno,ob2):t))
    | elem Arvore ob2 || elem Carro ob2 = rioValido (Mapa l ((terreno,ob2):t))
    | otherwise = rioValido (Mapa l t)
@

== Propriedades:
prop> rioValido (Mapa l []) = True

== Exemplos de utilização:

>>> rioValido (Mapa 3 [(Relva,[Arvore,Nenhum,Arvore]),(Rio 2,[Nenhum,Tronco,Nenhum]),(Rio (-3),[Tronco,Tronco,Nenhum])])
True
>>> (Mapa 3 [(Rio 2,[Nenhum,Tronco,Tronco]),(Rio 1,[Tronco,Nenhum,Nenhum])])
False
-}

rioValido :: Mapa -> Bool
rioValido (Mapa l []) = True
rioValido (Mapa l [ts]) = True
rioValido (Mapa l ((Estrada v,ob):t)) = rioValido (Mapa l t)
rioValido (Mapa l ((Relva,ob):t)) = rioValido (Mapa l t)
rioValido (Mapa l ((Rio v,ob):(Rio v1,ob1):t)) = (v * v1 < 0) && rioValido (Mapa l ((Rio v1,ob1):t))
rioValido (Mapa l ((Rio v,ob):(terreno,ob2):t))
    | elem Arvore ob2 || elem Carro ob2 = rioValido (Mapa l ((terreno,ob2):t))
    | otherwise = rioValido (Mapa l t)

{-|
3. A função 'troncosValidos' encarrega-se de verificar que, na mesma linha, troncos não tem mais de 5 unidades de comprimento:

@
troncosValidos (Mapa l ((terreno,[]):t)) = troncosValidos (Mapa l t)
troncosValidos (Mapa l ((Relva,_):t)) = troncosValidos (Mapa l t)
troncosValidos (Mapa l ((Estrada _,_):t)) = troncosValidos (Mapa l t)
troncosValidos (Mapa l ((Rio _,obs):t)) = if troncos (length obs) obs 
                                          then troncosValidos (Mapa l (t))
                                          else False 
@

Foi utilizada a função auxiliar 'troncos':

@
troncos :: Int -> [Obstaculo] -> Bool
troncos 0 (ob:obs) = True 
troncos a (ob:obs) | take 6 (ob:obs) == (replicate 6 Tronco) = False
                   | otherwise = troncos (a-1) (obs ++ [ob])
@

== Propriedades:
prop> troncosValidos (Mapa l []) = True 

== Exemplos de utilização:

>>> troncosValidos (Mapa 6 [(Relva,[Nenhum,Nenhum,Arvore,Nenhum,Arvore,Arvore]),(Rio 3,[Tronco,Tronco,Nenhum,Tronco,Nenhum,Tronco])])
True
>>> troncosValidos (Mapa 7 [(Relva,[Nenhum,Nenhum,Arvore,Nenhum,Arvore,Arvore,Nenhum]),(Rio 1,[Tronco,Tronco,Tronco,Tronco,Tronco,Tronco,Tronco])])
False
-}

troncosValidos :: Mapa -> Bool
troncosValidos (Mapa l []) = True 
troncosValidos (Mapa l ((terreno,[]):t)) = troncosValidos (Mapa l t)
troncosValidos (Mapa l ((Relva,_):t)) = troncosValidos (Mapa l t)
troncosValidos (Mapa l ((Estrada _,_):t)) = troncosValidos (Mapa l t)
troncosValidos (Mapa l ((Rio _,obs):t)) = if troncos (length obs) obs 
                                          then troncosValidos (Mapa l (t))
                                          else False 
    where
        troncos :: Int -> [Obstaculo] -> Bool
        troncos 0 (ob:obs) = True 
        troncos a (ob:obs) | take 6 (ob:obs) == (replicate 6 Tronco) = False
                           | otherwise = troncos (a-1) (obs ++ [ob])
{-|
4. A função 'carrosValidos' é responsável por verificar que, na mesma linha, Carros não têm mais do que 3 unidades de comprimento:

@
carrosValidos (Mapa l ((terreno,[]):t)) = carrosValidos (Mapa l t)
carrosValidos (Mapa l ((Relva,_):t)) = carrosValidos (Mapa l t)
carrosValidos (Mapa l ((Rio _,_):t)) = carrosValidos (Mapa l t)
carrosValidos (Mapa l ((terrreno,obs):t)) = if carros (length obs) obs 
                                            then carrosValidos (Mapa l (t))
                                            else False 
@

Foi utilizada a função aulixiar 'carros':

@
carros :: Int -> [Obstaculo] -> Bool
carros 0 (ob:obs) = True 
carros a (ob:obs) | take 4 (ob:obs) == (replicate 4 Tronco) = False
                  | otherwise = carros (a-1) (obs ++ [ob])
@

== Propriedades:
prop> carrosValidos (Mapa l []) = True 

== Exemplos de utilização:

>>> carrosValidos (Mapa 4 [(Rio 2,[Tronco,Nenhum,Nenhum,Tronco]),(Estrada 2,[Carro,Carro,Nenhum,Nenhum])])
True
>>> carrosValidos (Mapa 4 [(Estrada 1,[Carro,Carro,Carro,Carro]),(Relva,[Arvore,Nenhum,Nenhum,Arvore])])
False
-}

carrosValidos :: Mapa -> Bool
carrosValidos (Mapa l []) = True 
carrosValidos (Mapa l ((terreno,[]):t)) = carrosValidos (Mapa l t) 
carrosValidos (Mapa l ((Relva,_):t)) = carrosValidos (Mapa l t)
carrosValidos (Mapa l ((Rio _,_):t)) = carrosValidos (Mapa l t)
carrosValidos (Mapa l ((Estrada _,obs):t)) = if carros (length obs) obs 
                                            then carrosValidos (Mapa l (t))
                                            else False 
    where
        carros :: Int -> [Obstaculo] -> Bool
        carros 0 (ob:obs) = True 
        carros a (ob:obs) | take 4 (ob:obs) == (replicate 4 Carro) = False
                          | otherwise = carros (a-1) (obs ++ [ob])

{-|
5. A função 'linhaNaoCheia' ocupa-se de verificar que uma linha não pode ser composta exclusivamente por obstáculos, ou seja, tem de haver pelo menos um Nennhum em cada linha:

@
linhaNaoCheia (Mapa l ((terreno,ob):t)) 
    | elem Nenhum ob = linhaNaoCheia (Mapa l t)
    | otherwise = False
@

== Propriedades:
prop> linhaNaoCheia (Mapa l []) = True

== Exemplos de utilização:

>>> linhaNaoCheia (Mapa 3 [(Estrada 3,[Nenhum,Carro,Carro]),(Relva,[Arvore,Nenhum,Nenhum]),(Rio 2,[Tronco,Nenhum,Tronco])])
True
>>> linhaNaoCheia (Mapa 3 [(Relva,[Arvore,Arvore,Arvore])])
False
-}

linhaNaoCheia :: Mapa -> Bool 
linhaNaoCheia (Mapa l []) = True
linhaNaoCheia (Mapa l ((terreno,ob):t)) 
    | elem Nenhum ob = linhaNaoCheia (Mapa l t)
    | otherwise = False

{-|
6. A função 'comprimentoValido' é responsável por verificar que o comprimento da lista de obstáculos de cada linha é igual a largura do mapa:

@
comprimentoValido (Mapa largura ((terreno,obs):t)) = if largura == length obs
                                                     then comprimentoValido (Mapa largura t)
                                                     else False
@

== Propriedades:
prop> comprimentoValido (Mapa _ []) = True

== Exemplos de utilização:

>>> comprimentoValido (Mapa 2 [(Rio 1,[Tronco,Nenhum]),(Relva,[Arvore,Nenhum]),(Estrada 1,[Carro,Nenhum])])
True
>>> comprimentoValido (Mapa 3 [(Estrada 2,[Carro,Carro,Nenhum,Carro]),(Relva,[Nenhum,Arvore,Arvore])])
False
-}

comprimentoValido :: Mapa -> Bool
comprimentoValido (Mapa _ []) = True
comprimentoValido (Mapa largura ((terreno,obs):t)) = if largura == length obs
                                                     then comprimentoValido (Mapa largura t)
                                                     else False

{-|
7. A função 'terrenosContiguos' encarrega-se de verificar que, contiguamente, não existem mais do que 4 rios, 5 estradas ou relvas:

@
terrenosContiguos (Mapa l tr@(t:ts)) 
    | (replicate 5 2) == terrenosToInt (take 5 tr) = False
    | (replicate 6 1) == terrenosToInt (take 6 tr) = False
    | (replicate 6 3) == terrenosToInt (take 6 tr) = False
    | otherwise = terrenosContiguos (Mapa l ts)
@

Foi utilizada a função auxiliar 'terrenosToInt':

@
terrenosToInt :: [(Terreno,[Obstaculo])] -> [Int] 
terrenosToInt [] = []
terrenosToInt ((Relva,_):t) = 1 : terrenosToInt t
terrenosToInt ((Rio _,_):t) = 2 : terrenosToInt t
terrenosToInt ((Estrada _,_):t) = 3 : terrenosToInt t
@

== Propriedades:
prop> terrenosContiguos (Mapa l []) = True

== Exemplos de utilização:

>>> terrenosContiguos (Mapa 4 [(Relva,[Arvore,Nenhum,Nenhum,Arvore]),(Relva,[Nenhum,Arvore,Arvore,Arvore]),(Rio 5,[Tronco,Tronco,Nenhum,Nenhum]),(Estrada 2,[Nenhum,Carro,Nenhum,Nenhum])])
True
>>> terrenosContiguos (Mapa 2 [(Relva,[Arvore,Nenhum]),(Relva,[Arvore,Nenhum]),(Relva,[Nenhum,Nenhum]),(Relva,[Nenhum,Arvore]),(Relva,[Nenhum,Arvore]),(Relva,[Arvore,Nenhum])])
False
-}

terrenosContiguos :: Mapa -> Bool
terrenosContiguos (Mapa l []) = True
terrenosContiguos (Mapa l tr@(t:ts)) 
    | (replicate 5 2) == terrenosToInt (take 5 tr) = False
    | (replicate 6 1) == terrenosToInt (take 6 tr) = False
    | (replicate 6 3) == terrenosToInt (take 6 tr) = False
    | otherwise = terrenosContiguos (Mapa l ts)
        where
            terrenosToInt :: [(Terreno,[Obstaculo])] -> [Int] 
            terrenosToInt [] = []
            terrenosToInt ((Relva,_):t) = 1 : terrenosToInt t
            terrenosToInt ((Rio _,_):t) = 2 : terrenosToInt t
            terrenosToInt ((Estrada _,_):t) = 3 : terrenosToInt t