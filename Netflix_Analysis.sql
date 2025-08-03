select * from netflix_raw nr
WHERE nr.country is null and nr.director LIKE ('%Sara Colangelo%')

WHERE show_id='s5023';


-- Handling Foreign Characters
-- Remove Duplicates

select show_id, count(*) 
from netflix_raw
GROUP BY show_id 
having COUNT(*) > 1

SELECT * FROM netflix_raw
WHERE concat(upper(title), type) in(
	select concat(upper(title), type)
	from netflix_raw
	GROUP BY upper(title), type
	having COUNT(*) > 1
)
order by title

-- gives without repetition in titles
-- final clean data
WITH cte as(
SELECT * 
,ROW_NUMBER() over(partition by title, type order by show_id) as rn
from netflix_raw
)
-- not taking diretor and cast.. because we already made a separate dataset
select show_id, type, title, cast(date_added as date) as date_added, release_year,
rating, case when duration is null then rating else duration end as duration, description
into netflix_stg
from cte

select * from netflix_stg

-- New table for listed in, director, country, cast

SELECT show_id, trim(value) as director
-- into used for creating a new table
into netflix_directors
FROM netflix_raw
cross apply string_split(director, ',')


SELECT * FROM netflix_directors

-- TRIM() removes the space or character from start to ending
SELECT show_id, trim(value) as country
into netflix_country
FROM netflix_raw
cross apply string_split(country, ',')

SELECT *
FROM netflix_raw
WHERE show_id = 's1001'

SELECT show_id, trim(value) as cast
into netflix_cast
FROM netflix_raw
cross apply string_split(cast, ',')


SELECT show_id, trim(value) as genre
into netflix_genre
FROM netflix_raw
cross apply string_split(listed_in, ',')

SELECT * FROM netflix_country

-- data type conversions for date added

-- populate missing values in country duration columns
insert into netflix_country
SELECT show_id, m.country
FROM netflix_raw nr
inner join (
SELECT director, country
FROM netflix_country nc
inner join netflix_directors nd on nc.show_id=nd.show_id
group by director, country
) m on nr.director=m.director
WHERE nr.country is null

select *
from netflix_country n 
where n.show_id = 's113'

-- use the other non null value to fill the null value
SELECT * from netflix_raw WHERE director = 'Ahishor Solomon'

SELECT director, country
FROM netflix_country nc
inner join netflix_directors nd on nc.show_id=nd.show_id
group by director, country
ORDER BY director

SELECT show_id, country
FROM netflix_country

--------
select * from netflix_raw where duration is null







--netflix data analysis

/*1 for each director count the no of movies and tv shows created by them in separate columns
for directors who have created tv shows and movies both */

----find directors who have created tv shows and movies both
SELECT nd.director,
count(distinct case when n.type='Movie' then n.show_id end) as no_of_movies,
count(distinct case when n.type='TV show' then n.show_id end) as no_of_tvshow
FROM netflix_stg n
inner join netflix_directors nd on n.show_id=nd.show_id
GROUP BY nd.director 
HAVING COUNT(distinct n.type) > 1



--2 which country has highest number of comedy movies

SELECT top 1 country, count(DISTINCT ng.show_id) as no_of_movies
FROM netflix_stg n
inner join netflix_genre ng on n.show_id=ng.show_id
inner join netflix_country nc on n.show_id=nc.show_id
WHERE n.type = 'Movie'
AND ng.genre = 'Comedies'
GROUP BY nc.country
ORDER BY no_of_movies desc

SELECT * FROM netflix_stg
--3 for each year (as per date added to netflix), which director has maximum number of movies released
WITH cte AS (
    SELECT 
        nd.director, 
        YEAR(date_added) AS date_year,  
        COUNT(nd.show_id) AS no_of_movies
    FROM netflix_stg n
    INNER JOIN netflix_directors nd ON n.show_id = nd.show_id
    WHERE type = 'Movie'
    GROUP BY nd.director, YEAR(date_added)
),
cte2 AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY date_year ORDER BY no_of_movies DESC, director) AS rn
    FROM cte
)
SELECT * FROM cte2 WHERE rn=1

--4 what is average duration of movies in each genre
SELECT ng.genre, avg(cast(REPLACE(duration, ' min', '') AS int)) as avg_duration
FROM netflix_stg n
INNER JOIN netflix_genre ng on n.show_id=ng.show_id
WHERE type='Movie'
GROUP BY ng.genre

--5 find the list of directors who have created horror and comedy movies both
SELECT nd.director
, count(distinct case when ng.genre='comedies' then n.show_id end) as no_of_comedy
, count(distinct case when ng.genre='Horror Movies' then n.show_id end) as no_of_horror
from netflix_stg n
inner join netflix_genre  ng on n.show_id=ng.show_id
inner join netflix_directors nd on n.show_id=nd.show_id
where type = 'Movie' and ng.genre in ('Comedies', 'Horror Movies')
group by nd.director
having count(distinct ng.genre) = 2


