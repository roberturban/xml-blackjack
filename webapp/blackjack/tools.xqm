xquery version "3.0"  encoding "UTF-8";

module namespace t = "blackjack/tools";

declare function t:timestamp() as xs:string {
  (: returns a timestamp in the form hhmmssmmmxxxx (hours, minutes, seconds, milliseconds, random number) :)
  (: removes ":" and "." separators and time zone info from current-time(), then appends a random number :)
  let $time := replace(replace(replace(string(current-time()),":",""),"\.",""),"[\+\-].*","")
  let $random := xs:string(t:random(10000) - 1)
  return concat($time,$random)
};

declare function t:random($range as xs:integer) as xs:integer {
  (: returns a random number in [1,$range] :)
  (: uses Java function until generate-random-number is generally available :)
  xs:integer(ceiling(Q{java:java.lang.Math}random() * $range))
};

