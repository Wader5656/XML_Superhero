(: 
9. feladat: XML

Az összes olyan hős statisztikáinak kiírtatása akik valahogy kötődnek zöldlámpáshoz, harc érték alapján csökkenően rendezve.
:)

xquery version "3.1";

import schema default element namespace "" at "09.xsd";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare function local:green($superheroes) {
    for $s in $superheroes?*
        where contains($s?connections?groupAffiliation, "Green Lantern")
        order by $s?powerstats?combat descending
    return
        map {
            "name": $s?name,
            "stats": map {
                "strength": $s?powerstats?strength,
                "durability": $s?powerstats?durability,
                "combat": $s?powerstats?combat,
                "power": $s?powerstats?power,
                "speed": $s?powerstats?speed,
                "intelligence": $s?powerstats?intelligence
            }
        }
};

let $superheroes := json-doc("docs/01_result.json")

let $result := local:green($superheroes)

return
    validate {
        <heroes>
            {
                for $r in $result
                return
                    <hero
                        name="{$r?name}">
                        <stats>
                            <intelligence>{$r?stats?intelligence}</intelligence>
                            <strength>{$r?stats?strength}</strength>
                            <power>{$r?stats?power}</power>
                            <speed>{$r?stats?speed}</speed>
                            <durability>{$r?stats?durability}</durability>
                            <combat>{$r?stats?combat}</combat>
                        </stats>
                    </hero>
            }
        </heroes>
    }