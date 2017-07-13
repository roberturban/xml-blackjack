xquery version "3.0"  encoding "UTF-8";

module namespace c = "blackjack/controller";
import module namespace g = "blackjack/game" at "game.xqm";

declare variable $c:blackjackXHTML := doc("blackjackXHTML.xml");

declare
%rest:path("/blackjack")
%rest:GET
function c:start() {
  $c:blackjackXHTML
};

declare
%updating
%rest:path("/blackjack/newGame")
%rest:GET
function c:newGame() {
  let $maxBet := 100
  let $minBet := 10
  let $playerNames := ("Hans","Franz","Peter","Hugo","Krause")
  
  (:
   : Breach of separation of concerns between controller and model. The controller
   : should not have access to the full info about the game. We can heal this by
   : computing the secret number within the method g:insertGame.
   :)
  let $game := g:newGame($maxBet, $minBet,$playerNames)
  return (db:output($c:blackjackXHTML), g:insertGame($game))
};

declare
%updating
%rest:path("/blackjack/bet")   (: Platzhalter zum testen bis Button implementiert :)
%rest:GET
function c:bet() {  
  let $bet := 20 (: todo: dynamic :)
  let $gameId := 123
  
  return (g:bet($gameId,$bet))
};

declare
%updating
%rest:path("/blackjack/hit")   (: Platzhalter zum testen bis Button implementiert :)
%rest:GET
function c:hit() {  
  let $gameId := 123
  
  (: drawCard und prüfen ob über 21 :)
  
  return ()
};

declare
%updating
%rest:path("/blackjack/stand")   (: Platzhalter zum testen bis Button implementiert :)
%rest:GET
function c:stand() {  
  let $gameId := 123
  
  return (g:setActivePlayer($gameId))
};