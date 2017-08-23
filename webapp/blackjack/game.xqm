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
      <events>
        <event><time>{t:getTime()}</time><text> New game created, have fun!</text></event>
      </events>
      {g:shuffleCards()}
    </game>
};

(: this function returns an empty game with step = gameover :)
declare function g:createEmptyGame() as element(game) {
  let $id := t:generateID()
  return
    <game id = "{$id}">
      <step>gameover</step>
      <maxBet></maxBet>
      <minBet></minBet>
      <activePlayer></activePlayer>
      <players></players>
      <dealer>
        <id>dealer</id>
        <hand></hand>
      </dealer>
      <events>
        <event><time>{t:getTime()}</time><text> ERROR: For each player a name is mandatory and balance needs to be greater than 0</text></event>
        <event><time>{t:getTime()}</time><text> ERROR: New game with no players created</text></event>
      </events>
    </game>
}; 
 
(: this function inserts a new game instance into the casino server :)
declare %updating function g:insertGame($game as element(game)) {
  insert node $game as first into $g:casino
};

(: this function deletes a game instance from the casino server :)
(: the game instance to be deleted is referenced by its gameId :)
(: due to efficiency, iterate only over matching games, which usually should be a single game :)
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
                    replace value of node $game/activePlayer/@id with $players[*:balance > number($game/minBet)][1]/@id
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
            return g:checkWinningStatus($gameId, $player),
        replace value of node $game/step with 'finished',
        delete node $game/dealer/hand/*,
        g:checkDeckLength($gameId)
    )
};

(: this funtion checks who ran out of money :)
declare %updating function g:checkBankruptAll($gameId as xs:string) {
  let $game := $g:casino/game[@id=$gameId]
  let $playersIn := count($game/players/player)
  let $playersOut := count( for $p in $game/players/player
                            where (number($p/balance) < number($game/minBet))
                            return $p)
  
  return(
        if($playersIn = $playersOut) then (
           replace value of node $game/step with 'gameover',
           g:addEvent($gameId,"GAME OVER: All players are bankrupt")
          )
        else (
           replace value of node $game/step with 'bet',
           g:addEvent($gameId,"New round started"),
           g:setActivePlayer($gameId)),
  
        for $p in $game/players/player
        where (number($p/balance) < number($game/minBet))
        return(
            delete node $p,
            g:addEvent($gameId,concat($p/name," is bankrupt")))
         )
};

(: this function checks the length of the deck :)
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
        let $shuffled-deck :=
         for $i in $deck/card
         order by t:random(count($deck/card))
         return $i

        let $shuffled-cards :=
            <cards>
              {$shuffled-deck}
            </cards>
        return (replace node $game/cards with $shuffled-deck,
        g:addEvent($gameId,"All cards are shuffled"))
    )
    else ()
  )
};

(: this function checks whether a player or the dealer wins this round :)
declare %updating function g:checkWinningStatus($gameId as xs:string, $player as element(player)) {
  let $game := $g:casino/game[@id=$gameId]

  let $betValue := $player/bet
  let $balanceValue := $player/balance

  let $valueOfCardsPlayer := p:calculateCardsValuePlayer($gameId, $player, 0)
  let $valueOfCardsDealer := d:calculateCardsValueDealer($gameId, 0)
  let $numberOfCardsPlayer := count($player/hand/card)
  let $numberOfCardsDealer := count($game/dealer/hand/card)

  return (
            if($valueOfCardsPlayer > 21) then (
                (: in this case, the player lost anyways :)
                replace value of node $player/balance with ($balanceValue+g:checkInsurancePayout($player,$valueOfCardsDealer,$numberOfCardsDealer))
            )
            else (
                (: tie? :)
                if ($valueOfCardsDealer = $valueOfCardsPlayer) then (
                    
                    if (($numberOfCardsDealer = 2) and ($valueOfCardsDealer = 21) and ($numberOfCardsPlayer > 2)) then (
                        (: dealer blackjack, player just 21 => player loses :)
                        replace value of node $player/balance with ($balanceValue+g:checkInsurancePayout($player,$valueOfCardsDealer,$numberOfCardsDealer)))
                    else if (($numberOfCardsDealer > 2) and ($valueOfCardsDealer = 21) and ($numberOfCardsPlayer = 2)) then (
                        (: player blackjack, dealer just 21 => player wins 3:2 :)
                        replace value of node $player/balance with ($balanceValue+$betValue*2.5+g:checkInsurancePayout($player,$valueOfCardsDealer,$numberOfCardsDealer)),
                        g:addEvent($gameId,concat($player/name,' got a blackjack!')))
                    else (
                        (: tie :)
                        replace value of node $player/balance with ($balanceValue+$betValue+g:checkInsurancePayout($player,$valueOfCardsDealer,$numberOfCardsDealer)))
                )
                (: dealer wins :)
                else if (($valueOfCardsDealer > $valueOfCardsPlayer) and ($valueOfCardsDealer <= 21)) then (
                    (: player loses :)
                    replace value of node $player/balance with ($balanceValue+g:checkInsurancePayout($player,$valueOfCardsDealer,$numberOfCardsDealer))
                )
                else if ($valueOfCardsPlayer = 21) then (
                    if ($numberOfCardsPlayer = 2) then (
                        (: player wins with a blackJack :)
                        replace value of node $player/balance with ($balanceValue+$betValue*2.5+g:checkInsurancePayout($player,$valueOfCardsDealer,$numberOfCardsDealer)),
                        g:addEvent($gameId,concat($player/name,' got a blackjack!')))
                    else (
                        (: player wins but no blackjack :)
                        replace value of node $player/balance with ($balanceValue+$betValue*2+g:checkInsurancePayout($player,$valueOfCardsDealer,$numberOfCardsDealer)))
                )
                (: player has more points than dealer or dealer is over 21 :)
                else (
                    replace value of node $player/balance with ($balanceValue+$betValue*2)
                )
             ),
             replace value of node $player/bet with 0,
             replace value of node $player/insurance with 0,
             delete node $player/hand/*
         )
};

(: checks the insurance payout for a player :)
declare function g:checkInsurancePayout($player as element(player), $valueOfCardsDealer as xs:double, $numberOfCardsDealer as xs:integer) as xs:double {
   let $insurance := number($player/insurance)
    
   return(
   if($insurance > 0) then (
       if(($valueOfCardsDealer = 21) and ($numberOfCardsDealer = 2)) then
            ($insurance*2)
       else
            0
       )
    else
        0
    )
};

(: adds a new event element in events :)
declare %updating function g:addEvent($gameId as xs:string, $text as xs:string) {
    let $game := $g:casino/game[@id=$gameId]
    let $insert :=  <event>
                        <time>{t:getTime()}</time>
                        <text>{concat(" ",$text)}</text>
                    </event>
    return (
        insert node $insert as first into $game/events
        )
};

(: this function returns the deck of cards :)
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