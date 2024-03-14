{-|
Foi na Main que implementamos a parte gráfica do trabalho. Tudo o que é apresentado na tela foi desenhado pelo Salvador de forma
a que obtessemos visuais adequados aos nossos gostos e ideias. O nosso jogo contém 3 personagens jogáveis (galinha,sapo,pinguim).

-}


module Main where


import LI12223
import Tarefa1_2022li1g052
import Tarefa2_2022li1g052
import Tarefa3_2022li1g052
import Tarefa4_2022li1g052
import Tarefa5_2022li1g052

import Data.Maybe
import Data.List
import Graphics.Gloss
import Graphics.Gloss.Interface.Pure.Game
import Graphics.Gloss.Interface.Environment
import System.Random


type EstadoGloss = (Menu, Jogo, Skin, Textures, GuardaRoupa, TexMenu, Time, Bool, Seed, Score)

data Menu = Opcoes Opcao
          | ModoJogo
          | PerdeuJogo
          | Fundo
          | FundoPersonagens
          deriving (Show, Read, Eq)

data Opcao = Jogar
           | Sair
           | Voltar
           | Personagem1
           | Personagem2
           | Personagem3
           deriving (Show, Read, Eq)

data Skin = Skin Int 
          deriving (Show, Read, Eq)

type TexMenu = [(Menu, Picture)]

type GuardaRoupa = [(Skin, Picture)]

type Textures = [(Obstaculo, Picture)]

type Time = Int

type Seed = Int 

type Score = Int


l :: Float
l = 9

{-|
A função 'estadoGlossInicial' é como o nome diz o estado em que o jogo irá começar:

@
estadoGlossInicial :: Textures -> GuardaRoupa -> TexMenu -> Seed -> Score -> EstadoGloss
estadoGlossInicial textures gr texmenu seed score = (Opcoes Jogar, jogoInicial, Skin 1, textures, gr, texmenu, 0, False, seed, score)       
                            where jogoInicial = (Jogo (Jogador (4,4)) (Mapa 9 [(Rio 1,[Tronco,Tronco,Tronco,Tronco,Nenhum,Nenhum,Tronco,Nenhum,Tronco]),
                                                                               (Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore,Nenhum,Arvore,Nenhum,Arvore]),
                                                                               (Estrada (-1),[Carro,Carro,Nenhum,Nenhum,Nenhum,Carro,Carro,Nenhum,Carro]),
                                                                               (Estrada 1,[Nenhum,Carro,Carro,Nenhum,Nenhum,Nenhum,Carro,Nenhum,Nenhum]),
                                                                               (Relva,[Arvore,Arvore,Arvore,Nenhum,Nenhum,Nenhum,Arvore,Arvore,Arvore]),
                                                                               (Relva,[Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore]),
                                                                               (Relva,[Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore])]) )
                                
@
-}

estadoGlossInicial :: Textures -> GuardaRoupa -> TexMenu -> Seed -> Score -> EstadoGloss
estadoGlossInicial textures gr texmenu seed score = (Opcoes Jogar, jogoInicial, Skin 1, textures, gr, texmenu, 0, False, seed, score)       
                            where jogoInicial = (Jogo (Jogador (4,4)) (Mapa 9 [(Rio 1,[Tronco,Tronco,Tronco,Tronco,Nenhum,Nenhum,Tronco,Nenhum,Tronco]),
                                                                               (Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore,Nenhum,Arvore,Nenhum,Arvore]),
                                                                               (Estrada (-1),[Carro,Carro,Nenhum,Nenhum,Nenhum,Carro,Carro,Nenhum,Carro]),
                                                                               (Estrada 1,[Nenhum,Carro,Carro,Nenhum,Nenhum,Nenhum,Carro,Nenhum,Nenhum]),
                                                                               (Relva,[Arvore,Arvore,Arvore,Nenhum,Nenhum,Nenhum,Arvore,Arvore,Arvore]),
                                                                               (Relva,[Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore]),
                                                                               (Relva,[Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore,Arvore])]) )
                                
                                
                                

{-|
A função 'desenhaEstado' está encarregue de desenhar tudo o que irá aparecer na tela, desde o mapa , menus, etc ... 
Utiliza as funções 'desenhaScore', 'desenhaMenu', 'desenhaJogador' e 'desenhaMapa' como auxiliares.

@
desenhaEstado :: EstadoGloss -> Picture
desenhaEstado (PerdeuJogo, jogo, skin, tex, gr, texmenu, temp, True, seed, score) = Pictures ([desenhaMenu PerdeuJogo texmenu] ++ [translate 235 (-50) (desenhaScore score)])
desenhaEstado (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu Fundo texmenu] ++ [selectedJogar] ++ [notSelectedSair])
                                                                    where selectedJogar = translate 300 0 (desenhaMenu (Opcoes Jogar) texmenu)
                                                                          notSelectedSair = translate 300 (-128) (desenhaMenu (Opcoes Sair) (drop 2 texmenu))

desenhaEstado (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu Fundo texmenu] ++ [selectedSair] ++ [notSelectedJogar])
                                                                    where notSelectedJogar = translate 300 0 (desenhaMenu (Opcoes Jogar) (drop 2 texmenu))
                                                                          selectedSair = translate 300 (-128) (desenhaMenu (Opcoes Sair) texmenu)

desenhaEstado (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu FundoPersonagens texmenu] ++ [selectedP1] ++ [notSelectedP2] ++ [notSelectedP3] ++ [back])
                                                                    where selectedP1 = translate (-350) (-100) (desenhaMenu (Opcoes Personagem1) texmenu) 
                                                                          notSelectedP2 = translate 0 (-100) (desenhaMenu (Opcoes Personagem2) (drop 5 texmenu))
                                                                          notSelectedP3 = translate 350 (-100) (desenhaMenu (Opcoes Personagem3) (drop 5 texmenu)) 
                                                                          back = translate (-500) 385 (desenhaMenu (Opcoes Voltar) texmenu)

desenhaEstado (Opcoes Personagem2, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu FundoPersonagens texmenu] ++ [selectedP2] ++ [notSelectedP1] ++ [notSelectedP3] ++ [back])
                                                                    where selectedP2 = translate 0 (-100) (desenhaMenu (Opcoes Personagem2) texmenu) 
                                                                          notSelectedP1 = translate (-350) (-100) (desenhaMenu (Opcoes Personagem1) (drop 5 texmenu))
                                                                          notSelectedP3 = translate 350 (-100) (desenhaMenu (Opcoes Personagem3) (drop 5 texmenu)) 
                                                                          back = translate (-500) 385 (desenhaMenu (Opcoes Voltar) texmenu)                                                           

desenhaEstado (Opcoes Personagem3, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu FundoPersonagens texmenu] ++ [selectedP3] ++ [notSelectedP1] ++ [notSelectedP2] ++ [back])
                                                                    where selectedP3 = translate 350 (-100) (desenhaMenu (Opcoes Personagem3) texmenu) 
                                                                          notSelectedP1 = translate (-350) (-100) (desenhaMenu (Opcoes Personagem1) (drop 5 texmenu))
                                                                          notSelectedP2 = translate 0 (-100) (desenhaMenu (Opcoes Personagem2) (drop 5 texmenu))  
                                                                          back = translate (-500) 385 (desenhaMenu (Opcoes Voltar) texmenu)

desenhaEstado (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu FundoPersonagens texmenu] ++ [selectedVoltar] ++ [notSelectedP1] ++ [notSelectedP2] ++ [notSelectedP3])
                                                                    where selectedVoltar = translate (-500) 385 (desenhaMenu (Opcoes Voltar) (drop 11 texmenu))
                                                                          notSelectedP1 = translate (-350) (-100) (desenhaMenu (Opcoes Personagem1) (drop 5 texmenu))    
                                                                          notSelectedP2 = translate 0 (-100) (desenhaMenu (Opcoes Personagem2) (drop 5 texmenu))                                      
                                                                          notSelectedP3 = translate 350 (-100) (desenhaMenu (Opcoes Personagem3) (drop 5 texmenu))                                   

desenhaEstado (ModoJogo, (Jogo (Jogador (x,y)) mapa), skin, tex, gr, texmenu, temp, tr, seed, score) = translate (-503) 375 (Pictures ((initialMap) ++ [initialPlayer] ++ [pontuacao]))
                                                                    where initialMap = desenhaMapa (-l) l mapa tex 
                                                                          initialPlayer = desenhaJogador (Jogador (x,y)) skin gr 
                                                                          pontuacao = translate 970 (-30) $ color (orange) (desenhaScore score)
@
-}

desenhaEstado :: EstadoGloss -> Picture
desenhaEstado (PerdeuJogo, jogo, skin, tex, gr, texmenu, temp, True, seed, score) = Pictures ([desenhaMenu PerdeuJogo texmenu] ++ [translate 235 (-50) (desenhaScore score)])
desenhaEstado (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu Fundo texmenu] ++ [selectedJogar] ++ [notSelectedSair])
                                                                    where selectedJogar = translate 300 0 (desenhaMenu (Opcoes Jogar) texmenu)
                                                                          notSelectedSair = translate 300 (-128) (desenhaMenu (Opcoes Sair) (drop 2 texmenu))

desenhaEstado (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu Fundo texmenu] ++ [selectedSair] ++ [notSelectedJogar])
                                                                    where notSelectedJogar = translate 300 0 (desenhaMenu (Opcoes Jogar) (drop 2 texmenu))
                                                                          selectedSair = translate 300 (-128) (desenhaMenu (Opcoes Sair) texmenu)

desenhaEstado (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu FundoPersonagens texmenu] ++ [selectedP1] ++ [notSelectedP2] ++ [notSelectedP3] ++ [back])
                                                                    where selectedP1 = translate (-350) (-100) (desenhaMenu (Opcoes Personagem1) texmenu) 
                                                                          notSelectedP2 = translate 0 (-100) (desenhaMenu (Opcoes Personagem2) (drop 5 texmenu))
                                                                          notSelectedP3 = translate 350 (-100) (desenhaMenu (Opcoes Personagem3) (drop 5 texmenu)) 
                                                                          back = translate (-500) 385 (desenhaMenu (Opcoes Voltar) texmenu)

desenhaEstado (Opcoes Personagem2, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu FundoPersonagens texmenu] ++ [selectedP2] ++ [notSelectedP1] ++ [notSelectedP3] ++ [back])
                                                                    where selectedP2 = translate 0 (-100) (desenhaMenu (Opcoes Personagem2) texmenu) 
                                                                          notSelectedP1 = translate (-350) (-100) (desenhaMenu (Opcoes Personagem1) (drop 5 texmenu))
                                                                          notSelectedP3 = translate 350 (-100) (desenhaMenu (Opcoes Personagem3) (drop 5 texmenu)) 
                                                                          back = translate (-500) 385 (desenhaMenu (Opcoes Voltar) texmenu)                                                           

desenhaEstado (Opcoes Personagem3, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu FundoPersonagens texmenu] ++ [selectedP3] ++ [notSelectedP1] ++ [notSelectedP2] ++ [back])
                                                                    where selectedP3 = translate 350 (-100) (desenhaMenu (Opcoes Personagem3) texmenu) 
                                                                          notSelectedP1 = translate (-350) (-100) (desenhaMenu (Opcoes Personagem1) (drop 5 texmenu))
                                                                          notSelectedP2 = translate 0 (-100) (desenhaMenu (Opcoes Personagem2) (drop 5 texmenu))  
                                                                          back = translate (-500) 385 (desenhaMenu (Opcoes Voltar) texmenu)

desenhaEstado (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, False, seed, score) = Pictures ([desenhaMenu FundoPersonagens texmenu] ++ [selectedVoltar] ++ [notSelectedP1] ++ [notSelectedP2] ++ [notSelectedP3])
                                                                    where selectedVoltar = translate (-500) 385 (desenhaMenu (Opcoes Voltar) (drop 11 texmenu))
                                                                          notSelectedP1 = translate (-350) (-100) (desenhaMenu (Opcoes Personagem1) (drop 5 texmenu))    
                                                                          notSelectedP2 = translate 0 (-100) (desenhaMenu (Opcoes Personagem2) (drop 5 texmenu))                                      
                                                                          notSelectedP3 = translate 350 (-100) (desenhaMenu (Opcoes Personagem3) (drop 5 texmenu))                                   

desenhaEstado (ModoJogo, (Jogo (Jogador (x,y)) mapa), skin, tex, gr, texmenu, temp, tr, seed, score) = translate (-503) 375 (Pictures ((initialMap) ++ [initialPlayer] ++ [pontuacao]))
                                                                    where initialMap = desenhaMapa (-l) l mapa tex 
                                                                          initialPlayer = desenhaJogador (Jogador (x,y)) skin gr 
                                                                          pontuacao = translate 970 (-30) $ color (orange) (desenhaScore score)

{-|
@
desenhaScore :: Score -> Picture 
desenhaScore score = scale 0.7 0.7 $ Text (show score)

@

-}

desenhaScore :: Score -> Picture 
desenhaScore score = scale 0.7 0.7 $ Text (show score)

------------------------------------------------------------------------------------------------------------------------------------
{-|
@
desenhaMenu :: Menu -> TexMenu -> Picture
desenhaMenu m texmenu = (fromJust . lookup m) texmenu

@

-}

desenhaMenu :: Menu -> TexMenu -> Picture
desenhaMenu m texmenu = (fromJust . lookup m) texmenu
 
--------------------------------------------------------------------------------------------------------------------------------------
{-|
@
desenhaJogador :: Jogador -> Skin -> GuardaRoupa -> Picture
desenhaJogador (Jogador (x,y)) skin gr = Translate newX newY textura
    where textura = (fromJust . lookup skin) gr 
          newX = fromInteger $ toInteger x *128
          newY = fromInteger $ toInteger (-y) *128

@

-}

desenhaJogador :: Jogador -> Skin -> GuardaRoupa -> Picture
desenhaJogador (Jogador (x,y)) skin gr = Translate newX newY textura
    where textura = (fromJust . lookup skin) gr 
          newX = fromInteger $ toInteger x *128
          newY = fromInteger $ toInteger (-y) *128



-----------------------------------------------------------------------------------------------------------------------------------------

{-|
@

desenhaMapa :: Float -> Float -> Mapa -> Textures -> [Picture]
desenhaMapa x y (Mapa l []) tex = []
desenhaMapa x y (Mapa l ((ter,obs):t)) tex = picFstLine : leftLine
                                            where picFstLine = (translate 0 y (pictures fstLine))
                                                  fstLine = desenhaLinha x y (ter,obs) tex
                                                  leftLine = (desenhaMapa x (y-128) (Mapa l t)) tex

@

-}

desenhaMapa :: Float -> Float -> Mapa -> Textures -> [Picture]
desenhaMapa x y (Mapa l []) tex = []
desenhaMapa x y (Mapa l ((ter,obs):t)) tex = picFstLine : leftLine
                                            where picFstLine = (translate 0 y (pictures fstLine))
                                                  fstLine = desenhaLinha x y (ter,obs) tex
                                                  leftLine = (desenhaMapa x (y-128) (Mapa l t)) tex

{-|
@

desenhaLinha :: Float -> Float -> (Terreno,[Obstaculo]) -> Textures -> [Picture]
desenhaLinha x y (ter,[]) tex = []
desenhaLinha x y (ter,(h:t)) tex = fstOb : leftOb 
                                   where fstOb = (translate x 0 (desenhoObs ter h tex))
                                         leftOb = (desenhaLinha (x+128) y (ter,t) tex) 

@

-}

desenhaLinha :: Float -> Float -> (Terreno,[Obstaculo]) -> Textures -> [Picture]
desenhaLinha x y (ter,[]) tex = []
desenhaLinha x y (ter,(h:t)) tex = fstOb : leftOb 
                                   where fstOb = (translate x 0 (desenhoObs ter h tex))
                                         leftOb = (desenhaLinha (x+128) y (ter,t) tex) 


{-|
@

desenhoObs :: Terreno -> Obstaculo -> Textures -> Picture 
desenhoObs Relva ob tex = fromJust (lookup ob tex)
desenhoObs (Estrada v) ob tex = if v > 0 
                                then fromJust (lookup ob (drop 1 tex))
                                else fromJust (lookup ob (delete (tex !! 4) (drop 1 tex)))
desenhoObs (Rio v) ob tex = fromJust (lookup ob (drop 2 tex))

@

-}


desenhoObs :: Terreno -> Obstaculo -> Textures -> Picture 
desenhoObs Relva ob tex = fromJust (lookup ob tex)
desenhoObs (Estrada v) ob tex = if v > 0 
                                then fromJust (lookup ob (drop 1 tex))
                                else fromJust (lookup ob (delete (tex !! 4) (drop 1 tex)))
desenhoObs (Rio v) ob tex = fromJust (lookup ob (drop 2 tex))
                                                  
--------------------------------------------------------------------------------------------------------------------------------------------------------------

{-|
Esta função reage ao input do usuário:

@

reageEventoGloss :: Event -> EstadoGloss -> EstadoGloss
reageEventoGloss e (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = 
    case e of (EventKey (SpecialKey KeyEnter) Down _ _) -> (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyUp) Down _ _) -> (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyDown) Down _ _) -> (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) =
    case e of (EventKey (SpecialKey KeyUp) Down _ _) -> (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyDown) Down _ _) -> (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyEnter) Down _ _) -> error "Game Closed"
              _ -> (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = 
    case e of (EventKey (SpecialKey KeyEnter) Down _ _) -> (ModoJogo, jogo, Skin 1, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyRight) Down _ _) -> (Opcoes Personagem2, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyLeft) Down _ _) -> (Opcoes Personagem3, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyEsc) Down _ _ ) -> (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyUp) Down _ _) -> (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (Opcoes Personagem2, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = 
    case e of (EventKey (SpecialKey KeyEnter) Down _ _) -> (ModoJogo, jogo, Skin 2, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyRight) Down _ _) -> (Opcoes Personagem3, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyLeft) Down _ _) -> (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyUp) Down _ _) -> (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (Opcoes Personagem2, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (Opcoes Personagem3, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = 
    case e of (EventKey (SpecialKey KeyEnter) Down _ _) -> (ModoJogo, jogo, Skin 3, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyRight) Down _ _) -> (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyLeft) Down _ _) -> (Opcoes Personagem2, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyUp) Down _ _) -> (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (Opcoes Personagem3, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) =
    case e of (EventKey (SpecialKey KeyEnter) Down _ _) -> (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyDown) Down _ _) -> (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (ModoJogo, (Jogo (Jogador (x,y)) mapa), skin, tex, gr, texmenu, temp, tr, seed, score) = 
    case e of (EventKey (SpecialKey KeyUp) Down _ _) -> (ModoJogo, ((Jogo (betterMoveJogador (Jogador (x,y)) mapa (Move Cima))) mapa), skin, tex, gr, texmenu, temp, tr, seed, newScore)
              (EventKey (SpecialKey KeyDown) Down _ _) -> (ModoJogo, ((Jogo (betterMoveJogador (Jogador (x,y)) mapa (Move Baixo))) mapa), skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyRight) Down _ _) -> (ModoJogo, ((Jogo (betterMoveJogador (Jogador (x,y)) mapa (Move Direita))) mapa), skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyLeft) Down _ _) -> (ModoJogo, ((Jogo (betterMoveJogador (Jogador (x,y)) mapa (Move Esquerda))) mapa), skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (ModoJogo, (Jogo (Jogador (x,y)) mapa), skin, tex, gr, texmenu, temp, tr, seed, score)
        where (_,newScore) = contaScore (Jogo (Jogador (x,y)) mapa) (Move Cima) score

reageEventoGloss (EventKey (SpecialKey KeyEnter) Down _ _) (PerdeuJogo, jogo, skin, tex, gr, texmenu, temp, True, seed, score) = estadoGlossInicial tex gr texmenu seed 0
reageEventoGloss _ k = k
@

-}

reageEventoGloss :: Event -> EstadoGloss -> EstadoGloss
reageEventoGloss e (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = 
    case e of (EventKey (SpecialKey KeyEnter) Down _ _) -> (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyUp) Down _ _) -> (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyDown) Down _ _) -> (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) =
    case e of (EventKey (SpecialKey KeyUp) Down _ _) -> (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyDown) Down _ _) -> (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyEnter) Down _ _) -> error "Game Closed"
              _ -> (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = 
    case e of (EventKey (SpecialKey KeyEnter) Down _ _) -> (ModoJogo, jogo, Skin 1, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyRight) Down _ _) -> (Opcoes Personagem2, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyLeft) Down _ _) -> (Opcoes Personagem3, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyEsc) Down _ _ ) -> (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyUp) Down _ _) -> (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (Opcoes Personagem2, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = 
    case e of (EventKey (SpecialKey KeyEnter) Down _ _) -> (ModoJogo, jogo, Skin 2, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyRight) Down _ _) -> (Opcoes Personagem3, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyLeft) Down _ _) -> (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyUp) Down _ _) -> (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (Opcoes Personagem2, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (Opcoes Personagem3, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = 
    case e of (EventKey (SpecialKey KeyEnter) Down _ _) -> (ModoJogo, jogo, Skin 3, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyRight) Down _ _) -> (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyLeft) Down _ _) -> (Opcoes Personagem2, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyUp) Down _ _) -> (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (Opcoes Personagem3, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) =
    case e of (EventKey (SpecialKey KeyEnter) Down _ _) -> (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyDown) Down _ _) -> (Opcoes Personagem1, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score)

reageEventoGloss e (ModoJogo, (Jogo (Jogador (x,y)) mapa), skin, tex, gr, texmenu, temp, tr, seed, score) = 
    case e of (EventKey (SpecialKey KeyUp) Down _ _) -> (ModoJogo, ((Jogo (betterMoveJogador (Jogador (x,y)) mapa (Move Cima))) mapa), skin, tex, gr, texmenu, temp, tr, seed, newScore)
              (EventKey (SpecialKey KeyDown) Down _ _) -> (ModoJogo, ((Jogo (betterMoveJogador (Jogador (x,y)) mapa (Move Baixo))) mapa), skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyRight) Down _ _) -> (ModoJogo, ((Jogo (betterMoveJogador (Jogador (x,y)) mapa (Move Direita))) mapa), skin, tex, gr, texmenu, temp, tr, seed, score)
              (EventKey (SpecialKey KeyLeft) Down _ _) -> (ModoJogo, ((Jogo (betterMoveJogador (Jogador (x,y)) mapa (Move Esquerda))) mapa), skin, tex, gr, texmenu, temp, tr, seed, score)
              _ -> (ModoJogo, (Jogo (Jogador (x,y)) mapa), skin, tex, gr, texmenu, temp, tr, seed, score)
        where (_,newScore) = contaScore (Jogo (Jogador (x,y)) mapa) (Move Cima) score

reageEventoGloss (EventKey (SpecialKey KeyEnter) Down _ _) (PerdeuJogo, jogo, skin, tex, gr, texmenu, temp, True, seed, score) = estadoGlossInicial tex gr texmenu seed 0
reageEventoGloss _ k = k



{-|
A função contaScore está encarregue de apresentar a pontuação máxima do jogador:

@
contaScore :: Jogo -> Jogada -> Int -> (Int,Int)
contaScore (Jogo (Jogador (x,y)) mapa) jg acc = if nY < y then (nY, acc +1) else (y, acc) 
                where (Jogador (nX,nY)) = betterMoveJogador (Jogador (x,y)) mapa jg
@
-}

contaScore :: Jogo -> Jogada -> Int -> (Int,Int)
contaScore (Jogo (Jogador (x,y)) mapa) jg acc = if nY < y then (nY, acc +1) else (y, acc) 
                where (Jogador (nX,nY)) = betterMoveJogador (Jogador (x,y)) mapa jg



{-|
A função reageTempo anima o jogo baseado no tempo que se passou:

@
reageTempo :: Float -> EstadoGloss -> EstadoGloss
reageTempo n (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Jogar, jogo, skin, tex, gr, texmenu, 0, tr, seed, score) 
reageTempo n (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Sair, jogo, skin, tex, gr, texmenu, 0, tr, seed, score)
reageTempo n (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Voltar, jogo, skin, tex, gr, texmenu, 0, tr, seed, score)
reageTempo n (Opcoes Personagem1, skin, jogo, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Personagem1, skin, jogo, tex, gr, texmenu, temp, tr, seed, score)
reageTempo n (Opcoes Personagem2, skin, jogo, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Personagem2, skin, jogo, tex, gr, texmenu, temp, tr, seed, score)
reageTempo n (Opcoes Personagem3, skin, jogo, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Personagem3, skin, jogo, tex, gr, texmenu, temp, tr, seed, score)
reageTempo n (PerdeuJogo, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = (PerdeuJogo, jogo, skin, tex, gr, texmenu, 0, tr, seed, score)
reageTempo n (ModoJogo, j@(Jogo (Jogador (x,y)) mapa), skin, tex, gr, texmenu, temp, tr, seed, score)    
    | jogoTerminou j = (PerdeuJogo, j, skin, tex, gr, texmenu, 0, True, seed, score)
    | mod temp 120 == 0 = (ModoJogo, novoJogo, skin, tex, gr, texmenu, temp+1, tr, seed+1, score)
    | mod temp 40 == 0 = (ModoJogo, animaJogo j Parado, skin, tex, gr, texmenu, temp+1, tr, seed+1, score)
    | otherwise = (ModoJogo, (Jogo (Jogador (x,y)) mapa), skin, tex, gr, texmenu, temp+1, tr, seed+1, score) 
     where novoJogo = deslizaJogo seed (Jogo (Jogador (x,y)) mapa)

@
-}

reageTempo :: Float -> EstadoGloss -> EstadoGloss
reageTempo n (Opcoes Jogar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Jogar, jogo, skin, tex, gr, texmenu, 0, tr, seed, score) 
reageTempo n (Opcoes Sair, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Sair, jogo, skin, tex, gr, texmenu, 0, tr, seed, score)
reageTempo n (Opcoes Voltar, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Voltar, jogo, skin, tex, gr, texmenu, 0, tr, seed, score)
reageTempo n (Opcoes Personagem1, skin, jogo, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Personagem1, skin, jogo, tex, gr, texmenu, temp, tr, seed, score)
reageTempo n (Opcoes Personagem2, skin, jogo, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Personagem2, skin, jogo, tex, gr, texmenu, temp, tr, seed, score)
reageTempo n (Opcoes Personagem3, skin, jogo, tex, gr, texmenu, temp, tr, seed, score) = (Opcoes Personagem3, skin, jogo, tex, gr, texmenu, temp, tr, seed, score)
reageTempo n (PerdeuJogo, jogo, skin, tex, gr, texmenu, temp, tr, seed, score) = (PerdeuJogo, jogo, skin, tex, gr, texmenu, 0, tr, seed, score)
reageTempo n (ModoJogo, j@(Jogo (Jogador (x,y)) mapa), skin, tex, gr, texmenu, temp, tr, seed, score)    
    | jogoTerminou j = (PerdeuJogo, j, skin, tex, gr, texmenu, 0, True, seed, score)
    | mod temp 120 == 0 = (ModoJogo, novoJogo, skin, tex, gr, texmenu, temp+1, tr, seed+1, score)
    | mod temp 40 == 0 = (ModoJogo, animaJogo j Parado, skin, tex, gr, texmenu, temp+1, tr, seed+1, score)
    | otherwise = (ModoJogo, (Jogo (Jogador (x,y)) mapa), skin, tex, gr, texmenu, temp+1, tr, seed+1, score) 
     where novoJogo = deslizaJogo seed (Jogo (Jogador (x,y)) mapa)


{-|-
Framerate
-}

fr :: Int
fr = 60

{-|
Função encarregue de "rodar" o jogo
-}

main :: IO ()
main = do 
    gameOver <- loadBMP "./img/gameover.bmp"
    selPersonagem <- loadBMP "./img/selecpersonagem.bmp"
    fundoMenu <- loadBMP "./img/fundomenu.bmp"
    galinhaMenu <- loadBMP "./img/galinhamenu.bmp"
    sapoMenu <- loadBMP "./img/sapomenu.bmp"
    pinguimMenu <- loadBMP "./img/pinguimmenu.bmp"
    galinhaMenuSel <- loadBMP "./img/galinhamenuselec.bmp"
    sapoMenuSel <- loadBMP "./img/sapomenuselec.bmp"
    pinguimMenuSel <- loadBMP "./img/pinguimmenuselec.bmp"
    voltar <- loadBMP "./img/voltar.bmp"
    jogar <- loadBMP "./img/play.bmp"
    jogarSel <- loadBMP "./img/playselec.bmp"
    sair <- loadBMP "./img/quit.bmp"
    sairSel <- loadBMP "./img/quitselec.bmp"
    relva <- loadBMP "./img/relva.bmp"
    estrada <- loadBMP "./img/estrada.bmp"
    rio <- loadBMP "./img/rio.bmp"
    arvore <- loadBMP "./img/arvore.bmp"
    carroEsquerda <- loadBMP "./img/carroesquerda.bmp" 
    carroDireita <- loadBMP "./img/carrodireita.bmp"
    tronco <- loadBMP "./img/tronco2.bmp"
    galinha <- loadBMP "./img/galinha.bmp"
    sapo <- loadBMP "./img/sapo.bmp"
    pinguim <- loadBMP "./img/pinguim.bmp"
    (c, l) <- getScreenSize 
    seed <- randomRIO (1,100)
    play (InWindow "Road Runner" (div c 2, div l 2) (0,0))           -- janela onde irá correr o jogo
            black   -- cor do fundo da janela
            fr              -- frame rate
            (estadoGlossInicial   -- estado inicial
                [
                    (Nenhum, scale 0.5 0.5 relva),
                    (Nenhum, scale 0.5 0.5 estrada),
                    (Nenhum, scale 0.5 0.5 rio),
                    (Arvore, scale 0.5 0.5 arvore),
                    (Carro, scale 0.5 0.5 carroDireita),
                    (Carro, scale 0.5 0.5 carroEsquerda),
                    (Tronco, scale 0.5 0.5 tronco)
  
                ]
                [
                    ((Skin 1), scale 0.374 0.374 galinha),
                    ((Skin 2), scale 0.374 0.374 sapo),
                    ((Skin 3), scale 0.374 0.374 pinguim)
                ]
                [
                    (Opcoes Sair, scale 1.5 1.5 sairSel),
                    (Opcoes Jogar, scale 1.5 1.5 jogarSel),
                    (Opcoes Personagem1, galinhaMenuSel),
                    (Opcoes Personagem2, sapoMenuSel),
                    (Opcoes Personagem3, pinguimMenuSel),
                    (Opcoes Personagem1, galinhaMenu),
                    (Opcoes Personagem2, sapoMenu),
                    (Opcoes Personagem3, pinguimMenu),
                    (Opcoes Jogar, scale 1.2 1.2 jogar),
                    (Opcoes Sair, scale 1.2 1.2 sair),
                    (Opcoes Voltar, scale 0.4 0.4 voltar),
                    (Opcoes Voltar, scale 0.55 0.55 voltar),
                    (FundoPersonagens, scale 2 2 selPersonagem),
                    (Fundo, scale 2 2 fundoMenu),
                    (PerdeuJogo, scale 2 2 gameOver),
                    (ModoJogo, blank)
                ]
                seed
                0
            )
            desenhaEstado   -- desenha o estado do jogo
            reageEventoGloss     -- reage a um evento
            reageTempo      -- reage ao passar do tempo


