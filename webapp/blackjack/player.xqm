xquery version "3.0"  encoding "UTF-8";

module namespace p = "blackjack/player";
import module namespace d = "blackjack/dealer" at "dealer.xqm";
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

(: this function takes a card from the stack and inserts it into the hand of the respective player :)
declare %updating function p:drawCardPlayer($gameId as xs:string, $hidden as xs:boolean, $player as element(player)) {
  let $game := $p:casino/game[@id=$gameId]
  let $newCard := $game/cards/card[position()=1]
  
  return (
        (: insert the newCard into the player's hand and delelte it from the stack :)
        d:turnHiddenCard($newCard),
        insert node $newCard into $player/hand,
        delete node $game/cards/card[position()=1]
  )
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
declare %updating function p:hit($gameId as xs:string) {
  let $game := $p:casino/game[@id=$gameId]
  let $player := $game/players/player[@id=$game/activePlayer/@id]
  (: check for < 21 :)
  let $currentCardsValue := p:calculateCardsValuePlayer($player)
  
  return
    if ($currentCardsValue < 21) then (
        p:drawCardPlayer($gameId,fn:false(), $player)
    )
    else (
        (: ToDo: Error :)
    )
};

(: this function implements the stand action of a player :)
declare %updating function p:stand($gameId as xs:string) {
  let $false := fn:false()
  return g:checkWinningStatus($gameId,$false)
};

(: this function implements the insurance action of a player :)
(:declare %updating function p:insurance($gameId as xs:string) {
  (: ToDo: implement insurance :)
};:)

(: sum up all the values of a player's cards :)
(: in case of an A, decide whether value is 11 or 1 :)
declare function p:calculateCardsValuePlayer($player as element(player)) as xs:integer {
  
  (: the amount of cards of the player's hand :)
  let $amountOfCards := fn:count($player/hand/card)
  (: number of A cards in the player's hand :)
  let $amountOfAsses := fn:count($player/hand/card/@value='A')
  (: amount of cards, which are not asses :)
  let $amountOfNotAsses := $amountOfCards - $amountOfAsses
  
  
  let $valueOfCardsWithoutAsses :=  
        fn:sum(
            for $card in $player/hand/card
                return (
                    if (($card/@value = 'J') or ($card/@value = 'Q') or ($card/@value = 'K')) then
                        10
                    else if ($card/@value = 'A') then
                        (: do not consider the asses right now :)
                        0
                    else
                        ($card/@value)
                ) 
        )
        
    let $valueGap := (21 - $valueOfCardsWithoutAsses)
    
    return (
        if ($valueGap < 0) then (
            (: in this case, valueOfCardsWithoutAsses is already > 21 :)
            (: thus, return 22 as default value, because it only matters > 21 and not the exact value :)
            22
        )
        else if (($valueGap = 0) and ($amountOfAsses > 0)) then (
            (: player is over 21 :)
            (: thus, return 22 as default value, because it only matters > 21 and not the exact value :)
            22
        )
        else if (($valueGap = 0) and ($amountOfAsses = 0)) then (
            (: player got a Blackjack :)
            21
        )
        else if (($valueGap > 0) and ($amountOfAsses = 0)) then (
            (: player has no asses, but < 21 :)
            (: valueOfCardsWithoutAsses is the overallValue, because player has no asses :)
            $valueOfCardsWithoutAsses
        )
        else (
            (: this is the case for (($valueGap > 0) and ($amountOfAsses > 0)) :)
            (: as amountOfAsses cannot be < 0, this is the last "outer" case :)
            
            (: adding asses might still be possible, hence check for the appropriate values (11 or 1) :)  
            if ($valueGap = $amountOfAsses) then (
                (: in this case, each As has to be calculated as 1 for a Blackjack of the player :)
                21
            )
            else if ($valueGap < $amountOfAsses) then (
                (: even if each As goes with value 1, the player will end up with a sum > 21 :)
                (: thus, return 22 as default value, because it only matters > 21 and not the exact value :)
                22
            )
            else (
                (: this is the case, where $valueGap > $amountOfAsses :)
                (: now check, which single As has to count as 11 or as 1 :)
                if ($valueGap < 11) then (
                    (: asses can only count as 1 each :)
                    (: can be <= 21, but can also be > 21 :)
                    ($valueOfCardsWithoutAsses + $amountOfAsses)
                )
                else if (($valueGap = 11) and ($amountOfAsses > 1)) then (
                    (: asses can only count as 1 each :)
                    (: can be <= 21, but can also be > 21 :)
                    ($valueOfCardsWithoutAsses + $amountOfAsses)
                )
                else if (($valueGap = 11) and ($amountOfAsses = 1)) then (
                    (: single As counts 11 :)
                    (: player got a Blackjack :)
                    21
                )
                else (
                    (: this is the case, where (($valueGap > 11) and ($amountOfAsses > 0)) is true :)
                    (: more than one As can never be counted as 11, as one would be over 21 automatically otherwise (2*11 = 22) :)
                    
                    (: try out if it's better to count one As as 11 and all the others as 1, or if it's better to count all asses as 1 :)
                    if (($valueOfCardsWithoutAsses + 11 + ($amountOfAsses - 1)) <= 21) then (
                        ($valueOfCardsWithoutAsses + 11 + ($amountOfAsses - 1))
                    )
                    else (
                        (: can be <= 21, but can also be > 21 :)
                        ($valueOfCardsWithoutAsses + $amountOfAsses)
                    )
                )
            )
        )
    )
};