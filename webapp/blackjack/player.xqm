xquery version "3.0"  encoding "UTF-8";

module namespace p = "blackjack/player";
import module namespace g = "blackjack/game" at "game.xqm";
import module namespace t = "blackjack/tools" at "tools.xqm";

(: open database blackjack, locate resource within database and navigate to its top element :)
declare variable $p:casino := db:open("blackjack")/casino;

(: further constructors for player still ToDo :)

(: this function creates a new player with a name :)
declare function p:newPlayer($name as xs:string, $balance as xs:integer) as element(player) {
  let $id := t:generateID()
  return
    <player id = "{$id}">
      <bet>0</bet>
      <balance>{$balance}</balance>
      <insurance></insurance>
      <hand></hand>
      <name>{$name}</name>
    </player>
};

(: this function takes a card from the stack and inserts it into the hand of the activeplayer :)
declare %updating function p:drawCardPlayer($gameId as xs:string, $hidden as xs:boolean) {
  let $game := $p:casino/game[@id=$gameId]
  let $playerId := $game/activePlayer/@id
  let $newCard :=
    if ($hidden=fn:false()) then 
        g:turnHiddenCard($game/cards/card[position()=1])
    else
        $game/cards/card[position()=1]
  
  return (insert node $newCard into $game/players/player[@id=$playerId]/hand,
          delete node $game/cards/card[position()=1])
};

(: this function handles the betting action of the activePlayer, as long as the bet was in the allowed range :)
declare %updating function p:bet($gameId as xs:string, $betValue as xs:integer) {
  let $game := $p:casino/game[@id=$gameId]
  let $playerId := $game/activePlayer/@id
  let $newBalance := $game/players/player[@id=$playerId]/balance - $betValue
  
  return 
    if (($betValue > $game/maxBet) or ($betValue < $game/minBet)) then (
        (: ToDo: ERROR :)
    )
    else (
        replace value of node $game/players/player[@id=$playerId]/balance with $newBalance,
        replace value of node $game/players/player[@id=$playerId]/bet with $betValue
    )
};

(: this function implements the hit action of a player :)
declare fucntion p:hit($gameId as xs:string)) {
  (: Check for < 21 :)
  let $currentCardsValue := p:calculateCardsValuePlayer()
  
  return
    if ($currentCardsValue < 21) then (
        p:drawCardPlayer($gameId,fn:false())
    )
    else (
        (: ToDo: Error :)
    )
}

(: this function implements the stand action of a player :)
declare fucntion p:stand($gameId as xs:string) {
  return g:checkWinningStatus($gameId,fn:false())
}

(: this function implements the insurance action of a player :)
declare fucntion p:insurance($gameId as xs:string) {
  (: ToDo: implement insurance :)
}

(: sum up all the values of a player's cards :)
(: in case of an A, decide whether value is 11 or 1 :)
declare function p:calculateCardsValuePlayer($gameId as xs:string) as xs:integer {
  let $game := $p:casino/game[@id=$gameId]
  let $playerId := $game/activePlayer/@id
  let $valueOfCardsTemp :=  
        fn:sum(
            for $i in $game/players/player[@id=$playerId]/hand/card
            return
                if (($i/value = "J") or ($i/value = "Q") or ($i/value = "K")) then
                    10
                else if ($i/value = "A") then
                    11
                else
                    ($i/value)
         )
  let $valueOfCards :=
    if ($valueOfCardsTemp > 21) then (
      fn:sum(
              for $i in $game/players/player[@id=$playerId]/hand/card
              return
                  if (($i/value = "J") or ($i/value = "Q") or ($i/value = "K")) then
                      10
                  else if ($i/value = "A") then
                      1
                  else
                      ($i/value)
        )
     )
     else
        $valueOfCardsTemp
           
  return $valueOfCards
};