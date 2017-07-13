xquery version "3.0"  encoding "UTF-8";

module namespace g = "blackjack/dealer";
import module namespace t = "blackjack/tools" at "tools.xqm";

(: open database blackjack, locate ressource within database and navigate to its top element :)
declare variable $g:casino := db:open("blackjack")/casino;



(: hidden value is set to false :)
declare %updating function g:turnHiddenCard($card as element(card)) {
  replace value of node $card//@hidden with 'false'
};

(: constructors for dealer still to do :)