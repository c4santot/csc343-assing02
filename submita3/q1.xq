for $r in doc("resume.xml")//resume
let $s := $r/skills/skill
return if(count($s) >= 3)
	   then 
	   		<resume rid="{$r/@rID}">
	   			<forename>{$r//forename}</forename>
	   			<skills>{count($s)}</skills>
	   		</resume>
	   	else ()