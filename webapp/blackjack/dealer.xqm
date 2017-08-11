xquery version "3.0"  encoding "UTF-8"; 
 
module namespace d = "blackjack/dealer"; 
import module namespace g = "blackjack/game" at "game.xqm"; 
import module namespace p = "blackjack/player" at "player.xqm"; 
import module namespace t = "blackjack/tools" at "tools.xqm";

(: constructors for dealer still ToDo (?) :)

(: open database blackjack, locate resource within database and navigate to its top element :)
declare variable $d:casino := db:open("blackjack")/casino;

(: this function takes a card from the stack and inserts it into the hand of the dealer :)
declare %updating function d:drawCardDealer($gameId as xs:string, $hidden as xs:boolean) {
    let $game := $d:casino/game[@id=$gameId]
    let $newCard := $game/cards/card[position()=1]
  
    return (
        (: insert the new card into the dealer's hand and delete it from the stack :)
        insert node $newCard into $game/dealer/hand,
        delete node $game/cards/card[position()=1]
    )
};

(: sum up all the values of the dealer's cards :)
(: in case of an A, decide whether value is 11 or 1 :)
declare function d:calculateCardsValueDealer($gameId as xs:string) as xs:integer {
  let $game := $d:casino/game[@id=$gameId]
  
  (: the amount of cards of the dealer's hand :)
  let $amountOfCards := fn:count($game/dealer/hand/card)
  (: number of A cards in the dealer's hand :)
  let $amountOfAsses := fn:count($game/dealer/hand/card/@value='A')
  (: amount of cards, which are not asses :)
  let $amountOfNotAsses := $amountOfCards - $amountOfAsses
  
  
  let $valueOfCardsWithoutAsses :=  
        fn:sum(
            for $card in $game/dealer/hand/card
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
            (: dealer is over 21 :)
            (: thus, return 22 as default value, because it only matters > 21 and not the exact value :)
            22
        )
        else if (($valueGap = 0) and ($amountOfAsses = 0)) then (
            (: dealer got a Blackjack :)
            21
        )
        else if (($valueGap > 0) and ($amountOfAsses = 0)) then (
            (: dealer has no asses, but < 21 :)
            (: valueOfCardsWithoutAsses is the overallValue, because dealer has no asses :)
            $valueOfCardsWithoutAsses
        )
        else (
            (: this is the case for (($valueGap > 0) and ($amountOfAsses > 0)) :)
            (: as amountOfAsses cannot be < 0, this is the last "outer" case :)
            
            (: adding asses might still be possible, hence check for the appropriate values (11 or 1) :)  
            if ($valueGap = $amountOfAsses) then (
                (: in this case, each As has to be calculated as 1 for a Blackjack of the dealer :)
                21
            )
            else if ($valueGap < $amountOfAsses) then (
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
                    ($valueOfCardsWithoutAsses + $amountOfAsses)
                )
                else if (($valueGap = 11) and ($amountOfAsses > 1)) then (
                    (: asses can only count as 1 each :)
                    (: can be <= 21, but can also be > 21 :)
                    ($valueOfCardsWithoutAsses + $amountOfAsses)
                )
                else if (($valueGap = 11) and ($amountOfAsses = 1)) then (
                    (: single As counts 11 :)
                    (: dealer got a Blackjack :)
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

(: hidden attribute of the card to turn up is set to false :)
declare %updating function d:turnHiddenCard($card as element(card)) {
  replace value of node $card/hidden/text() with 'false'
};

(: this function gets all players, who participate in this game (--> balance > 0), one open card :)
declare %updating function d:oneCardForAllPlayers($gameId as xs:string) {
    let $game := $d:casino/game[@id=$gameId]
    
    (: iterate over the players' seats of the table :)
    (: position 1 is the most left to the dealer, 5 the most right to the dealer :)
    for $player in $game/players/player
    where $player/@balance != 0
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
        d:drawCardDealer($gameId, $true),
        
        (: after the dealer got his first hidden card, get the players their second open card :)
        d:oneCardForAllPlayers($gameId),
        
        (: finally, the dealer gets his second card, but this one is open now :)
        d:drawCardDealer($gameId, $false)
    )
};