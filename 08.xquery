(: 
8. feladat: XML

Női, illetve férfi szuperhősök átlag magassága illetve testsúlya.
:)

xquery version "3.1";

import schema default element namespace "" at "08.xsd";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare function local:get-average-value($heroes, $appearance-key as xs:string) {
    let $values := for $v in $heroes?appearance?($appearance-key)?2
        let $value := xs:double(fn:replace(fn:head(tokenize($v, ' ')), ',', ''))
        let $unit := fn:tail(tokenize($v, ' '))
        return if ($value = 0) then () else (
            switch ($unit)
                case "meters" return $value*100
                case "tons" return $value*1000
                default return $value
        )
    return fn:round($values => avg(), 2)
};

let $superheroes := json-doc("docs/01_result.json")


let $female-heroes := $superheroes?*[?appearance?gender = "Female"]
let $male-heroes := $superheroes?*[?appearance?gender = "Male"]

return validate {
<heroes>
<female-heroes>
    <avg-height>{local:get-average-value($female-heroes, "height")} cm</avg-height>
    <avg-weight>{local:get-average-value($female-heroes, "weight")} kg</avg-weight>
</female-heroes>
<male-heroes>
    <avg-height>{local:get-average-value($male-heroes, "height")} cm</avg-height>
    <avg-weight>{local:get-average-value($male-heroes, "weight")} kg</avg-weight>
</male-heroes>
</heroes>
}




