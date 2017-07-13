xquery version "3.0"  encoding "UTF-8";

module namespace g = "blackjack/game";
import module namespace t = "blackjack/tools" at "tools.xqm";

(: open database blackjack, locate ressource within database and navigate to its top element :)
declare variable $g:casino := db:open("blackjack")/casino;

(: The two functions g:newGame and g:insertGame together represent the Game constructor. :)
(: newID is a helper class method :)
declare %private function g:newID() as xs:string {
  t:timestamp()
};

declare function g:newGame($maxBet as xs:integer, $minBet as xs:integer, $playerNames as xs:string+) as element(game) {
  let $id := g:newID()
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
declare %updating function g:deleteGame($id as xs:integer) {
  for $game in $g:casino/game[id=$id]
    return delete node $game
};

declare %updating function g:setActivePlayer($gameId as xs:integer) {
  let $game := $g:casino/game[id=$gameId]
  let $players := $game/players/*
  let $player_id := $game/activePlayer/id
  return replace node $game/activePlayer/id with $players[id=$player_id/text()]/following::id[1] (: todo: if Abfrage ob letzter Spieler :)
};

declare %updating function g:bet($gameId as xs:integer, $betValue as xs:integer) {
  let $game := $g:casino/game[id=$gameId]
  let $playerId := $game/activePlayer/id
  let $newBalance := $game/players/player[id=$playerId]/balance - $betValue
  
  (:if ($betValue > $game/maxBet) or ($betValue < $game/minBet) then (
      (: ERROR :) )
  else ():)
      return  (replace value of node $game/players/player[id=$playerId]/balance with $newBalance,
              replace value of node $game/players/player[id=$playerId]/bet with $betValue)
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
  let $id := g:newID()
  return
    <player>
      <id>{$id}</id>
      <bet>0</bet>
      <balance>100</balance>
      <insurance></insurance>
      <hand>
        (: drawCard x2 :)
      </hand>
      <name>{$name}</name>
    </player>
};