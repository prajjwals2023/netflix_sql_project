-- Netfix Project


CREATE TABLE netflix
(
    show_id varchar(6),
    type varchar(10),
    title varchar(150),
    director varchar(210),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)

)

select  count(*) as total from netflix;


-- 15 Buisness Problem

-- 1.Count the Number of Movies vs TV Shows

Select type,COUNT(*) as total_count from netflix group by type;

--2. Find the Most Common Rating for Movies and TV Shows

SELECT type, rating, total_count
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS total_count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk
    FROM netflix
    GROUP BY type, rating
) t
WHERE rnk = 1;


--3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT * FROM netflix
where 
type='Movie'
AND
release_year =2020;

--4. Find the Top 5 Countries with the Most Content on Netflix

SELECT 
UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
count(*) as total_count
from netflix
GROUP BY new_country
ORDER BY total_count DESC
LIMIT 5;

-- 5. Identify the Longest Movie

 SELECT * FROM netflix 
 WHERE 
 type='Movie'
 AND
 duration =(SELECT MAX(duration) from netflix);

 -- 6. Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
 
-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';


-- 8. List All TV Shows with More Than 5 Seasons

SELECT * FROM netflix
WHERE 
type='TV Show'
AND
SPLIT_PART(duration,' ',1) :: INT>5;


--9. Count the Number of Content Items in Each Genre

SELECT 
UNNEST(STRING_TO_ARRAY(listed_in,' ')) as genre,
count(*) as total_count
from netflix
group by genre;

--10.Find each year and the average numbers of content release in India on netflix.

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

-- 11. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

-- 12. Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director IS NULL;


-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;


-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;






