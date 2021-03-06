#! /bin/sh

echo "Checking Assignment 3 (Part 1) Solutions" > results.txt

# Run your queries.

echo "" >> results.txt
echo "========== Generating query output ==========" >> results.txt

# First run the queries that we have no dtd for.
for query in q1 q2 q3 q4 q5 q6
do
   echo "" >> results.txt
   echo "------ Query" $query "------" >> results.txt
   echo "" >> results.txt
   echo "Raw results:" >> results.txt
   galax-run $query.xq >> results.txt 2>&1
done

# Now run the queries that we can "pretty print" using xmllint
# because they generate xml output.
for query in q7 
do
   echo "" >> results.txt
   echo "------ Query" $query "------" >> results.txt
   echo "" >> results.txt
   echo "Raw results:" >> results.txt
   galax-run $query.xq >> results.txt  2>&1
   echo "<?xml version='1.0' standalone='no' ?>" > TEMP.xml
   galax-run $query.xq >> TEMP.xml  2>&1
   echo "" >> results.txt
   echo "Pretty results:" >> results.txt
   xmllint --format TEMP.xml >> results.txt  2>&1
done

# Now validate the output of those queries.
# (We can, because we have a dtd.)
echo "" >> results.txt
echo "======= Validating xml generated by queries 7 and 8 =======" >> results.txt

echo "" >> results.txt
echo "------ Query" q7 "------" >> results.txt
echo "<?xml version='1.0' standalone='no' ?>" > TEMP.xml
echo "<!DOCTYPE skills SYSTEM 'skills.dtd'>" >> TEMP.xml
galax-run q7.xq >> TEMP.xml  2>&1
echo "Results Well-formed? (no news is good news)" >> results.txt
xmllint --noout TEMP.xml >> results.txt  2>&1
echo "Results valid? (no news is good news)" >> results.txt
xmllint --noout --valid TEMP.xml >> results.txt  2>&1


