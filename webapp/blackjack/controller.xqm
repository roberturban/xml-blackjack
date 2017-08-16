xquery version "3.0"  encoding "UTF-8";

module namespace c = "blackjack/controller";

declare namespace xslt = "http://basex.org/modules/xslt";
import module namespace g = "blackjack/game" at "game.xqm";
import module namespace p = "blackjack/player" at "player.xqm";
import module namespace d = "blackjack/dealer" at "dealer.xqm";
import module namespace request = "http://exquery.org/ns/request";

declare variable $c:index := doc("../static/blackjack/index.html");
declare variable $c:initGame := doc("initGame.html");
declare variable $c:casinoCollection := db:open("blackjack");
declare variable $c:blackjackIMG := doc("/static/blackjack/img/blackjack.png");
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

  let $maxBet := (request:parameter("maxBet"))
  let $minBet := (request:parameter("minBet"))
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

  (: naming conventiones are not restrictive :)

  (: for the balance, only positive values are allowed :)
  (: otherwise, the balance is set to 0 by default, which means player cannot play :)
  let $balancesChecked :=
        (for $i in $balances
            return (
                if (fn:not(c:is-a-number($i))) then (
                    0
                )
                else (
                    if ($i > 0) then (
                        (: consider the integer range +-9223372036854775807:)
                        if ($i <= 1000000000) then (
                            $i
                        )
                        else (
                            1000000000
                        )
                    )
                    else (
                        0
                    )
                )
            )
        )

  let $maxBetChecked :=
        if (fn:not(c:is-a-number($maxBet))) then (
            100
        )
        else (
            if ($maxBet > 0) then (
                (: consider the integer range +-9223372036854775807 :)
                if ($maxBet <= 1000000000) then (
                    $maxBet
                )
                else (
                    1000000000
                )
            )
            else (
                100
            )
        )

  let $minBetChecked :=
        if (fn:not(c:is-a-number($minBet))) then (
            1
        )
        else (
            if ($minBet > 1) then (
                (: consider the integer range :)
                if ($minBet <= $maxBetChecked) then (
                    $minBet
                )
                else (
                    1
                )
            )
            else (
                1
            )
        )

  let $game := g:createNewGame($maxBetChecked,$minBetChecked,$playerNames,$balancesChecked)

  return (db:output(c:redirectToTransformator($game/@id)), g:insertGame($game))
};

(: this function checks whether the parameter is a number :)
(: copied from http://www.xqueryfunctions.com/xq/functx_is-a-number.html :)
declare function c:is-a-number ( $value as xs:anyAtomicType? )  as xs:boolean {
   string(number($value)) != 'NaN'
};

(: redirects to the Transformator-URL :)
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
  if ($c:casinoCollection/casino/game[@id = $gameId]/step = 'bet') then (
    (db:output(c:redirectToTransformator($gameId)),p:bet($gameId,$betValue))
  ) else ( )
};

(: this funtion calls the hit action of the activePlayer :)
declare
%updating
%rest:path("/blackjack/hit/{$gameId}")
%rest:GET
function c:hit($gameId as xs:string) {
  if ($c:casinoCollection/casino/game[@id = $gameId]/step = 'play') then (
    (db:output(c:redirectToTransformator($gameId)),p:hit($gameId))
  ) else ( )
};

(: this funtion calls the stand action of the activePlayer :)
declare
%updating
%rest:path("/blackjack/stand/{$gameId}")
%rest:GET
function c:stand($gameId as xs:string) {
  if ($c:casinoCollection/casino/game[@id = $gameId]/step = 'play') then (
    (db:output(c:redirectToTransformator($gameId)),p:stand($gameId))
  ) else ( )
};

(: this funtion calls the insurance action of the activePlayer :)
declare
%updating
%rest:path("/blackjack/insurance/{$gameId}")
%rest:GET
function c:insurance($gameId as xs:string) {
  if ($c:casinoCollection/casino/game[@id = $gameId]/step = 'play') then (
    (db:output(c:redirectToTransformator($gameId)),p:insurance($gameId))
  ) else ( )
};

(: this funtion calls the checkWinningStatusAll function, in order to check, which players won and lost :)
(: executed on clicking the "Go on..."-Button :)
declare
%updating
%rest:path("/blackjack/finishing/{$gameId}")
%rest:GET
function c:finishing($gameId as xs:string) {
  if ($c:casinoCollection/casino/game[@id = $gameId]/step = 'finishing') then (
    (db:output(c:redirectToTransformator($gameId)),g:checkWinningStatusAll($gameId))
  ) else ( )
};


(: this funtion calls the dealOutInitialCards function :)
declare
%updating
%rest:path("/blackjack/deal/{$gameId}")
%rest:GET
function c:deal($gameId as xs:string) {
  d:dealOutInitialCards($gameId)
};

(: this funtion calls the dealerTurn function, after all players have been served :)
declare
%updating
%rest:path("/blackjack/turn/{$gameId}")
%rest:GET
function c:turn($gameId as xs:string) {
  d:dealerTurn($gameId)
};

(: this funtion calls the deleteGame function :)
declare
%updating
%rest:path("/blackjack/deleteGame/{$gameId}")
%rest:GET
function c:deleteGame($gameId as xs:string) {
  g:deleteGame($gameId)
};
