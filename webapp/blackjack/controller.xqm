xquery version "3.0"  encoding "UTF-8";

module namespace c = "blackjack/controller";

declare namespace xslt = "http://basex.org/modules/xslt";
import module namespace g = "blackjack/game" at "game.xqm";
import module namespace request = "http://exquery.org/ns/request";

declare variable $c:index := doc("index.html");
declare variable $c:init := doc("init.html");
declare variable $c:casinoCollection := db:open("blackjack");
declare variable $c:blackjackXHTML := doc("blackjackXHTML.xml");
declare variable $c:xsltTransformator := doc("xsltTransformator.xsl");



(: Display the start screen to the player. :)
declare
%rest:path("/blackjack")
%rest:GET
function c:start() {
  $c:index
};



(: Create input start form for player names, maxBet and minBet :)
declare
%rest:path("/blackjack/initGame")
%rest:GET
function c:initGame() {
    $c:init
};



(: Create new game instance from input form and call write into database  > then redirect to transformator:)
declare
%updating
%rest:path("/blackjack/form")
%rest:GET
function c:handleInit() {
  let $maxBet := request:parameter("maxBet")
  let $minBet := request:parameter("minBet")
  let $playerNames := 
      (request:parameter("playername1", ""),
      request:parameter("playername2", ""),
      request:parameter("playername3", ""),
      request:parameter("playername4", ""),
      request:parameter("playername5", ""))
  let $game := g:newGame($maxBet, $minBet,$playerNames)
  (: Replace with redirect to transformator :)
  return (db:output($c:blackjackXHTML), g:insertGame($game))
};



(:
declare
%updating
%rest:path("/blackjack/newGame")
%rest:GET
function c:newGame() {
  let $maxBet := 100
  let $minBet := 10
  let $playerNames := ("Franz","Peter","Hugo","Krause")
  let $game := g:newGame($maxBet, $minBet,$playerNames)
  return (db:output($c:blackjackXHTML), g:insertGame($game))
};
:)


(: Transform the game session from the database to HTML using XSLT. :)
declare 
%rest:path('/blackjack/transform/{$gameId}')
%rest:GET %output:media-type("text/html") 
function c:transformToHtml($gameId as xs:string) {
  let $game := $c:casinoCollection/casino/game[@id=$gameId]
  return xslt:transform-text($game, $c:xsltTransformator)
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