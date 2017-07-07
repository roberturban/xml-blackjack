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
  (:
   : Breach of separation of concerns between controller and model. The controller
   : should not have access to the full info about the game. We can heal this by
   : computing the secret number within the method g:insertGame.
   :)
  let $game := g:newGame($maxBet, $minBet)
  return (db:output($c:blackjackXHTML), g:insertGame($game))
};