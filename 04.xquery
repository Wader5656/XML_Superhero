(:
4. feladat: JSON(érték)

Hány darab hősnek volt az első szereplése valamelyik avangers filmben.
:)

xquery version "3.1";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

let $superheroes := json-doc("docs/01_result.json")

return  count(fn:distinct-values(
            for $s in $superheroes?*
             where contains($s?biography?firstAppearance, "Avengers")
             return $s?id))
        
       