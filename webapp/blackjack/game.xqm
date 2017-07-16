xquery version "3.0"  encoding "UTF-8";

module namespace g = "blackjack/game";
import module namespace t = "blackjack/tools" at "tools.xqm";

(: open database blackjack, locate ressource within database and navigate to its top element :)
declare variable $g:casino := db:open("blackjack")/casino;

(: this function creates a new game instance, with players' names and boundaries of bets as parameters :)
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
          (: ToDo: drawCard for dealer :)
        </hand>
      </dealer>
      {g:shuffleCards()}
    </game>
};

(: this function inserts a new game instance into the casino server :)
declare %updating function g:insertGame($game as element(game)) {
  insert node $game as first into $g:casino
};

(: this function deletes a game instance from the casino server :)
(: the game instance to be deleted is referenced by its gameId :)
(:due to efficiency, iterate only over matching games, which usually should be a single game :)
declare %updating function g:deleteGame($gameId as xs:integer) {
  for $game in $g:casino/game[id=$gameId]
    return delete node $game
};

(: this function sets the active player, who is the one to take action :)
(: initially always is the 1st player (the one on the very right of the table (left to the dealer) :)
declare %updating function g:setActivePlayer($gameId as xs:integer) {
  let $game := $g:casino/game[id=$gameId]
  let $players := $game/players/*
  let $playerId := $game/activePlayer/@id
  return replace node $game/activePlayer/@id with $players[id=$playerId/text()]/following::id[1] (: ToDo: check, if it was the last player :)
  (: Note: why ...following::id[1] ? :)
};

(: this function handles the betting action of the activePlayer, as long as the bet was in the allowed range :)
declare %updating function g:bet($gameId as xs:integer, $betValue as xs:integer) {
  let $game := $g:casino/game[id=$gameId]
  let $playerId := $game/activePlayer/@id
  let $newBalance := $game/players/player[id=$playerId]/balance - $betValue
  
  return 
    if (($betValue > $game/maxBet) or ($betValue < $game/minBet)) then (
        (: ToDo: ERROR :) )
    else 
        (replace value of node $game/players/player[id=$playerId]/balance with $newBalance,
        replace value of node $game/players/player[id=$playerId]/bet with $betValue)
};

(: this function checks wether the activePlayer or the dealer wins this round :)
(: ToDo: before calling this function, it has to be ensure that the dealer is >= 17 :)
declare %updating function g:checkWinningStatus($gameId as xs:integer,$endOfGame as xs:boolean) {
  let $game := $g:casino/game[id=$gameId]
  let $playerId := $game/activePlayer/@id    
  
  let $betValue := $game/players/player[id=$playerId]/bet
  let $balanceValue := $game/players/player[id=$playerId]/balance
  
  let $valueOfCardsPlayer := g:calculateCardsValuePlayer($gameId)
  let $valueOfCardsDealer := g:calculateCardsValueDealer($gameId)
  
  return ( 
        if ($endOfGame = true) then (
            if($valueOfCardsPlayer > 21) then (
                (: in this case, the player lost anyways :)
                replace value of node $game/players/player[id=$playerId]/bet with 0,
                delete node $game/players/player[id=$playerId]/hand/*
            )
            else (
                (: check, whether dealer is over 21 or a tie :)
                if ($valueOfCardsDealer > 21 | ($valueOfCardsDealer = $valueOfCardsPlayer)) then (
                    (: EYERY player wins and gets back his/her bet :)
                    (: even in case dealer and player both have a BlackJack, the player only gets back his/her bet :)
                    replace value of node $game/players/player[id=$playerId]/bet with ($balanceValue+$betValue),
                    replace value of node $game/players/player[id=$playerId]/bet with 0,
                    delete node $game/players/player[id=$playerId]/hand/*
                )
                (: dealer and player are <= 21 and no tie :)
                (: therefore, card values of player and dealer need to be compared against each other :)
                else if ($valueOfCardsDealer > $valueOfCardsPlayer) then (
                    (: player loses :)
                    replace value of node $game/players/player[id=$playerId]/bet with 0,
                    delete node $game/players/player[id=$playerId]/hand/*
                )
                else if ($valueOfCardsPlayer = 21) then (
                    (: player got a BlackJack:)
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
            if($valueOfCardsPlayer > 21) then (
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

(: sum up all the values of the dealer's cards :)
(: in case of an A, decide whether value is 11 or 1 :)
declare function g:calculateCardsValueDealer($gameId as xs:integer) {
  let $game := $g:casino/game[id=$gameId]
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

(: sum up all the values of a player's cards :)
(: in case of an A, decide whether value is 11 or 1 :)
declare function g:calculateCardsValuePlayer($gameId as xs:integer) {
  let $game := $g:casino/game[id=$gameId]
  let $playerId := $game/activePlayer/@id
  let $valueOfCardsTemp :=  
        fn:sum(
            for $i in $game/players/player[id=$playerId]/hand/card
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
              for $i in $game/players/player[id=$playerId]/hand/card
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

(: this function takes a card from the stack and inserts it to a player's hand :)
(: ToDo: a function, which gives a card to the dealer has to be implemented as well :)
declare %updating function g:drawCardPlayer($gameId as xs:integer,$hidden as xs:boolean) {
  let $game := $g:casino/game[id=$gameId]
  let $playerId := $game/activePlayer/@id
  let $newCard :=
    if ($hidden=true) then 
        copy $c := $game/cards/card[position()=1]
        modify replace value of node $c/hidden with 'false'
        return $c
    else
        $game/cards/card[position()=1]
  
  return (insert node $newCard into $game/players/player[id=$playerId]/hand,
          delete node $game/cards/card[position()=1])
};

(: this function works on a single deck and shuffles it randomly :)
(: ToDo: create 6 decks and not only 1 :)
declare function g:shuffleCards() as element(cards) {
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

(: this function creates a new player with a name :)
declare function g:newPlayer($name as xs:string) as element(player) {
  let $id := t:generateID()
  return
    <player>
      <id>{$id}</id>
      <bet>0</bet>
      <balance>100</balance>
      (: ToDo: balance has to be entered manually :)
      <insurance></insurance>
      <hand></hand>
      <name>{$name}</name>
    </player>
};
