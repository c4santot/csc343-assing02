-- Add below your SQL statements. 
-- You can create intermediate views (AS needed). Remember to drop these views after you have populated the result tables.
-- You can use the "\i a2.sql" command in psql to execute the SQL commands in this file.

-- Query 1 statements
CREATE VIEW neighbourHeight AS
SELECT a1.country AS country, a1.neighbour AS neighbour, a2.height AS nHeight
FROM neighbour a1, country a2
WHERE a1.neighbour = a2.cid;

CREATE VIEW maxHeightNeighbour AS
SELECT country, neighbour, max(nHeight) AS maxHeight
FROM neighbourHeight
GROUP BY country, neighbour;

CREATE VIEW answer1 AS
SELECT a2.country AS c1id, a2.cname AS c1name, a2.neighbour AS c2id, a3.cname AS c2name
FROM maxHeightNeighbour a1 INNER JOIN country a2
ON a1.country = a2.cid INNER JOIN country a3
ON a2.neighbour = a3.cid
ORDER BY c1name ASC;

INSERT INTO Query1 answer;

DROP VIEW answer1;
DROP VIEW maxHeightNeighbour;
DROP VIEW neighbourHeight;

-- Query 2 statements



-- Query 3 statements
CREATE VIEW oneNeighbour AS
SELECT country, neighbour
FROM neighbour
HAVING count(neighbour) = 1;

CREATE VIEW answer3 AS
SELECT a1.country AS c1id, a2.cname AS c1name, a1.neighbour AS c2id, a3.cname as c2name
FROM oneNeighbour a1 INNER JOIN country a2
ON a1.country = a2.cid INNER JOIN country a3
ON a1.neighbour = a3.cid
ORDER BY c1name ASC;

INSERT INTO Query3 answer3;

DROP VIEW answer3;
DROP VIEW oneNeighbour;

-- Query 4 statements



-- Query 5 statements
CREATE VIEW hdiFrom09to13 AS
SELECT cid, year, hdi_score
FROM hdi
WHERE year >= 2009 AND year <= 2013;

CREATE VIEW answer5 AS
SELECT a1.cid AS cid, a2.cname AS cname, avg(hdi_score) as avghdi
FROM hdiFrom09to13 a1, country a2
WHERE a1.cid = a2.cid
GROUP BY cid, cname
ORDER BY avghdi DESC
LIMIT 10;

INSERT INTO Query5 answer5;

DROP VIEW answer5;
DROP VIEW hdiFrom09to13;

-- Query 6 statements



-- Query 7 statements
CREATE VIEW religionPopulation AS
SELECT a1.cid AS cid, a1.rid AS rid, a1.rname AS rname, a1.rpercentage AS rpercentage, (a2.population * a1.rpercentage / 100) AS followersInCountry
FROM religion a1, country a2
WHERE a1.cid = a2.cid;

CREATE VIEW answer7 AS
SELECT rid, rname, sum(followersInCountry) AS followers
FROM religionPopulation
GROUP BY rid, rname
ORDER BY followers DESC;

INSERT INTO Query7 answer7;

DROP VIEW answer7;
DROP VIEW religionPopulation;


-- Query 8 statements



-- Query 9 statements
CREATE VIEW countryDepth AS
SELECT a1.cid AS cid, a1.oid AS oid, a2.depth AS depth
FROM oceanAccess a1, ocean a2
WHERE a1.oid = a2.oid;

CREATE VIEW countryDepthPlusNoOcean AS
SELECT a2.cname as cname, a2.cid as cid, a1.oid as oid, COALESCE(a1.depth, 0) AS depth, a2.height as height
FROM countryDepth a1 FULL JOIN country a2
ON a1.cid = a2.cid;

CREATE VIEW countryDeepestOcean AS
SELECT cname, cid, oid, max(depth) as maxDepth, height
FROM countryDepthPlusNoOcean
GROUP BY cname, cid, oid, height;

CREATE VIEW answer9 AS
SELECT cname, (height + maxDepth) AS totalspan
FROM countryDeepestOcean
ORDER BY totalspan DESC
LIMIT 1;

INSERT INTO Query9 answer9;

DROP VIEW answer9;
DROP VIEW countryDeepestOcean;
DROP VIEW countryDepthPlusNoOcean;
DROP VIEW countryDepth;


-- Query 10 statements


