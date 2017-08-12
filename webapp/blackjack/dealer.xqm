xquery version "3.0"  encoding "UTF-8"; 
 
module namespace d = "blackjack/dealer"; 
import module namespace g = "blackjack/game" at "game.xqm"; 
import module namespace p = "blackjack/player" at "player.xqm"; 
import module namespace t = "blackjack/tools" at "tools.xqm";


(: open database blackjack, locate resource within database and navigate to its top element :)
declare variable $d:casino := db:open("blackjack")/casino;


declare %updating function d:dealerTurn($gameId as xs:string){
    d:dealerTurnHelper($gameId,0)
};

(: Calculate how many cards the dealer would draw from the stack and afterwards draw them :)
declare %updating function d:dealerTurnHelper($gameId as xs:string,$cardsDrawn as xs:integer) {
        if(d:calculateCardsValueDealer2($gameId,$cardsDrawn)<17) then
            (
            d:dealerTurnHelper($gameId,$cardsDrawn+1))
        else(
            if($cardsDrawn > 0) then
                d:dealerTurnDrawer($gameId,fn:false(),$cardsDrawn)
            else()
            
            )
};


(: this function takes a card from the stack and inserts it into the hand of the dealer :)
declare %updating function d:dealerTurnDrawer($gameId as xs:string, $hidden as xs:boolean, $drawPos as xs:integer) {
    let $game := $d:casino/game[@id=$gameId]
    
    return(
        for $i at $pos in $game/cards/card
        where $pos <= $drawPos
        return(
        insert node d:turnHiddenCard($i) into $game/dealer/hand,
        delete node $game/cards/card[$pos])
        )
    
};

(: this function takes a card from the stack and inserts it into the hand of the dealer :)
declare %updating function d:drawCardDealer($gameId as xs:string, $hidden as xs:boolean, $drawPos as xs:integer) {
    let $game := $d:casino/game[@id=$gameId]
    let $newCard := $game/cards/card[$drawPos]
  
    return (
        (: insert the new card into the dealer's hand and delete it from the stack :)
        insert node $newCard into $game/dealer/hand,
        delete node $game/cards/card[$drawPos]
    )
};

(: calculates value of dealers hand + $cardsDrawn from stack :)
declare function d:calculateCardsValueDealer2($gameId as xs:string,$cardsDrawn as xs:integer) as xs:double {
  let $game := $d:casino/game[@id=$gameId]
  
  (: the amount of cards of the dealer's hand :)
  let $amountOfCards := $cardsDrawn + fn:count($game/dealer/hand/card)
  (: number of A cards in the dealer's hand :)
  let $amountOfAces := (fn:sum(  for $card at $pos in $game/cards/card
                                where $card/value = "A" and $pos <= $cardsDrawn
                                return 1)
                                +
                       fn:sum(  for $card in $game/dealer/hand/card
                                where $card/value = "A"
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
            for $card in $game/dealer/hand/card
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


(: sum up all the values of the dealer's cards :)
(: in case of an A, decide whether value is 11 or 1 :)
declare function d:calculateCardsValueDealer($gameId as xs:string) as xs:double {
  let $game := $d:casino/game[@id=$gameId]
  
  (: the amount of cards of the dealer's hand :)
  let $amountOfCards := fn:count($game/dealer/hand/card)
  (: number of A cards in the dealer's hand :)
  let $amountOfAces := fn:sum(  for $card in $game/dealer/hand/card
                                where $card/value = "A"
                                return 1)
  (: amount of cards, which are not aces :)
  let $amountOfNotAces := $amountOfCards - $amountOfAces
  
  
  let $valueOfCardsWithoutAces :=  
        fn:sum(
            for $card in $game/dealer/hand/card
                return (
                    if (($card/value = 'J') or ($card/value = 'Q') or ($card/value = 'K')) then
                        10
                    else if ($card/value = 'A') then
                        (: do not consider the asses right now :)
                        0
                    else
                        ($card/value)
                ) 
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

(: hidden attribute of the card to turn up is set to false :)
declare function d:turnHiddenCard($card as element(card)) as element(card) {
  let $mod :=   copy $c := $card
                modify replace value of node $c/hidden with 'false'
                return $c
  return $mod
};

(: this function gets all players, who participate in this game (--> balance > 0), one open card :)
declare %updating function d:oneCardForAllPlayers($gameId as xs:string) {
    let $game := $d:casino/game[@id=$gameId]
    
    (: iterate over the players' seats of the table :)
    (: position 1 is the most left to the dealer, 5 the most right to the dealer :)
    for $player in $game/players/player
    where $player/balance > 0
        (: balance is != 0, that means a player is playing at position i :)
        (: hence, get the player a random, open card and delete it from the stack :)
        return p:drawCardPlayer($gameId, fn:false(), $player)
};

(: this function deals out the initial cards to every player and the dealer :)
declare %updating function d:dealOutInitialCards($gameId as xs:string) {
    let $true := fn:true()
    let $false := fn:false()
    
    return (d:oneCardForAllPlayers($gameId),
    
        (: after having dealt out the first cards for all players, get the dealer his first hidden card :)
        d:drawCardDealer($gameId, $true, 1),
        
        (: after the dealer got his first hidden card, get the players their second open card :)
        d:oneCardForAllPlayers($gameId),
        
        (: finally, the dealer gets his second card, but this one is open now :)
        d:drawCardDealer($gameId, $false, 2)
    )
};

(: works. delete other dealOutInitialCards if everbody agrees :)
declare %updating function d:dealOutInitialCards2($gameId as xs:string) {
    let $game := $g:casino/game[@id=$gameId]
    for $i at $pos in $game/players/player
        return (
                (: ToDo: Change order. ATM: Everbody get's two cards successive :)
                insert node d:turnHiddenCard($game/cards/card[1+(($pos - 1)*2)]) into $game/players/player[@id=$i/@id]/hand,
                delete node $game/cards/card[1+(($pos - 1)*2)],
                insert node d:turnHiddenCard($game/cards/card[2+(($pos - 1)*2)]) into $game/players/player[@id=$i/@id]/hand,
                delete node $game/cards/card[2+(($pos - 1)*2)],
                if ($pos = count($game/players/player)) then (
                    insert node d:turnHiddenCard($game/cards/card[1+($pos*2)]) into $game/dealer/hand,
                    delete node $game/cards/card[1+($pos*2)],
                    insert node $game/cards/card[2+($pos*2)] into $game/dealer/hand,
                    delete node $game/cards/card[2+($pos*2)] )
                else()
                )                 
};
