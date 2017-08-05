xquery version "3.0"  encoding "UTF-8";

module namespace d = "blackjack/dealer";
import module namespace g = "blackjack/game" at "game.xqm";

(: open database blackjack, locate resource within database and navigate to its top element :)
declare variable $d:casino := db:open("blackjack")/casino;

(: constructors for dealer still ToDo :)

(: ToDo: testing and finishing :)
(: ToDo: What is this function meant to do? What stands its name for? Rename it :)
(:
declare %updating function d:dealerAI($gameId as xs:string) {
    if (d:calculateCardsValueDealer($gameId)<17) then (
        d:drawCardDealer($gameId,fn:false()),
        d:dealerAI($gameId)
        (: ToDo: Recursion is really wanted here!?? :)
    )
    else (
        g:checkWinningStatusAll($gameId)
    )
};
:)

(: this function takes a card from the stack and inserts it into the hand of the dealer :)
declare %updating function d:drawCardDealer($gameId as xs:string, $hidden as xs:boolean) {
    let $game := $d:casino/game[@id=$gameId]
    let $newCard :=
        if ($hidden=fn:false()) then 
            d:turnHiddenCard($game/cards/card[position()=1])
        else
            $game/cards/card[position()=1]
  
     return (insert node $newCard into $game/dealer/hand,
             delete node $game/cards/card[position()=1])
};

(: sum up all the values of the dealer's cards :)
(: in case of an A, decide whether value is 11 or 1 :)
declare function d:calculateCardsValueDealer($gameId as xs:string) as xs:integer {
  let $game := $d:casino/game[@id=$gameId]
  let $valueOfCardsTemp :=  
        fn:sum(
            for $i in $game/dealer/hand/card
            return
                if (($i/value = "J") or ($i/value = "Q") or ($i/value = "K")) then
                    10
                else if ($i/value = "A") then
                    11
                else
                    ($i/value)
         )
  let $valueOfCards :=
    if ($valueOfCardsTemp > 21) then
      fn:sum(
              for $i in $game/dealer/hand/card
              return
                  if (($i/value = "J") or ($i/value = "Q") or ($i/value = "K")) then
                      10
                  else if ($i/value = "A") then
                      1
                  else
                      ($i/value)
           )
     else
        $valueOfCardsTemp
           
  return $valueOfCards
};