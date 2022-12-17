(:
6. feladat: XML

Melyik kiadó(k) adta/adták ki a legtöbb/legkevesebb szuperhőst.
:)

xquery version "3.1";

import schema default element namespace "" at "06.xsd";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare function local:getmax($superheroes,$publishers,$num-by-pub){
     fn:max(for $publisher in $publishers return $superheroes?*[?biography?publisher = $publisher] => count())
    
};

declare function local:getmin($superheroes,$publishers,$num-by-pub){
fn:min(for $publisher in $publishers return $superheroes?*[?biography?publisher = $publisher] => count())
};

let $superheroes := json-doc("docs/01_result.json")


let $publishers := $superheroes?*?biography?publisher[. != ""] => distinct-values()
let $num-heroes-by-publisher := map:merge(
    for $publisher in $publishers
        return map:entry($publisher, $superheroes?*[?biography?publisher = $publisher] => count())
)

let $maximum := local:getmax($superheroes,$publishers,$num-heroes-by-publisher)
let $minimum := local:getmin($superheroes,$publishers,$num-heroes-by-publisher)

return validate {
<publishers>
{for $publisher in $publishers
    let $superherocount := map:get($num-heroes-by-publisher, $publisher)
    where $superherocount eq $maximum or $superherocount eq $minimum
    
    return  
    <publisher name = "{$publisher}">
        <superheroes>{$superherocount}</superheroes>
    </publisher> 

    
}
</publishers>
}