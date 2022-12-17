(: 
2. feladat: JSON

Minden szuperhős nevének és rasszának kiíratása, akinek nincs megadva a neme.
:)

xquery version "3.1";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

let $superheroes := json-doc("docs/01_result.json")


return 
       array{ for $s in $superheroes?*
                where contains($s?appearance?gender, "-")
       return map {
            "name": $s?name,
            "race": $s?appearance?race
       }
      }