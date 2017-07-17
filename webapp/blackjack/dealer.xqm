xquery version "3.0"  encoding "UTF-8";

module namespace d = "blackjack/dealer";
import module namespace g = "blackjack/game" at "game.xqm";
import module namespace t = "blackjack/tools" at "tools.xqm";

(: open database blackjack, locate ressource within database and navigate to its top element :)
declare variable $d:casino := db:open("blackjack")/casino;

(: hidden value is set to false :)
declare %updating function d:turnHiddenCard($card as element(card)) {
  replace value of node $card//@hidden with 'false'
};

(: ToDo: testing and finishing :)
declare %updating function d:dealerAI($gameId as xs:string){
    if (g:calculateCardsValueDealer($gameId)<17) then (
        g:drawCardDealer($gameId,fn:false()),
        d:dealerAI($gameId)
        )
    else (
        d:checkWinningStatusAll($gameId)
        )
};

(: ToDo: testing and finishing :)
declare %updating function d:checkWinningStatusAll($gameId as xs:string){
    let $game := $g:casino/game[@id=$gameId]
    for $i in $game/players/player
    return (g:checkWinningStatus($gameId,fn:true()),
            g:setActivePlayer($gameId))
};

(: constructors for dealer still ToDo :)