<postings>{
  distinct-values(
  for $posting in fn:doc("posting.xml")/postings/posting
  let $resume := fn:doc("resume.xml")/resumes/resume
  where ((count($resume/skills/skill/@what[.= $posting/reqSkill/@what] ) = 0 or $posting/reqSkill/@what = $resume/skills/skill/@what and $posting/reqSkill/@level > $resume/skills/skill/@level))
  return $posting/@pID
  )
}
</postings>