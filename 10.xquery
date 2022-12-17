(: 
10. Feladat: HTML

Egy html kimeneten kiíratni a férfiak és nők számát szemszínenként, hozzáadott arány oszloppal, hogy a szuperhősök hány %-a rendelkezik azzal a szemszínnel.
:)

xquery version "3.1";

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "html";
declare option output:html-version "5.0";
declare option output:indent "yes";

declare function local:getgender_amount($superheroes, $gender, $eye) as xs:integer {
    switch ($gender)
        case "Male"
            return
                count($superheroes?*[?appearance?gender = "Male" and ?appearance?eyeColor = $eye])
        case "Female"
            return
                count($superheroes?*[?appearance?gender = "Female" and ?appearance?eyeColor = $eye])
        default return
            0
};

let $superheroes := json-doc("docs/01_result.json")

let $eyecolors := $superheroes?*?appearance?eyeColor => distinct-values()
let $allheronumber := count($superheroes?*)

return
    document {
        <html>
            <head>
                <title>Szemszínenként férfiak és nők száma, aránnyal</title>
                <link
                    rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"/>
                <style>
                    tr, th {{
                    text-align: center;
                    }}
                </style>
            </head>
            <body>
                <table
                    class="table table-striped table-dark">
                    <thead>
                        <tr>
                            <th>Eye Color</th>
                            <th>Number of Males with that eye color</th>
                            <th>Number of Females with that eye color</th>
                            <th>Rate</th>
                        </tr>
                    </thead>
                    <tbody>
                        {
                            for $s in $superheroes
                            for $eyecolor in $eyecolors
                            let $males := local:getgender_amount($superheroes, "Male", $eyecolor)
                            let $females := local:getgender_amount($superheroes, "Female", $eyecolor)
                            let $rate := round(($males + $females) div $allheronumber, 4)
                                where $eyecolor != ""
                                group by $eyecolor
                                order by $rate descending
                            return
                                <tr>
                                    <td>{$eyecolor}</td>
                                    <td>{
                                            let $males := local:getgender_amount($superheroes, "Male", $eyecolor)
                                            return
                                                $males
                                        }</td>
                                    <td>
                                        {
                                            let $females := local:getgender_amount($superheroes, "Female", $eyecolor)
                                            return
                                                $females
                                        }
                                    </td>
                                    <td>
                                        {
                                            let $males := local:getgender_amount($superheroes, "Male", $eyecolor)
                                            let $females := local:getgender_amount($superheroes, "Female", $eyecolor)
                                            let $rate := round(($males + $females) div $allheronumber, 4)
                                            return
                                                $rate
                                        }
                                    </td>
                                </tr>
                        }
                    </tbody>
                </table>
            </body>
        </html>
    }