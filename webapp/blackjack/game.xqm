xquery version "3.0"  encoding "UTF-8";

module namespace g = "blackjack/game";
import module namespace t = "blackjack/tools" at "tools.xqm";
import module namespace p = "blackjack/player" at "player.xqm";
import module namespace d = "blackjack/dealer" at "dealer.xqm";

(: open database blackjack, locate resource within database and navigate to its top element :)
declare variable $g:casino := db:open("blackjack")/casino;

(: this function creates a new game instance, with players' names and lower and upper bet limits as parameters :)
declare function g:createNewGame($maxBet as xs:integer, $minBet as xs:integer,$playerNames as xs:string+, $balances as xs:integer+) as element(game) {
  let $id := t:generateID()
  let $playerNamesChecked :=    for $p in $playerNames count $i
                                return(
                                if ($balances[$i] <= 0 or $p = "") then
                                ()
                                else($p))
                                
  let $balancesChecked :=       for $b in $balances count $i
                                return(
                                if ($b <= 0 or $playerNames[$i] = "") then
                                ()
                                else($b))                                 
  
  let $players := <players>
        {for $p in $playerNamesChecked count $i
         return(p:newPlayer($p, $balancesChecked[$i],$i))
        }
        </players>
    
  return
    <game id = "{$id}">
      <step>bet</step>
      <maxBet>{$maxBet}</maxBet>
      <minBet>{$minBet}</minBet>
      <activePlayer>{$players/player[1]/@id}</activePlayer>
      {$players}
      <dealer>
        <id>dealer</id>
        <hand></hand>
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
declare %updating function g:deleteGame($gameId as xs:string) {
  for $game in $g:casino/game[@id=$gameId]
    return delete node $game
};

(: this function sets the active player, who is the one to take action :)
(: initially always is the 1st player (the one on the very right of the table (left to the dealer) :)
declare %updating function g:setActivePlayer($gameId as xs:string) {
  let $game := $g:casino/game[@id=$gameId]
  let $players := $game/players/*
  let $playerId := $game/activePlayer/@id
  
  return (
        (: after last player: activePlayer/@id is empty ("") :)
        if (not($players[@id=$playerId]/following::*[1]/@id)) then
            (
                if ($game/step = 'bet') then
                (
                    replace value of node $game/activePlayer/@id with $players[1]/@id,
                    replace value of node $game/step with 'play',
                    d:dealOutInitialCards($gameId)
                )
                else if ($game/step = 'finished') then
                (
                    replace value of node $game/activePlayer/@id with $players[*:balance>$game/minBet][1]/@id
                )
                else
                (
                    replace value of node $game/activePlayer/@id with $players[@id=$playerId]/following::*[1]/@id,
                    replace value of node $game/step with 'finishing',
                    d:dealerTurn($gameId)
                )
            )
        else
            replace value of node $game/activePlayer/@id with $players[@id=$playerId]/following::*[1]/@id
        )
};

(: this function checks the winning status for all players :)
declare %updating function g:checkWinningStatusAll($gameId as xs:string) {
    let $game := $g:casino/game[@id=$gameId]
    return (
        for $player in $game/players/player[bet > 0]
            return g:checkWinningStatus($gameId, fn:true(), $player),
        replace value of node $game/step with 'finished',
        delete node $game/dealer/hand/*,
        g:checkDeckLength($gameId)
    )
};

declare %updating function g:checkBankruptAll($gameId as xs:string) {
  let $game := $g:casino/game[@id=$gameId]
  return(for $p in $game/players/player
         where $p/balance < $game/minBet
         return(delete node $p),
         replace value of node $game/step with 'bet',
         g:setActivePlayer($gameId))
};

declare %updating function g:checkDeckLength($gameId as xs:string){
  let $game := $g:casino/game[@id=$gameId]
  let $deck := <cards>
                    {g:getDeck()/*}
                    {g:getDeck()/*}
                    {g:getDeck()/*}
                    {g:getDeck()/*}
                    {g:getDeck()/*}
                    {g:getDeck()/*}
                </cards>
  return(
    if(count($game/cards/*)<(312*0.6)) then (
        replace node $game/cards with $deck
    )
    else ()
  )
};

(: this function checks whether a player or the dealer wins this round :)
declare %updating function g:checkWinningStatus($gameId as xs:string, $endOfGame as xs:boolean, $player as element(player)) {
  let $game := $g:casino/game[@id=$gameId]

  let $betValue := $player/bet
  let $balanceValue := $player/balance

  let $valueOfCardsPlayer := p:calculateCardsValuePlayer($gameId, $player, 0)
  let $valueOfCardsDealer := d:calculateCardsValueDealer($gameId, 0)

  return (
        if ($endOfGame = fn:true()) then (
            if($valueOfCardsPlayer > 21) then (
                (: in this case, the player lost anyways :)
                replace value of node $player/bet with 0,
                delete node $player/hand/*
            )
            else (
                (: tie :)
                if ($valueOfCardsDealer = $valueOfCardsPlayer) then (
                    (: EYERY player wins and gets back his/her bet :)
                    (: even in case dealer and player both have a BlackJack, the player only gets back his/her bet :)
                    replace value of node $player/balance with ($balanceValue+$betValue),
                    replace value of node $player/bet with 0,
                    delete node $player/hand/*
                )
                (: dealer wins :)
                else if (($valueOfCardsDealer > $valueOfCardsPlayer) and ($valueOfCardsDealer <= 21)) then (
                    (: player loses :)
                    replace value of node $player/bet with 0,
                    delete node $player/hand/*
                )
                else if ($valueOfCardsPlayer = 21) then (
                    (: player got a BlackJack:)
                    replace value of node $player/balance with ($balanceValue+$betValue*2.5),
                    replace value of node $player/bet with 0,
                    delete node $player/hand/*
                )
                (: player has more points than dealer or dealer is over 21 :)
                else (
                    replace value of node $player/balance with ($balanceValue+$betValue*2),
                    replace value of node $player/bet with 0,
                    delete node $player/hand/*
                )
             )
         )
        else (
            if($valueOfCardsPlayer > 21) then (
                replace value of node $player/bet with 0,
                delete node $player/hand/*
            ) else ()
         )
    )
};

declare function g:getDeck() as element(cards) {
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
    return $deck
};

(: this function works on a single deck and shuffles it randomly :)
declare function g:shuffleCards() as element(cards) {
    let $deck := <cards>
                    {g:getDeck()/*}
                    {g:getDeck()/*}
                    {g:getDeck()/*}
                    {g:getDeck()/*}
                    {g:getDeck()/*}
                    {g:getDeck()/*}
                </cards>

    let $shuffled-deck :=
        for $i in $deck/card
        order by t:random(count($deck/card))
        return $i

    return
      <cards>
        {$shuffled-deck}
      </cards>
};
