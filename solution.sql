-- Netflix project
DROP TABLE IF EXISTS netflix;
CREATE TABLE  netflix
(
   show_id VARCHAR(6),
   type VARCHAR(10),
   tittle VARCHAR(150),
   director VARCHAR(208),
   casts VARCHAR(1000),
   country VARCHAR(150),
   data_added VARCHAR(50),
   release_year INT, 
   rating  VARCHAR(10),
   duration  VARCHAR(15),
   listed_in  VARCHAR(100),
   description  VARCHAR(250)
 );

 SELECT * FROM netflix;

 SELECT 
     COUNT(*) as  total_content
 FROM NETFLIX;


  SELECT 
     DISTINCT type
 FROM NETFLIX;


 SELECT * FROM netflix

-- 15 Business Problems 

1. Count the number of Movies vs TV Shows 

Select 
   type ,
   count (*) as total_cintent
from netflix 
group by type 


 2.  Find the most common rating for movies and TV shows 

select
   type,
   rating 
from 
(
 Select
     type,
	 rating,
	 Count (*),
	 rank() over (partition by type  order by count (*)  desc) as ranking 
from netflix
group by 1,2
) as t1
where
    ranking = 1 

3. List all the movies released in a specific year (e.g. , 2020)

Select * from netflix 
where
    type = 'Movie'
	and
	release_year = 2020


4.  Find top 5  countries with the most content on netflix 


select
    unnest(string_to_array (country, ' ,')) as new_country ,
	count(show_id) as  total_content
from netflix
group by 1
order by 2 desc
limit 5

5. Identify the Longest  Movie ?

select * from netflix 
where 
   type = 'Movie'
   and
   duration = (select max (duration) from  netflix)


6. Find content added in the last 5  years 

select
    * 
from netflix 
where
     TO_DATE(date_added , 'Month DD, YYYY') >= current_date - interval '5years'

select current_date - interval '5 years'



7. Find all the movies/ TV showa by director 'Rajiv Chilaka'!

SELECT * FROM netflix 
WHERE director ILike '%Rajiv Chilaka%'


8. List all TV shows with more than  5  seasons 


select 
    * 
from netflix
where 
   type  = 'TV Show'
   and 
   split_part(duration , ' ' , 1 ) :: numeric > 5 


9.  Count the Number of content  items in each  genre 

select  
  unnest (string_to_array (listed_in , ',' )) as genre ,
  count (show_id) as total_content
from netflix
group by 1 

10. Find eac year and the average number of content release  in  India on netflix , return 
top 5 year wit highest avg  content release 

-- TOTAL CONTENT 333/972

select
     EXTRACT(year from To_Date ( date_added , " Month DD, YYYY")) as year ,
     count (*) as   yearly_content ,
	 round(
     count(*):: numeric / (select count (*) from netflix where  country = 'India') :: numeric * 100
	 , 2 ) as avg_content_per_year
from netflix
where country = 'India'
group  by 1 


11. List all Movies that are documentaries


select *  from netflix
where 
    listed_in ILIKE '%documentaries%'

	
 12. Find all content without a director


 select *  from netflix
where
    director IS NULL 
	
13.  Find how mmany movies actor 'Salman Khan' appeared in last  10 years !

Select * from  netflix
where
  casts ILIKE '%Salman Khan%'
  AND 
  release_year  > Extract (year from current_date) - 10

14.  Find the top 10 actors who ahve appeared in the  highest number of movies produced in India


select 
unnest (string_to_array(casts , ',')) as actors,
count (*) as total_content
from netflix
where country ILIKE  '%india'
group by 1
order by 2 desc
limit 10


15 .  Categorize the content based on the presense of the keywords 'kill' and 'violence' in the description 
field . Label content containing these keywords as 'Bad' and all other content as 'Good' . Count how many 
items  fall in each category . 


With new_table
as
(
select
* , 
   case
   when
       description ILIKE '%kills%' OR
	   description ILIKE  '%violence%'  then 'Bad_Content'
       Else 'Good Content'
	 end category
from netflix
)
select 
   category,
   count (*) as total_content
  from new_table
  group by 1









 