-- Add below your SQL statements. 
-- You can create intermediate views (AS needed). Remember to drop these views after you have populated the result tables.
-- You can use the "\i a2.sql" command in psql to execute the SQL commands in this file.

-- Query 1 statements
CREATE VIEW neighbourHeight AS
SELECT a1.country AS country, a1.neighbor AS neighbor, a2.height AS nHeight
FROM neighbour a1, country a2
WHERE a1.neighbor = a2.cid;

CREATE VIEW maxHeightNeighbour AS
SELECT a1.country, a1.neighbor
FROM neighbourHeight a1 JOIN (select country, max(nHeight) as max from neighbourHeight group by country) as a2
ON a1.country = a2.country AND a1.nHeight = a2.max
GROUP BY a1.country, a1.neighbor
ORDER BY a1.country ASC;

INSERT INTO Query1
SELECT a1.country AS c1id, a2.cname AS c1name, a3.cid AS c2id, a3.cname AS c2name
FROM maxHeightNeighbour a1 INNER JOIN country a2
ON a1.country = a2.cid INNER JOIN country a3
ON a1.maxNeighbourHeight = a3.height
ORDER BY c1name ASC;

DROP VIEW maxHeightNeighbour;
DROP VIEW neighbourHeight;

-- Query 2 statements



-- Query 3 statements
CREATE VIEW landlocked AS
SELECT a2.cid as cid, a2.cname as cname
FROM oceanAccess a1 FULL JOIN country a2
ON a1.cid = a2.cid
WHERE a1.oid IS NULL;

CREATE VIEW landlockedNeighbour AS
SELECT a1.cid as c1id, a1.cname as c1name, a2.neighbor as c2id
FROM landlocked a1, neighbour a2
WHERE a1.cid = a2.country;

CREATE VIEW oneNeighbour AS
SELECT a1.c1id as c1id, a1.c1name as c1name, a1.c2id as c2id
FROM landlockedNeighbour a1 JOIN (select c1id from landlockedNeighbour group by c1id having count(c1id) = 1) AS a2
ON a1.c1id = a2.c1id;


INSERT INTO Query3
SELECT a1.country AS c1id, a2.cname AS c1name, a1.neighbor AS c2id, a3.cname as c2name
FROM oneNeighbour a1 INNER JOIN country a2
ON a1.country = a2.cid INNER JOIN country a3
ON a1.neighbor = a3.cid
ORDER BY c1name ASC;

DROP VIEW oneNeighbour;
DROP VIEW landlockedNeighbour;
DROP VIEW landlocked;

-- Query 4 statements



-- Query 5 statements
CREATE VIEW hdiFrom09to13 AS
SELECT cid, year, hdi_score
FROM hdi
WHERE year >= 2009 AND year <= 2013;

INSERT INTO Query5
SELECT a1.cid AS cid, a2.cname AS cname, avg(hdi_score) as avghdi
FROM hdiFrom09to13 a1, country a2
WHERE a1.cid = a2.cid
GROUP BY a1.cid, a2.cname
ORDER BY avghdi DESC
LIMIT 10;

DROP VIEW hdiFrom09to13;

-- Query 6 statements



-- Query 7 statements
CREATE VIEW religionPopulation AS
SELECT a1.cid AS cid, a1.rid AS rid, a1.rname AS rname, a1.rpercentage AS rpercentage, (a2.population * a1.rpercentage) AS followersInCountry
FROM religion a1, country a2
WHERE a1.cid = a2.cid;

INSERT INTO Query7
SELECT rid, rname, sum(followersInCountry) AS followers
FROM religionPopulation
GROUP BY rid, rname
ORDER BY followers DESC;

DROP VIEW religionPopulation;


-- Query 8 statements



-- Query 9 statements
CREATE VIEW countryDepth AS
SELECT a1.cid AS cid, a1.oid AS oid, a2.depth AS depth
FROM oceanAccess a1, ocean a2
WHERE a1.oid = a2.oid;

CREATE VIEW countryDepthPlusNoOcean AS
SELECT a2.cname as cname, a2.cid as cid, COALESCE(a1.depth, 0) AS depth, a2.height as height
FROM countryDepth a1 FULL JOIN country a2
ON a1.cid = a2.cid;

CREATE VIEW countryMaxDepth AS
SELECT cname, cid, max(depth) as maxDepth, height
FROM countryDepthPlusNoOcean 
GROUP BY cname, cid,  height;

INSERT INTO Query9
SELECT cname, (height + maxDepth) AS totalspan
FROM countryMaxDepth
ORDER BY totalspan DESC
LIMIT 1;

DROP VIEW countryMaxDepth;
DROP VIEW countryDepthPlusNoOcean;
DROP VIEW countryDepth;


-- Query 10 statements


