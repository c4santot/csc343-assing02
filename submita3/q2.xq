<interviews>
{ 
  for $interview in fn:doc("interview.xml")/interviews/interview
  where empty($interview/assessment/collegiality)
  return <sID>{ data($interview/@sID) } </sID>        
}
</interviews>