xquery version "3.0"  encoding "UTF-8";

module namespace t = "blackjack/tools";
declare namespace uuid = "java:java.util.UUID";
declare namespace math = "java:java.lang.Math";

(: this function returns a timestamp in the form hhmmssmmmxxxx (hours, minutes, seconds, milliseconds, random number) :)
(: it removes ":" and "." separators and time zone info from current-time(), then appends a random number :)
declare function t:timestamp() as xs:string {
  let $time := replace(replace(replace(string(current-time()),":",""),"\.",""),"[\+\-].*","")
  let $random := xs:string(t:random(10000) - 1)
  return concat($time,$random)
};

(: this function returns a random number in [1,$range] :)
(: it uses a Java function until generate-random-number is generally available :)
declare function t:random($range as xs:integer) as xs:integer {
  xs:integer(ceiling(math:random() * $range))
};

(: this function returns a unique ID using java UUID generator :)
declare function t:generateID() as xs:string {
    let $id := xs:string(uuid:randomUUID())
    return $id
};

(: this function returns the time as a substring :)
declare function t:getTime() as xs:string {
    let $time := substring-before(string(current-time()),'.')
    return $time
};