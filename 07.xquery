(: 
7. feladat: XML

Fajonként a leghosszabb nevű  személy kiíratása Fullname alapján.(legtöbb darabból rakódik össze) Ha több is van, akkor a legelső megtalált nevet írja ki. 
:)

xquery version "3.1";

import schema default element namespace "" at "07.xsd";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare function local:getname($name) {
    let $token := fn:replace($name, '-', ' ')
    let $token := fn:tokenize($token, ' ')
    return
        $token
};

declare function local:name($superheroes) {
    for $s in $superheroes
        where not(contains($s, "("))
    let $name_t := local:getname($s)
    return
        map {
            "name": $s,
            "name_length": count($name_t)
        }
};

let $superheroes := json-doc("docs/01_result.json")

let $races := $superheroes?*?appearance?race => distinct-values()

return
    validate {
        <races>
            {
                for $race in $races
                let $heroes-in-race := $superheroes?*[?appearance?race = $race]
                let $arr := local:name($heroes-in-race?biography?fullName)
                let $max := $arr ! ?name_length => max()
                let $longest := $arr[?name_length eq $max]               
                return
                  <race race = "{$race}">
                        <name>{$longest?name[1]}</name>
                        <name_length>{$longest?name_length[1]}</name_length>
                  </race>    
            }
        </races>
    }
