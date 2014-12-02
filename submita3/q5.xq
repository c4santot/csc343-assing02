let $p := doc("posting.xml")
let $r := doc("resume.xml")

let $resumes := count($r//resume)

return
	distinct-values(
		for $rs in $p//reqSkill
		let $s := $rs/@what

		let $resumesWithSkill := count($r//skill[@what = $s])
		let $resumesAboveThree := count($r//skill[@what = $s and @level > 3])

		where ($resumes div 2) > $resumesWithSkill or ($resumesWithSkill div 2) > $resumesAboveThree
		return $rs/../@pID
	)
