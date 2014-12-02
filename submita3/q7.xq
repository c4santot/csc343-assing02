<skills>
{
	for $x in distinct-values(for $p in doc("posting.xml")//posting/reqSkill
	let $name := $p/@what
	return data($name))
	return <skill name="{$x}">
			{
				for $level in (1 to 5)
				let $resume := doc("resume.xml")//resume
				let $count := count($resume//skill[@what=$x and @level=$level])
				return <count level="{$level}" n="{$count}" />
			}
		   </skill>

}
</skills>