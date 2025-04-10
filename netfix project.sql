create database netflix_insights;
use netflix_insights;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

set sql_safe_updates=1;

SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv'
INTO TABLE netflix
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

SELECT * FROM netflix;
SELECT count(*) FROM netflix;
SELECT DISTINCT TYPE FROM netflix;

--15 business problems--

1. Count the Number of Movies vs TV Shows
	SELECT 
		type, COUNT(*) AS count
	FROM
		netflix
	GROUP BY type;

2. Find the Most Common Rating for Movies and TV Shows
--count of ratings based on type
	SELECT 
		type, rating, count(*) as count, 
		rank() over(partition by type order by count(*) desc ) as ranking
	FROM    
		netflix
	GROUP BY type,rating;
	SELECT 
		type,
		rating AS most_frequent_rating
	FROM (
		SELECT 
			type, rating, count(*) as count, 
			rank() over(partition by type order by count(*) desc ) as ranking
		FROM    
			netflix
		GROUP BY 
			type,rating
		) as ranking_table
	WHERE ranking = 1;

3. List All Movies Released in a Specific Year (e.g., 2020)
	SELECT 	
		title 
	FROM 
		netflix
	WHERE 
		type="Movie" AND release_year=2020;
        
4. Find the Top 5 Countries with the Most Content on Netflix
    
	CREATE TABLE 
		numbers (n INT);
	INSERT INTO 
		numbers (n)
	VALUES 
		(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

	select* from numbers;
    
	SELECT 
		country_name , COUNT(show_id) AS total_content
	FROM(
		SELECT 
			show_id,
			TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', n.n), ',', -1)) AS country_name
		FROM 
			netflix
		JOIN 
			numbers n ON n.n <= 1 + LENGTH(netflix.country) - LENGTH(REPLACE(netflix.country, ',', ''))
		WHERE 
			country IS NOT NULL AND country != ''
            ) As Country
	GROUP BY country_name
    ORDER BY total_content DESC
    LIMIT 5;
    
5. Identify the Longest Movie
	
	SELECT 
	   title, duration
	FROM 
		netflix
	WHERE 
		type = 'Movie'
	ORDER BY 
		CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC;
    
6. Find Content Added in the Last 5 Years

	SELECT *
	FROM netflix
	WHERE 
		STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;

7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

	SELECT 
		title
	FROM(
		SELECT 
			show_id,
			TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(director, ',', n.n), ',', -1)) AS director_name
		FROM 
			netflix
		JOIN 
			numbers n ON n.n <= 1 + LENGTH(netflix.director) - LENGTH(REPLACE(netflix.director, ',', ''))
		WHERE 
			director IS NOT NULL AND director != ''
            ) As Director
	JOIN netflix nfx ON nfx.show_id = Director.show_id
	WHERE director_name="Rajiv Chilaka";
    
8. List All TV Shows with More Than 5 Seasons

	SELECT 
	   title, duration
	FROM 
		netflix
	WHERE 
		type = 'TV Show'
        AND duration LIKE '%Season%' 
        AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 4
	ORDER BY 
		CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC;
        
9. Count the Number of Content Items in Each Genre

	SELECT 
		Genre, COUNT(show_id) AS total_content
	FROM(
		SELECT 
			show_id,
			TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre
		FROM 
			netflix
		JOIN 
			numbers n ON n.n <= 1 + LENGTH(netflix.listed_in) - LENGTH(REPLACE(netflix.listed_in, ',', ''))
		WHERE 
			listed_in IS NOT NULL AND listed_in != ''
            ) As Genre
	GROUP BY genre;

10.Find each year and the average numbers of content release in India on netflix.

	SELECT 
		country,
		release_year,
		COUNT(show_id) AS release_count,
		ROUND(
			COUNT(show_id) * 100.0 / 
			(SELECT COUNT(show_id) FROM netflix WHERE country = 'India'),
			2)
		 AS avg_release
    FROM 
		netflix
	WHERE 
		country = 'India'
	GROUP BY 
		country, release_year
	ORDER BY 
		avg_release DESC
	LIMIT 5;
