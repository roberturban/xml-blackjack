xquery version "3.0"  encoding "UTF-8";

module namespace c = "blackjack/controller";

declare namespace xslt = "http://basex.org/modules/xslt";
import module namespace g = "blackjack/game" at "game.xqm";
import module namespace p = "blackjack/player" at "player.xqm";
import module namespace d = "blackjack/dealer" at "dealer.xqm";
import module namespace request = "http://exquery.org/ns/request";

declare variable $c:index := doc("index.html");
declare variable $c:initGame := doc("initGame.html");
declare variable $c:casinoCollection := db:open("blackjack");
declare variable $c:blackjackIMG := doc("img/blackjack.png");
declare variable $c:xsltTransformator := doc("xsltTransformator.xsl");

(: this function displays the start screen to the player :)
declare
%rest:path("/blackjack")
%rest:GET
function c:start() {
  $c:index
};

(: this function creates the input start form for player names, maxBet and minBet :)
declare
%rest:path("/blackjack/initGame")
%rest:GET
function c:initGame() {
    $c:initGame
};

(: this function creates a new game instance from input form and call write into database :)
(: then redirect to transformator :)
declare
%updating
%rest:path("/blackjack/form")
%rest:GET
function c:handleInit() {
  let $maxBet := xs:integer(request:parameter("maxBet"))
  let $minBet := xs:integer(request:parameter("minBet"))
  let $playerNames :=
      (request:parameter("playername1", ""),
      request:parameter("playername2", ""),
      request:parameter("playername3", ""),
      request:parameter("playername4", ""),
      request:parameter("playername5", ""))
  let $balances :=
      (request:parameter("balance1", ""),
      request:parameter("balance2", ""),
      request:parameter("balance3", ""),
      request:parameter("balance4", ""),
      request:parameter("balance5", ""))
  
  let $playerNamesChecked :=
        (for $i in $playerNames
        where $i != ""
        return $i)
  let $balancesChecked :=
        (for $i in $balances
        return(
        if  (fn:number($i)) then
            $i
        else
            0
        ))
  let $minBetChecked :=
        (if ($minBet < 0) then
            0
        else
            $minBet)
  let $maxBetChecked :=
        (if ($maxBet < 1) then
            1
        else
            $maxBet)
        
  let $game := g:createNewGame($maxBetChecked,$minBetChecked,$playerNamesChecked,$balancesChecked)

  return (db:output(c:redirectToTransformator($game/@id)), g:insertGame($game))
};

(: Redirects to the Transformator-URL :)
declare function c:redirectToTransformator($gameId as xs:string) {
  let $url := fn:concat("/blackjack/transform/", $gameId)
  return web:redirect($url)
};

(: this function transforms the game session from the database to HTML using XSLT :)
declare
%rest:path('/blackjack/transform/{$gameId}')
%rest:GET
%output:media-type("text/html")
function c:transformToHtml($gameId as xs:string) {
  let $game := $c:casinoCollection/casino/game[@id=$gameId]
  return xslt:transform-text($game, $c:xsltTransformator)
};


(: this funtion calls the bet action of the activePlayer :)
declare
%updating
%rest:path("/blackjack/bet/{$gameId}/{$betValue}")
%rest:GET
function c:bet($gameId as xs:string, $betValue as xs:integer) {
  p:bet($gameId,$betValue)
};

(: this funtion calls the hit action of the activePlayer :)
declare
%updating
%rest:path("/blackjack/hit/{$gameId}")
%rest:GET
function c:hit($gameId as xs:string) {
  p:hit($gameId)
};

(: this funtion calls the stand action of the activePlayer :)
(:declare
%updating
%rest:path("/blackjack/stand/{$gameId}")
%rest:GET
function c:stand($gameId as xs:string) {
  p:stand($gameId)
};:)

(: this funtion calls the insurance action of the activePlayer :)
declare
%updating
%rest:path("/blackjack/insurance/{$gameId}")
%rest:GET
function c:insurance($gameId as xs:string) {
  p:insurance($gameId)
};


(: this funtion calls the insurance action of the activePlayer :)
declare
%updating
%rest:path("/blackjack/deal/{$gameId}")
%rest:GET
function c:deal($gameId as xs:string) {
  d:dealOutInitialCards($gameId)
};

(: this funtion calls the insurance action of the activePlayer :)
declare
%updating
%rest:path("/blackjack/turn/{$gameId}")
%rest:GET
function c:turn($gameId as xs:string) {
  d:dealerTurn($gameId)
};