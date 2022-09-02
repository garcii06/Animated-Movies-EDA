/*
	The following DEA script will try to answer the following questions and add a general panorama of the dataset.	
	General preview and statistics from the data.
		1. Know the total number of titles for each genre(even main or secondary).
		2. Knowing the average gross, metascore and rating for each genre.
		3. Does long runtime result in better rating/votes, metascore or gross?
		4. Top 3 movies by genre in terms of gross, rating and metascore. 
*/

-- General preview of the dataset
SELECT TOP 25 *
FROM AnimatedMovies..Animated_vw;

-- Getting all the Possible Genre Categories
WITH allCategories AS (
	SELECT MainCategory
	FROM AnimatedMovies..Animated_vw
	UNION 
	SELECT SecondCategory
	FROM AnimatedMovies..Animated_vw
)
SELECT *
FROM allCategories
WHERE MainCategory NOT IN ('');

-- Total Movies by combination of Genre
-- Most of the animated movies have adventure as its genre, maybe is what people look when choosing it, thats why its so popular.
SELECT MainCategory, SecondCategory, COUNT(*) numOfMovies
FROM AnimatedMovies..Animated_vw
GROUP BY MainCategory, SecondCategory
ORDER BY MainCategory;

-- Know how many of the movies are from the adventure genre.
-- We have a total of 56 movies out of 85. 
SELECT 'Adventure' Genre, COUNT(*) total_Movies
FROM AnimatedMovies..Animated_vw
WHERE MainCategory IN ('Adventure') OR SecondCategory IN ('Adventure');

-- Get year and total of movies produced in that year.
SELECT  Year, COUNT(*) totalMoviesYear
FROM AnimatedMovies..Animated_vw
GROUP BY Year;

-- Get the rank of each year according to the number of movies.
WITH countMoviesYear AS(
	SELECT CONCAT('01/01/',Year) trunkDate, COUNT(*) totalMoviesYear
	FROM AnimatedMovies..Animated_vw
	GROUP BY CONCAT('01/01/',Year)
)
SELECT YEAR(trunkDate) Year, totalMoviesYear, DENSE_RANK() OVER(ORDER BY totalMoviesYear DESC) rankingYears
FROM countMoviesYear;

-- Get the rank by the Metascore value
SELECT Title, Metascore, DENSE_RANK() OVER(ORDER BY Metascore DESC) rankingScore
FROM AnimatedMovies..Animated_vw;

-- Get the top 1 movie by the metascore for each Genre
-- Here we can see that people prefer Adventure, Comedy, Drama & Action in Animated Movies.
WITH rankedGenre AS (
	SELECT Title, Metascore, MainCategory, DENSE_RANK() OVER(PARTITION BY MainCategory ORDER BY Metascore DESC) rankingScore
	FROM AnimatedMovies..Animated_vw
)
SELECT Title, Metascore, MainCategory
FROM rankedGenre
WHERE rankingScore = 1;

-- 3. Does long runtime result in better rating/votes, metascore or gross?
	-- The shortest movie is about an hour w/ 6 minutes,  while the longest is 2 hours and 17 minutes.
SELECT RuntimeHour, RuntimeMinute
FROM AnimatedMovies..Animated_vw
ORDER BY RuntimeHour, RuntimeMinute;

	-- Most of the movies are less than an hour, with a total of 77 movies.
SELECT RuntimeHour, COUNT(*) TotalMoviesHour
FROM AnimatedMovies..Animated_vw
GROUP BY RuntimeHour;

------ Gross Analysis
	-- There are only 46 of the 77 movie with gross registered.
SELECT RuntimeHour, COUNT(*) TotalMoviesHour
FROM AnimatedMovies..Animated_vw
WHERE GrossInM IS NOT NULL
GROUP BY RuntimeHour;

	-- Classification of movies with a duration of 1 hour and less than 2 hours.
	-- Kind of expected that the Larger movies have almost the double in gross as they are also the double of movies.
WITH MovieClassGross AS(
	SELECT GrossInM 
		,CASE WHEN RuntimeMinute BETWEEN 1 AND 30 THEN 'S' ELSE 'L' END TimeCategory
	FROM AnimatedMovies..Animated_vw
	WHERE RuntimeHour = 1 AND GrossInM IS NOT NULL
)
SELECT TimeCategory, COUNT(*) AS TotalMovies, AVG(GrossInM) GrossInM
FROM MovieClassGross
GROUP BY TimeCategory;

	-- Top 10 Movies, duration less than an hour by Gross. 
	-- Here we can see that most of the movies, with greater gross, are those movies with a duration of at least one hour and +30 minutes.
SELECT TOP 10 Title, GrossInM, Runtime 
	, CASE WHEN RuntimeMinute BETWEEN 1 AND 30 THEN 'Short' ELSE 'Long' END TimeCategory
	, DENSE_RANK() OVER (ORDER BY GrossInM DESC, Runtime DESC) Ranking
FROM AnimatedMovies..Animated_vw
WHERE RuntimeHour = 1 AND GrossInM IS NOT NULL;

	-- Top 10 Movies, any duration by Gross.
	-- The best ranked movie with duration of more than 2 hours is at place 28.
SELECT Top 10 Title, GrossInM, Runtime, RuntimeHour
	, DENSE_RANK() OVER (ORDER BY GrossInM DESC, Runtime DESC) Ranking
FROM AnimatedMovies..Animated_vw
WHERE GrossInM IS NOT NULL;

------ Rating Analysis
	-- Classification of movies with a duration of 1 hour and less than 2 hours.
	-- This time, the rating seems to be the same for both categories, so we have the "same" quantity of bad movies and good in both categories.
WITH MovieClassRating AS(
	SELECT Rating 
		,CASE WHEN RuntimeMinute BETWEEN 1 AND 30 THEN 'S' ELSE 'L' END TimeCategory
	FROM AnimatedMovies..Animated_vw
	WHERE RuntimeHour = 1
)
SELECT TimeCategory, COUNT(*) AS TotalMovies, CONVERT(decimal(3,2),(AVG(Rating))) Rating
FROM MovieClassRating
GROUP BY TimeCategory;

	-- Top 10 Movies, duration less than an hour by Rating.
	-- Here we can see that most of the movies, only by Rating, do not have a lower value than 7,6.
	-- Also, all of them "enter" into the top when giving same rank when tie.
SELECT Title, Rating, Runtime 
	, CASE WHEN RuntimeMinute BETWEEN 1 AND 30 THEN 'Short' ELSE 'Long' END TimeCategory
	, DENSE_RANK() OVER (ORDER BY Rating DESC) Ranking
FROM AnimatedMovies..Animated_vw
WHERE RuntimeHour = 1;

	-- Top 10 Movies, any duration by Rating.
	-- Contrary to Gross, here two movies with larger runtime enter to the top.
SELECT Top 10 Title, Rating, Runtime, RuntimeHour
	, DENSE_RANK() OVER (ORDER BY Rating DESC, Runtime DESC) Ranking
FROM AnimatedMovies..Animated_vw;

------ Metascore Analysis
	-- Classification of movies with a duration of 1 hour and less than 2 hours.
	-- This time, the Metascore is for lower duration movies.
WITH MovieClassRating AS(
	SELECT Metascore 
		,CASE WHEN RuntimeMinute BETWEEN 1 AND 30 THEN 'S' ELSE 'L' END TimeCategory
	FROM AnimatedMovies..Animated_vw
	WHERE RuntimeHour = 1
)
SELECT TimeCategory, COUNT(*) AS TotalMovies, CONVERT(decimal(5,2),(AVG(Metascore))) Metascore
FROM MovieClassRating
GROUP BY TimeCategory;

	-- Top 10 Movies, duration less than an hour by Metascore.
	-- Here we can see less movies than in Rating, this is due to the critic has a move rigorous criteria than just votes.
WITH AllRankingMeta AS(
	SELECT Title, Metascore, Runtime 
		, CASE WHEN RuntimeMinute BETWEEN 1 AND 30 THEN 'Short' ELSE 'Long' END TimeCategory
		, DENSE_RANK() OVER (ORDER BY Metascore DESC) Ranking
	FROM AnimatedMovies..Animated_vw
	WHERE RuntimeHour = 1
)
SELECT Title, Metascore, Runtime, TimeCategory, Ranking
FROM AllRankingMeta
WHERE Ranking <= 10;

	-- The critic has a slight high preference for longer movies.
WITH AllRankingMeta AS(
	SELECT Title, Metascore, Runtime 
		, CASE WHEN RuntimeMinute BETWEEN 1 AND 30 THEN 'Short' ELSE 'Long' END TimeCategory
		, DENSE_RANK() OVER (ORDER BY Metascore DESC) Ranking
	FROM AnimatedMovies..Animated_vw
	WHERE RuntimeHour = 1
)
SELECT TimeCategory, COUNT(*) TotalMovies
FROM AllRankingMeta
WHERE Ranking <= 10
GROUP BY TimeCategory;

	-- Top 10 Movies, any duration by Metascore.
	-- Similar result than in the ranking of 1 hour.
SELECT Top 11 Title, Metascore, Runtime, RuntimeHour
	, DENSE_RANK() OVER (ORDER BY Metascore DESC, Runtime DESC) Ranking
FROM AnimatedMovies..Animated_vw;