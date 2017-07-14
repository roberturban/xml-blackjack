xquery version "3.0"  encoding "UTF-8";

module namespace g = "blackjack/game";
import module namespace t = "blackjack/tools" at "tools.xqm";

(: open database blackjack, locate ressource within database and navigate to its top element :)
declare variable $g:casino := db:open("blackjack")/casino;


declare function g:newGame($maxBet as xs:integer, $minBet as xs:integer, $playerNames as xs:string+) as element(game) {
  let $id := t:generateID()
  let $players := <players>
        {for $p in $playerNames
        return g:newPlayer($p)}
        </players>
  return
    <game>
      <id>{$id}</id>
      <maxBet>{$maxBet}</maxBet>
      <minBet>{$minBet}</minBet>
      <activePlayer>{$players/player[1]/id}</activePlayer>
      {$players}
      <dealer>
        <id>dealer</id>
        <hand>
          (: drawCard :)
        </hand>
      </dealer>
      {g:shuffleCards()}
    </game>
};

declare %updating function g:insertGame($game as element(game)) {
  insert node $game as first into $g:casino
};

(:due to efficiency, iterate only over matching games, which usually should be a single game :)
declare %updating function g:deleteGame($gameId as xs:integer) {
  for $game in $g:casino/game[id=$gameId]
    return delete node $game
};

declare %updating function g:setActivePlayer($gameId as xs:integer) {
  let $game := $g:casino/game[id=$gameId]
  let $players := $game/players/*
  let $playerId := $game/activePlayer/id
  return replace node $game/activePlayer/id with $players[id=$playerId/text()]/following::id[1] (: todo: if Abfrage ob letzter Spieler :)
};

declare %updating function g:bet($gameId as xs:integer, $betValue as xs:integer) {
  let $game := $g:casino/game[id=$gameId]
  let $playerId := $game/activePlayer/id
  let $newBalance := $game/players/player[id=$playerId]/balance - $betValue

  return 
    if (($betValue > $game/maxBet) or ($betValue < $game/minBet)) then (
        (: ERROR :) )
    else 
        (replace value of node $game/players/player[id=$playerId]/balance with $newBalance,
        replace value of node $game/players/player[id=$playerId]/bet with $betValue)
};

declare %updating function g:checkPlayer($gameId as xs:integer,$endOfGame as xs:integer) { (: endOfGame => 1 = ende :)
  let $game := $g:casino/game[id=$gameId]
  let $playerId := $game/activePlayer/id     
  
  let $betValue := $game/players/player[id=$playerId]/bet
  let $balanceValue := $game/players/player[id=$playerId]/balance
  
  let $valueOfCards := g:checkValue($gameId)
  let $valueOfCardsDealer := g:checkValueDealer($gameId)
  
  return ( 
        if ($endOfGame = 1) then (
            if($valueOfCards > 21) then (
                    replace value of node $game/players/player[id=$playerId]/bet with 0,
                    delete node $game/players/player[id=$playerId]/hand/*
             )
            else (
                if ($valueOfCardsDealer > $valueOfCards) then (
                    replace value of node $game/players/player[id=$playerId]/bet with 0,
                    delete node $game/players/player[id=$playerId]/hand/*
                )
                else if ($valueOfCardsDealer = $valueOfCards) then (
                    replace value of node $game/players/player[id=$playerId]/bet with ($balanceValue+$betValue),
                    replace value of node $game/players/player[id=$playerId]/bet with 0,
                    delete node $game/players/player[id=$playerId]/hand/*
                )
                else if ($valueOfCards = 21) (
                    replace value of node $game/players/player[id=$playerId]/bet with ($balanceValue+$betValue*2.5),
                    replace value of node $game/players/player[id=$playerId]/bet with 0,
                    delete node $game/players/player[id=$playerId]/hand/*
                )
                else (
                    replace value of node $game/players/player[id=$playerId]/bet with ($balanceValue+$betValue*2),
                    replace value of node $game/players/player[id=$playerId]/bet with 0,
                    delete node $game/players/player[id=$playerId]/hand/*
                )
             )
         )
        else (
            if($valueOfCards > 21) then (
                replace value of node $game/players/player[id=$playerId]/bet with 0,
                delete node $game/players/player[id=$playerId]/hand/*,
                g:setActivePlayer($gameId)
             )
            else (               
                g:setActivePlayer($gameId)
            )
         )
    )            
};

declare function g:checkValueDealer($gameId as xs:integer) {
  let $game := $g:casino/game[id=$gameId]
  let $valueOfCardsTemp :=  
        fn:sum(
            for $i in $game/dealer/hand/card
            return
                if (($i/value = "J") or ($i/value = "Q") or ($i/value = "K")) then
                    10
                else if ($i/value = "A") then (: todo: oder 1 :)
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
                  else if ($i/value = "A") then (: todo: oder 1 :)
                      1
                  else
                      ($i/value)
           )
     else
        $valueOfCardsTemp
           
  return $valueOfCards
};

declare function g:checkValue($gameId as xs:integer) {
  let $game := $g:casino/game[id=$gameId]
  let $playerId := $game/activePlayer/id
  let $valueOfCardsTemp :=  
        fn:sum(
            for $i in $game/players/player[id=$playerId]/hand/card
            return
                if (($i/value = "J") or ($i/value = "Q") or ($i/value = "K")) then
                    10
                else if ($i/value = "A") then (: todo: oder 1 :)
                    11
                else
                    ($i/value)
         )
  let $valueOfCards :=
    if ($valueOfCardsTemp > 21) then
      fn:sum(
              for $i in $game/players/player[id=$playerId]/hand/card
              return
                  if (($i/value = "J") or ($i/value = "Q") or ($i/value = "K")) then
                      10
                  else if ($i/value = "A") then (: todo: oder 1 :)
                      1
                  else
                      ($i/value)
           )
     else
        $valueOfCardsTemp
           
  return $valueOfCards
};

declare %updating function g:drawCard($gameId as xs:integer,$hidden as xs:integer) { (: 0 für aufgedeckt, 1 für versteckt :)
  let $game := $g:casino/game[id=$gameId]
  let $playerId := $game/activePlayer/id
  let $newCard :=
    if ($hidden=0) then 
        copy $c := $game/cards/card[position()=1]
        modify replace value of node $c/hidden with 'false'
        return $c
    else
        $game/cards/card[position()=1]
  
  return (insert node $newCard into $game/players/player[id=$playerId]/hand,
          delete node $game/cards/card[position()=1])
};

declare function g:shuffleCards() as element(cards) {   (: todo: bisher nur ein Deck :)
let $deck := 
    <cards>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>2</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>3</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>4</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>5</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>6</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>7</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>8</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>9</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>10</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>J</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>Q</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>K</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>diamonds</color>
        	<value>A</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>2</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>3</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>4</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>5</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>6</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>7</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>8</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>9</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>10</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>J</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>Q</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>K</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>hearts</color>
        	<value>A</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>2</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>3</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>4</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>5</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>6</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>7</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>8</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>9</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>10</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>J</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>Q</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>K</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>spades</color>
        	<value>A</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>2</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>3</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>4</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>5</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>6</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>7</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>8</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>9</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>10</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>J</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>Q</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>K</value>
        </card>
        <card>
        	<hidden>true</hidden>
        	<color>clubs</color>
        	<value>A</value>
        </card>
    </cards>

let $shuffled-deck :=
    for $i in $deck/card
    (: order by xs:string($i/value) :)
    order by t:random(count($deck/card))
    return $i
    
return 
<cards>
{$shuffled-deck}
</cards>
};

declare function g:newPlayer($name as xs:string) as element(player) {
  let $id := t:generateID()
  return
    <player>
      <id>{$id}</id>
      <bet>0</bet>
      <balance>100</balance>
      <insurance></insurance>
      <hand></hand>
      <name>{$name}</name>
    </player>
};
