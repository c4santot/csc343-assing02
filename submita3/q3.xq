for $p in doc("posting.xml")//posting
let $r := $p/reqSkill
return $r[@importance = max($r/@importance)]