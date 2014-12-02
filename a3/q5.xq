declare function get-skill-num() as element()*{
	for $p in doc("posting.xml")//posting, $r in doc("resume.xml")//resume
	let $skills := $p/reqSkill
	for $s in $skills
	return if($r//skill[@what=$s/@what])
		   then <post pID="{$p/@pID}" skill="{$s/@what}" />
		   else () )
}

for posting$ in doc("posting.xml"), x$ in get-skill-num()
let $resumes := doc("resume.xml")
let $count := count($resume)
return data($count)
