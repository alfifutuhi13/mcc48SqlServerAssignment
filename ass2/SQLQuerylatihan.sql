Use [Assignments 1]

--Avoiding error
DROP TABLE [tbl_club1];
DROP TABLE [tbl_club2];
DROP TABLE [tbl_trophy];

--CREATING TABLES
CREATE TABLE [tbl_trophy]
(
	club varchar(50),
	trophy int,
);

CREATE TABLE [tbl_club1]
(
	club varchar(50),
	country varchar(50),
);

CREATE TABLE [tbl_club2]
(
	club varchar(50) PRIMARY KEY,
	country varchar(50),
);

--INSERTING VALUES

--tbl_trophy
INSERT INTO tbl_trophy(club, trophy)
VALUES('juventus',36);
INSERT INTO tbl_trophy(club, trophy)
VALUES('inter milan',18);
INSERT INTO tbl_trophy(club, trophy)
VALUES('milan',18);
INSERT INTO tbl_trophy(club, trophy)
VALUES('real madrid',34);
INSERT INTO tbl_trophy(club, trophy)
VALUES('barcelona',26);
INSERT INTO tbl_trophy(club, trophy)
VALUES('manchester united',20);
INSERT INTO tbl_trophy(club, trophy)
VALUES('liverpool',19);
INSERT INTO tbl_trophy(club, trophy)
VALUES('arsenal',13);
INSERT INTO tbl_trophy(club, trophy)
VALUES('manchester city',6);

--tbl_club1
INSERT INTO tbl_club1(club, country)
VALUES ('manchester united', 'england');
INSERT INTO tbl_club1(club, country)
VALUES ('chelsea', 'england');
INSERT INTO tbl_club1(club, country)
VALUES ('liverpool', 'england');
INSERT INTO tbl_club1(club, country)
VALUES ('juventus', 'italy');
INSERT INTO tbl_club1(club, country)
VALUES ('inter milan', 'italy');
INSERT INTO tbl_club1(club, country)
VALUES ('real madrid', 'spain');
INSERT INTO tbl_club1(club, country)
VALUES ('barcelona', 'spain');

--tbl_club2
INSERT INTO tbl_club2(club, country)
VALUES ('everton', 'england');
INSERT INTO tbl_club2(club, country)
VALUES ('watford', 'england');
INSERT INTO tbl_club2(club, country)
VALUES ('villareal', 'spain');
INSERT INTO tbl_club2(club, country)
VALUES ('athletic bilbao', 'spain');
INSERT INTO tbl_club2(club, country)
VALUES ('atletico madrid', 'spain');
INSERT INTO tbl_club2(club, country)
VALUES ('milan', 'italy');
INSERT INTO tbl_club2(club, country)
VALUES ('roma', 'italy');


--Showing table's data
--SELECT * FROM tbl_trophy ORDER BY trophy DESC;
--SELECT * FROM tbl_club1;
--SELECT * FROM tbl_club2;

--1. Jumlah Club berdasarkan Negara
SELECT
	all_country.country as 'jumlah club berdasarkan negara',
	Count(*) as 'jumlah'
FROM(
	SELECT 
		country
	FROM tbl_club1

	UNION ALL

	SELECT 
		country
	FROM tbl_club2
) as all_country

GROUP BY country
ORDER BY COUNT(*) ASC;

--2. Jumlah trophy setiap club
SELECT
	ISNULL(tbl_club.club, tbl_trophy.club) as 'club',
	ISNULL(tbl_trophy.trophy,0) as 'trophy'
FROM(
	(SELECT 
		club 
	FROM 
		tbl_club1
	UNION ALL
	SELECT 
		club 
	FROM 
		tbl_club2) as tbl_club
	FULL OUTER JOIN tbl_trophy ON tbl_club.club = tbl_trophy.club
)


ORDER BY 
	'club' ASC;


--3. Club yang tidak memiliki trophy
SELECT 
	COALESCE(NULL, 'Club yang tidak memiliki trophy'),
	COUNT(ISNULL(alltabel.trophy,0)) as 'trophy'
FROM (
	SELECT 
		tbl_club1.club,
		tbl_trophy.trophy 
	FROM 
		tbl_club1
		LEFT JOIN tbl_trophy ON tbl_club1.club = tbl_trophy.club
	UNION ALL
	SELECT 
		tbl_club2.club,
		tbl_trophy.trophy 
	FROM 
		tbl_club2
		LEFT JOIN tbl_trophy ON tbl_club2.club = tbl_trophy.club
	UNION
	SELECT 
		tbl_trophy.club, 
		tbl_trophy.trophy
	FROM
		tbl_trophy
) AS alltabel
WHERE trophy IS NULL
ORDER BY 'trophy'

--4. Jumlah Trophy Klub Milan dan manchester
SELECT 
	'milan' as Club , 
	SUM(alltabel2.trophy) as 'Total Trophy' 
FROM (
	SELECT 
		alltabel.club , 
		ISNULL(alltabel.trophy,0) as trophy
	FROM (
		SELECT 
			tbl_club1.club, 
			tbl_trophy.trophy 
		FROM 
			tbl_club1
			JOIN tbl_trophy  ON tbl_club1.club = tbl_trophy.club
		UNION ALL
		SELECT 
			tbl_club2.club, 
			tbl_trophy.trophy 
		FROM 
			tbl_club2
			JOIN tbl_trophy ON tbl_club2.club = tbl_trophy.club
		UNION
		SELECT tbl_trophy.club, tbl_trophy.trophy from tbl_trophy
	) as alltabel
	WHERE alltabel.club LIKE '%milan%'
) as alltabel2

Union ALL

SELECT 
	'manchester' as Club , 
	SUM(alltabel4.trophy) as 'Total Trophy' 
FROM (
	SELECT alltabel3.club , ISNULL(alltabel3.trophy,0) as trophy
	FROM (
		SELECT 
			tbl_club1.club, 
			tbl_trophy.trophy 
		FROM 
			tbl_club1
			JOIN tbl_trophy ON tbl_club1.club = tbl_trophy.club
		UNION ALL
		SELECT 
			tbl_club2.club, 
			tbl_trophy.trophy 
		FROM 
			tbl_club2
			JOIN tbl_trophy ON tbl_club2.club = tbl_trophy.club
		UNION
		SELECT 
			tbl_trophy.club, 
			tbl_trophy.trophy 
		FROM tbl_trophy
	) as alltabel3
	WHERE alltabel3.club LIKE '%manchester%'
) as alltabel4

--5. Jumlah Trophy per negara

SELECT 
	alltabel.country,
	SUM(alltabel.trophy) as trophy
FROM (
	SELECT 
		tbl_club1.club,
		tbl_club1.country,
		tbl_trophy.trophy
	FROM 
		tbl_club1
		JOIN tbl_trophy ON tbl_club1.club = tbl_trophy.club
	UNION ALL
	SELECT 
		tbl_club2.club,
		tbl_club2.country,
		tbl_trophy.trophy 
	FROM 
		tbl_club2
		JOIN tbl_trophy ON tbl_club2.club = tbl_trophy.club
) AS alltabel

GROUP BY alltabel.country
ORDER BY trophy

--6. Club yang memiliki trophy >=20
SELECT * FROM tbl_trophy
WHERE trophy>= 20
ORDER BY trophy DESC;

--7. Rata-rata jumlah trophy per negara yang lebih dari 20
SELECT alltabel.country
FROM (
	SELECT 
		tbl_club1.club,
		tbl_club1.country,
		tbl_trophy.trophy
	FROM 
		tbl_club1
		JOIN tbl_trophy ON tbl_club1.club = tbl_trophy.club
	UNION ALL
	SELECT 
		tbl_club2.club,
		tbl_club2.country,
		tbl_trophy.trophy 
	FROM 
		tbl_club2
		JOIN tbl_trophy ON tbl_club2.club = tbl_trophy.club
) AS alltabel

--8. 10 Club dengan trophy terbanyak
SELECT TOP 10 
	tbl_club.club,
	ISNULL(tbl_club.trophy,0) as 'trophy'
FROM( 
	--tbl_trophy
	SELECT tbl_club1.club, tbl_trophy.trophy from (tbl_club1
	JOIN tbl_trophy ON tbl_club1.club = tbl_trophy.club)
	UNION ALL
	SELECT tbl_club2.club, tbl_trophy.trophy from (tbl_club2
	JOIN tbl_trophy ON tbl_club2.club = tbl_trophy.club)
) as tbl_club
ORDER BY tbl.club.trophy DESC;

	

