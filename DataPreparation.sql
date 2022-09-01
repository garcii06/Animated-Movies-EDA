/*
	For the following project consist in:
	Creating a view with semiclean information of:
		Rating to 1 decimal.
		Gross in a numeric data type.
		Runtime in a numeric data type.
		No Description column as I wont be using it for the moment.
*/

-- General preview of the first 25 entries of the data set.
SELECT TOP 25 *
FROM AnimatedMovies..Animated;

-- Check for duplicates, in this case we do not have any exact duplicates.
SELECT Title, COUNT(*) duplicates
FROM AnimatedMovies..Animated
GROUP BY Title
HAVING COUNT(*) > 1;

-- Cleaning the Rating Column, where we just need to convert into a decimal format with one place after the decimal place.
SELECT Title, Rating, CONVERT(decimal(2,1), Rating) CleanRating
FROM AnimatedMovies..Animated;

-- Cleannig the Gross Column, in this case we just one the numeric part.
-- We can use several functions, the most straightforward might be replace.
SELECT Title, Gross, CONVERT(decimal(5, 2), REPLACE(REPLACE(Gross, '$',''),'M','')) CleanGrossInM
FROM AnimatedMovies..Animated;

-- Cleaning the Runtime Columnm, will be a similar process as in the gross case.
SELECT Title, Runtime, CONVERT(int, REPLACE(Runtime, 'min','')) CleanRuntime
FROM AnimatedMovies..Animated;

CREATE VIEW Animated_vw AS
SELECT Title
	, CONVERT(decimal(2,1), Rating) Rating
	, Votes
	, CONVERT(decimal(5, 2)
	, REPLACE(REPLACE(Gross, '$',''),'M','')) GrossInM
	, Genre
	, Metascore
	, Certificate
	, Director
	, Year
	, CONVERT(int, REPLACE(Runtime, 'min','')) Runtime
FROM AnimatedMovies..Animated;

/* 
	Semiclean View where we can work now.
	The next steps are:
		Treatment of NULLS on 
		GrossInM, were we might compute the average and insert it or look into the information.
		Metascore, similar case as the Gross Column.
		Certificate, where we might only modify the value with a string of Unknown.
	Also, we can break Runtime into and Hour and Minute Column.	
*/
SELECT *
FROM AnimatedMovies..Animated_vw;

-- Update into the Certificate with a proxy value.
UPDATE Animated_vw 
SET Certificate = 'Unknown'
WHERE Certificate IS NULL;

-- Knowing the Average of Metascore and Gross values in case that we might fill it.
-- Before doing that, we need to know how many values are null, in case of several values it might not be a good solution filling it out.
	-- In Gross Column, we have 35 NULLs, so in this case filling it out with average can't be a good idea.
	-- In Metascore Column, we only have 5 NULLs, in this case we might fill it without a huge impact. 
SELECT SUM(CASE WHEN GrossInM IS NULL THEN 1 ELSE 0 END) TotalGrossNulls
	, COUNT(GrossInM) TotalGrossNonNulls
FROM AnimatedMovies..Animated_vw;

SELECT SUM(CASE WHEN Metascore IS NULL THEN 1 ELSE 0 END) TotalScoreNulls
	, COUNT(Metascore) TotalScoreNonNulls
FROM AnimatedMovies..Animated_vw;

-- Two possible average can be calculated,
	-- First option with the AVG(), where the result is given by SUM(Metascore)/count of NonNulls.	Result 80
	-- Second option will be manually, where the result is given by SUM(Metascore)/COUNT(allValues).Result 76
SELECT AVG(Metascore) AvgScore, SUM(Metascore)/COUNT(*) ManualAvgScore
FROM AnimatedMovies..Animated_vw;

-- Updating the value of the NULLs in Metascore 
UPDATE Animated_vw
SET Metascore = (SELECT AVG(Metascore) FROM AnimatedMovies..Animated_vw)
WHERE Metascore IS NULL;

-- Breaking the Runtime column to Hour and Minute, can be useful depending in the future analysis.
-- Integer division give us the Hour, for Minutes is just the remainder of the integer division.
SELECT Runtime, Runtime/60 RuntimeHour, Runtime%60 RuntimeMinute
FROM AnimatedMovies..Animated_vw;