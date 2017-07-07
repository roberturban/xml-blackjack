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

declare function g:newGame($maxBet as xs:integer, $minBet as xs:integer) as element(game) {
  let $id := g:newID()
  return
    <game>
      <id>{$id}</id>
      <maxBet>{$maxBet}</maxBet>
      <minBet>{$minBet}</minBet>
      <activePlayer></activePlayer>
      <cards>
      (: shuffle cards :)
      </cards>
      <players>
        {g:newPlayer()}
        {g:newPlayer()}
        {g:newPlayer()}
        {g:newPlayer()}
        {g:newPlayer()}
      </players>
      <dealer>
        <hand>
         (: ausgeteilt durch shuffle cards :)
        </hand>
      </dealer>
    </game>
};

declare %updating function g:insertGame($game as element(game)) {
  insert node $game as first into $g:casino
};

declare function g:newPlayer() as element(player) {
  let $id := g:newID()
  return
    <player>
      <id>{$id}</id>
      <bet>0</bet>
      <balance>100</balance>
      <insurance></insurance>
      <hand>
      (: ausgeteilt durch shuffle cards :)
      </hand>
      <name>Spieler xyz</name>
    </player>
};