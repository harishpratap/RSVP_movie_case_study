USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 'director_mapping' AS TableName, COUNT(*) AS RowCount FROM director_mapping
UNION ALL
SELECT 'genre' AS TableName, COUNT(*) AS RowCount FROM genre
UNION ALL
SELECT 'movie' AS TableName, COUNT(*) AS RowCount FROM movie
UNION ALL
SELECT 'names' AS TableName, COUNT(*) AS RowCount FROM names
UNION ALL
SELECT 'ratings' AS TableName, COUNT(*) AS RowCount FROM ratings
UNION ALL
SELECT 'role_mapping' AS TableName, COUNT(*) AS RowCount FROM role_mapping;








-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_NULL_Count,
SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_NULL_Count,
SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_NULL_Count,
SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_NULL_Count,
SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_NULL_Count,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_NULL_Count,
SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_NULL_Count,
SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_NULL_Count,
SUM(CASE WHEN production_company is NULL THEN 1 ELSE 0 END) AS production_company_NULL_Count
from movie;





-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- NUmber of movies by year
select year,count(id) as number_of_movies
from movie
group by year
order by year;

-- Number of movies by month
select month(date_published) month_num,count(id) as number_of_movies
from movie
group by month(date_published)
order by month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(id) as movie_count
from movie
where year = 2019
and (country like '%USA%' or country like '%India%');


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct genre from genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre,count(id) as movie_count
from movie
inner join genre on id = movie_id
group by genre
order by movie_count desc;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select count(movie_id)
from (
select movie_id,count(genre) genre_count
from genre
group by movie_id) as q
where  genre_count =1;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre, round(avg(duration),2) as avg_duration
from movie inner join genre on id = movie_id
group by genre
order by avg_duration desc;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select genre,movie_count, genre_rank
from (
select genre , count(movie_id) as movie_count,
		rank() over(order by count(movie_id) desc) as genre_rank
from genre
group by genre
) q
where genre = 'Thriller';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select min(avg_rating) as min_rating,
	   max(avg_rating) as max_rating,
       min(total_votes) as min_votes,
       max(total_votes) as max_votes,
       min(median_rating) as min_median_rating,
       max(median_rating) as max_median_rating
       from ratings;
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

select title , avg_rating, movie_rank
from (
select title , avg_rating , row_number() over(order by avg_rating desc) as movie_rank
from movie inner join ratings on id = movie_id
group by title,avg_rating ) q
where movie_rank < 11;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
select median_rating,count(movie_id) as movie_count
from ratings
group by median_rating
order by movie_count desc;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
select production_company, count(id) as movie_count , rank() over(order by count(id) desc ) prod_company_rank
from movie inner join ratings on id = movie_id
where avg_rating>8
and production_company is not null
group by production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select genre,count(movie_id) as movie_count
from movie inner join genre 
on id = movie_id 
inner join ratings using(movie_id)
where total_votes>1000
and year = 2017
and country like '%USA%'
and month(date_published) =3
group by genre
order by movie_count desc
;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select title,avg_rating, genre
from movie m inner join ratings r on m.id = r.movie_id
inner join genre g on id = g.movie_id 
where title like 'The%'
and avg_rating >8
order by avg_rating desc ;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(id)
from movie inner join ratings on id = movie_id
where date_published between '2018-04-01' and '2019-04-01'
and median_rating =8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select country,sum(total_votes)
from movie inner join ratings on id = movie_id
where country in('Germany','Italy')
group by country;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select 
		sum(case when id is null then 1 else 0 end) as id_null,
        sum(case when name is null then 1 else 0 end) as name_null,
        sum(case when height is null then 1 else 0 end) as height_null,
        sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_null,
        sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_null
from names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH Top3_Genre AS (
    SELECT
        genre,
        COUNT(m.id) AS Movie_count
    FROM
        movie m
    INNER JOIN
        genre g ON m.id = g.movie_id
    INNER JOIN
        ratings r ON r.movie_id = m.id
    WHERE
        avg_rating > 8
    GROUP BY
        genre
    ORDER BY
        Movie_count DESC
    LIMIT 3
)
SELECT
    n.name AS director_name,
    COUNT(m.id) AS Movie_count
FROM
    movie m
INNER JOIN
    director_mapping d ON m.id = d.movie_id
INNER JOIN
    names n ON n.id = d.name_id
INNER JOIN
    genre g ON g.movie_id = m.id
INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    g.genre IN (SELECT genre FROM Top3_Genre)
    AND avg_rating > 8
GROUP BY
    director_name
ORDER BY
    Movie_count DESC
LIMIT 3;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select name as actor_name, count(m.id) as movie_count
from movie m inner join ratings r on id = r.movie_id
inner join role_mapping rm on rm.movie_id = m.id
inner join names n on rm.name_id = n.id
where median_rating >=8
group by actor_name
order by movie_count desc
limit 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select * from 
(
select production_company , sum(total_votes) as vote_count , row_number() over(order by sum(total_votes) desc) as prod_comp_rank
from movie inner join ratings on id = movie_id
group by production_company
) q
where prod_comp_rank<4
;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name as actor_name, sum(total_votes) as total_votes , count(m.id) as movie_count, round(sum( avg_rating * total_votes)/ sum(total_votes),2) as actor_avg_rating ,
		row_number() over(order by sum( avg_rating * total_votes)/ sum(total_votes) desc) as actor_rating
from movie m inner join ratings r on m.id = r.movie_id
inner join role_mapping rp on m.id = rp.movie_id
inner join names n on rp.name_id = n.id
where country like '%India%'
and rp.category = 'actor'
group by n.name
having count(m.id) >=5 ;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
select * from 
(
select n.name as actress_name,
		sum(total_votes) as total_votes ,
        count(m.id) as movie_count,
        round(sum( avg_rating * total_votes)/ sum(total_votes),2) as actress_avg_rating ,
		row_number() over(order by sum( avg_rating * total_votes)/ sum(total_votes) desc) as actress_rating
from movie m inner join ratings r on m.id = r.movie_id
inner join role_mapping rp on m.id = rp.movie_id
inner join names n on rp.name_id = n.id
where country like '%India%'
and languages like '%Hindi%' 
and rp.category = 'actress'
group by n.name
having count(m.id) >=3
) q
where actress_rating <6;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

select title as movie_name,
      case 
      when avg_rating >8 then 'Superhit'
      when avg_rating >=7 and avg_rating <=8 then 'Hit'
      when avg_rating >=5 and avg_rating < 7 then 'One-time-watch'
      when avg_rating <5 then 'Flop'
      end as movie_category 
from movie m inner join ratings on m.id = movie_id
inner join genre g on m.id = g.movie_id
where genre = 'Thriller'
and total_votes >= 25000
order by avg_rating desc;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select genre,
		round(avg(m.duration),2) as avg_duration,
		sum(round(avg(m.duration),2)) over(order by genre ) as running_total_duration,
		ROUND(AVG(AVG(duration)) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
from movie m inner join genre on id = movie_id
group by genre
order by genre ;

-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

with top_3genre as
(
select genre,count(movie_id) movie_count
from genre
group by genre
order by movie_count desc
limit 3
)
select * from 
(
select  genre,
		year,
        title as movie_name,
        worlwide_gross_income as worldwide_gross_income,
        row_number() over(partition by year order by worlwide_gross_income desc ) as movie_rank
from movie m inner join genre on id = movie_id
where genre in (select genre from top_3genre)
) q
where movie_rank <=5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
select production_company,
	   count(id) as movie_count ,
       row_number() over(order by count(id) desc) as prod_comp_rank
from movie inner join ratings on id = movie_id
where median_rating >=8
and production_company is not null
and position(',' in languages)>0
group by production_company
limit 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
select 
		name as actress_name ,
        sum(total_votes) as total_votes,
        count(m.id) as movie_count,
        round(avg(avg_rating),2) as actress_avg_rating,
        row_number() over(order by count(m.id) desc) as actress_rank
from movie m inner join ratings r on m.id = r.movie_id
inner join role_mapping rm on m.id = rm.movie_id
inner join names n on rm.name_id = n.id
inner join genre g on m.id = g.movie_id
where avg_rating >8
and genre = 'Drama'
and category = 'Actress'
group by name
order by movie_count desc
limit 3;





/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with avg_days_director as
(
select
	director_id ,
	director_name,
    round(avg(DATEDIFF(next_movie_date,movie_date)),2) as avg_inter_movie_days

from 
(
select 
	dm.name_id as director_id ,
	n.name as director_name,
	m.date_published AS movie_date,
    LEAD(m.date_published, 1) OVER (PARTITION BY n.name ORDER BY m.date_published) AS next_movie_date
from movie m inner join ratings r on m.id = r.movie_id
inner join director_mapping dm on m.id = dm.movie_id
inner join names n on dm.name_id=n.id
) inter_movie_days
group by director_id ,director_name
), top_9director as 
( select
	name_id as director_id ,
	name as director_name,
    count(m.id) as movie_count,
    round(avg(avg_rating),2) as avg_ratings,
    sum(total_votes) as total_votes,
    min(avg_rating) as min_rating,
    max(avg_rating) as max_rating,
    sum(duration) as total_duration
from movie m  inner join ratings r on m.id = r.movie_id
inner join director_mapping dm on m.id = dm.movie_id
inner join names n on dm.name_id=n.id
group by director_id ,director_name

) 	
select 
    t.director_id as director_id,
    t.director_name as director_name,
    t.movie_count as number_of_movies,
	av.avg_inter_movie_days as avg_inter_movie_days,
    t.avg_ratings,
    t.total_votes as total_votes,
    t.min_rating,
    t.max_rating,
    t.total_duration 
from
movie m inner join ratings r on m.id = r.movie_id
inner join director_mapping dm on m.id = dm.movie_id
inner join avg_days_director av on av.director_id = dm.name_id
inner join top_9director t on t.director_id = dm.name_id
group by director_id ,director_name,avg_inter_movie_days
order by movie_count desc  
limit 9
;

