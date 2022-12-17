(:
5. feladat: JSON

A legmagasabb és legnehezebb hős(ök) nevének, magasságának és súlyának kiírása.
:)

xquery version "3.1";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

declare function local:maximumheight($superheroes) as xs:double {
    fn:max(for $s in $superheroes?*
        where not(substring-before($s?appearance?height?1, "'") eq "")
    return
        number(substring-before($s?appearance?height?1, "'")))
};

declare function local:maximumweight($superheroes) as xs:double {
    fn:max(for $s in $superheroes?*
        where not(contains(substring-before($s?appearance?weight?1, ' '), '-'))
    return
        number(substring-before($s?appearance?weight?1, ' ')))
};

let $superheroes := json-doc("docs/01_result.json")

let $maximumh := local:maximumheight($superheroes)
let $maximumw := local:maximumweight($superheroes)

return
    array {
        for $s in $superheroes?*
        let $height := number(substring-before($s?appearance?height?1, ' '))
        let $weight := number(substring-before($s?appearance?weight?1, ' '))
            where $height = $maximumh or $weight = $maximumw
        return
            map {
                "name": $s?name,
                "height": $s?appearance?height?2,
                "weight": $s?appearance?weight?2
            }
    }





















