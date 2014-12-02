<resumes>{

        let $list := fn:doc("resume.xml")/resumes/resume
        for $item in $list, $item2 in $list
        where $item/@rID!=$item2/@rID and count($item/skills/skill)=count($item2/skills/skill) and deep-equal($item/skills/skill,$item2/skills/skill)
                return  <rIDs>{ data( $item/@rID),data( $item2/@rID) }</rIDs>
}
</resumes>