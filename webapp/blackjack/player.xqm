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
        insert node d:turnHiddenCard($newCard) into $player/hand,
        delete node $game/cards/card[position()=1]
  )
};

(: this function handles the betting action of the activePlayer, as long as the bet was in the allowed range :)
declare %updating function p:bet($gameId as xs:string, $betValue as xs:integer) {
  let $game := $p:casino/game[@id=$gameId]
  let $playerId := $game/activePlayer/@id
  let $player := $game/players/player[@id=$playerId]
  let $newBalance := $player/balance - $betValue
  
  return 
    if (($betValue > $game/maxBet) or ($betValue < $game/minBet) or ($betValue > $player/balance)) then (
        (: ToDo: ERROR :)
    )
    else (
        replace value of node $player/balance with $newBalance,
        replace value of node $player/bet with $betValue,
        g:setActivePlayer($gameId)
    )
};

(: this function implements the hit action of a player :)
declare %updating function p:hit($gameId as xs:string) {
  let $game := $p:casino/game[@id=$gameId]
  let $player := $game/players/player[@id=$game/activePlayer/@id]
  (: check for < 21 :)
  let $currentCardsValue := p:calculateCardsValuePlayer($gameId, $player, 1)
  
  return
    if ($currentCardsValue <= 21) then (
        p:drawCardPlayer($gameId,fn:false(), $player)
    )
    else (
        (: ToDo: Error :)
        (p:drawCardPlayer($gameId,fn:false(), $player),
        g:setActivePlayer($gameId))
    )
};

(: this function implements the stand action of a player :)
declare %updating function p:stand($gameId as xs:string) {
  g:setActivePlayer($gameId)
};

(: this function implements the insurance action of a player :)
(: only updates if there is at least one ace in the hand of the dealer :)
(: this action must only be possible, if the first card of the dealer is an ace :)
declare %updating function p:insurance($gameId as xs:string) {
  let $game := $p:casino/game[@id=$gameId]
  let $playerId := $game/activePlayer/@id
  let $betValue := $game/players/player[@id=$playerId]/bet
  
  return (
    if(count(for $card in $game/dealer/hand/card
    where (($card/value = 'A') and ($card/hidden = 'false'))
    return 'A')>0) then
        replace value of node $game/players/player[@id=$playerId]/insurance with ($betValue div 2)
    else())
};

(: calculates value of player's hand + $cardsDrawn from stack :)
declare function p:calculateCardsValuePlayer($gameId as xs:string, $player as element(player), $cardsDrawn as xs:integer) as xs:double {
  let $game := $p:casino/game[@id=$gameId]
  
  (: the amount of cards of the player's hand :)
  let $amountOfCards := $cardsDrawn + fn:count($player/hand/card)
  (: number of A cards in the player's hand :)
  let $amountOfAces := (fn:sum(  for $card at $pos in $game/cards/card
                                where (($card/value = 'A') and ($pos <= $cardsDrawn))
                                return 1)
                                +
                       fn:sum(  for $card in $player/hand/card
                                where $card/value = 'A'
                                return 1))
  (: amount of cards, which are not aces :)
  let $amountOfNotAces := $amountOfCards - $amountOfAces
  
  
  let $valueOfCardsWithoutAces :=  
        (fn:sum(
            for $card at $pos in $game/cards/card
            where $pos <= $cardsDrawn
                return (
                    if (($card/value = 'J') or ($card/value = 'Q') or ($card/value = 'K')) then
                        10
                    else if ($card/value = 'A') then
                        (: do not consider the asses right now :)
                        0
                    else
                        ($card/value)
                        ))
                        +
         fn:sum(
            for $card in $player/hand/card
                return (
                    if (($card/value = 'J') or ($card/value = 'Q') or ($card/value = 'K')) then
                        10
                    else if ($card/value = 'A') then
                        (: do not consider the asses right now :)
                        0
                    else
                        ($card/value)
                )) 
        )
        
    let $valueGap := (21 - $valueOfCardsWithoutAces)
    
    return (
        if ($valueGap < 0) then (
            (: in this case, valueOfCardsWithoutAsses is already > 21 :)
            (: thus, return 22 as default value, because it only matters > 21 and not the exact value :)
            22
        )
        else if (($valueGap = 0) and ($amountOfAces > 0)) then (
            (: dealer is over 21 :)
            (: thus, return 22 as default value, because it only matters > 21 and not the exact value :)
            22
        )
        else if (($valueGap = 0) and ($amountOfAces = 0)) then (
            (: dealer got a Blackjack :)
            21
        )
        else if (($valueGap > 0) and ($amountOfAces = 0)) then (
            (: dealer has no asses, but < 21 :)
            (: valueOfCardsWithoutAsses is the overallValue, because dealer has no asses :)
            $valueOfCardsWithoutAces
        )
        else (
            (: this is the case for (($valueGap > 0) and ($amountOfAsses > 0)) :)
            (: as amountOfAsses cannot be < 0, this is the last "outer" case :)
            
            (: adding asses might still be possible, hence check for the appropriate values (11 or 1) :)  
            if ($valueGap = $amountOfAces) then (
                (: in this case, each As has to be calculated as 1 for a Blackjack of the dealer :)
                21
            )
            else if ($valueGap < $amountOfAces) then (
                (: even if each As goes with value 1, the dealer will end up with a sum > 21 :)
                (: thus, return 22 as default value, because it only matters > 21 and not the exact value :)
                22
            )
            else (
                (: this is the case, where $valueGap > $amountOfAsses :)
                (: now check, which single As has to count as 11 or as 1 :)
                if ($valueGap < 11) then (
                    (: asses can only count as 1 each :)
                    (: can be <= 21, but can also be > 21 :)
                    ($valueOfCardsWithoutAces + $amountOfAces)
                )
                else if (($valueGap = 11) and ($amountOfAces > 1)) then (
                    (: asses can only count as 1 each :)
                    (: can be <= 21, but can also be > 21 :)
                    ($valueOfCardsWithoutAces + $amountOfAces)
                )
                else if (($valueGap = 11) and ($amountOfAces = 1)) then (
                    (: single As counts 11 :)
                    (: dealer got a Blackjack :)
                    21
                )
                else (
                    (: this is the case, where (($valueGap > 11) and ($amountOfAsses > 0)) is true :)
                    (: more than one As can never be counted as 11, as one would be over 21 automatically otherwise (2*11 = 22) :)
                    
                    (: try out if it's better to count one As as 11 and all the others as 1, or if it's better to count all asses as 1 :)
                    if (($valueOfCardsWithoutAces + 11 + ($amountOfAces - 1)) <= 21) then (
                        ($valueOfCardsWithoutAces + 11 + ($amountOfAces - 1))
                    )
                    else (
                        (: can be <= 21, but can also be > 21 :)
                        ($valueOfCardsWithoutAces + $amountOfAces)
                    )
                )
            )
        )
    )
};