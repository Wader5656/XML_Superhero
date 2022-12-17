(:
3. feladat: JSON

Azon hősök nevének és erejének kiíratása, akiknek a "durability" értékük 100 és a "strenght" nagyobb, mint 80 "intelligence" szerint rendezve.
:)

xquery version "3.1";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

let $superheroes := json-doc("docs/01_result.json")

return array{ for $s in $superheroes?*
                   where $s?powerstats?durability = 100 and $s?powerstats?strength > 80
                   order by $s?powerstats?intelligence
       return 
            map {
                "name": $s?name,
                "strength": $s?powerstats?strength
            }
}