(: 
1. feladat: JSON

A teljes json kiíratása az apiról.
:)

xquery version "3.1";

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

declare function local:getResult($url as xs:string) {
    let $doc := json-doc($url)
    return $doc    
};

let $url := "https://akabab.github.io/superhero-api/api/all.json"
let $result := local:getResult($url)

return $result