use SPOTIFY_SQL_DATA_ANALYSIS_PROJECT;

-- 1. Who is the senior most employee based on job title?

select * from employee
where reports_to is null;

-- 2. Which countries have the most Invoices?

	select c.country, count(i.invoice_id) as TotalInvoices from customer c inner join invoice i
	on c.customer_id=i.customer_id
	group by c.country
	order by TotalInvoices desc;

-- 3. What are top 3 values of total invoice?

select invoice_id, customer_id, invoice_date, billing_country, total 
from invoice 
order by total desc 
limit 3;

-- 4. Which city has the best customers? We would like to throw a promotional Music.

SELECT c.city, SUM(i.total) AS TotalRevenue
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.first_name, c.last_name, c.city
ORDER BY TotalRevenue DESC
LIMIT 1;


-- 5. Who is the best customer? The customer who has spent the most money will be declared the best
-- customer. Write a query that returns the person who has spent the most money.

select c.customer_id,c.first_name, c.last_name, sum(i.total) as MaxAmount  from invoice i
inner join customer c on i.customer_id = c.customer_id
group by c.customer_id,c.first_name, c.last_name
order by MaxAmount desc
limit 1;

-- 6 Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return
-- your list ordered alphabetically by email starting with A.

select DISTINCT c.email, c.customer_id,c.first_name, c.last_name, g.name as genre
from customer c
inner join invoice i 
	on c.customer_id = i.customer_id
inner join invoice_line l 
	on i.invoice_id = l.invoice_id
inner join track t 
	on l.track_id= t.track_id
inner join genre g 
	on t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;

-- 7. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that
-- returns the Artist name and total track count of the top 10 rock bands.

select a.artist_id, a.name, g.name, count(t.track_id) as RockTrackCount
from genre g
inner join track t
	on g.genre_id=t.genre_id
inner join album al
	on al.album_id= t.album_id
inner join artist a
	on a.artist_id= al.artist_id
  where g.name='Rock'
  GROUP BY a.artist_id, a.name
ORDER BY RockTrackCount DESC
LIMIT 10;


set sql_safe_updates=0;
 -- 3. Return all the track names that have a song length longer than the 
 -- average song length. Return the Name and Milliseconds for each track. 
 -- Order by the song length with the longest songs listed first.
    
    select name as TrackName, bytes as lengthofSong from track 
    where bytes >
    (select  avg(bytes)  from track);
        
--

with AvgTrackLength  as(
	select avg(bytes) AS AvgBytes from track
)
select t.name as TrackName , a.AvgBytes from track t	
inner join AvgTrackLength a

where t.bytes > a.AvgBytes;

-- 1. Find how much amount spent by each customer on artists? 
-- Write a query to return customer name, artist name and total spent.

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    a.name AS ArtistName,
    SUM(l.unit_price * l.quantity) AS TotalSpent
FROM customer c
JOIN invoice i 
    ON c.customer_id = i.customer_id
JOIN invoice_line l 
    ON i.invoice_id = l.invoice_id
JOIN track t 
    ON l.track_id = t.track_id
JOIN album al 
    ON t.album_id = al.album_id
JOIN artist a 
    ON al.artist_id = a.artist_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name,
    a.artist_id, a.name
ORDER BY CustomerName, TotalSpent DESC;

--
select * from
(
		select concat(c.first_name, ' ', c.last_name) as CustomerName ,
		a.name as ArtistName, 
		sum(l.unit_price * l.quantity) as TotalSpend,
        dense_rank() over (partition by c.customer_id  
        ORDER BY SUM(l.unit_price * l.quantity ) desc) as rnk
        from
		customer c
		inner join invoice i      on c.customer_id=i.customer_id
		inner join invoice_line l on i.invoice_id = l.invoice_id
		inner join track t        on l.track_id=t.track_id
		inner join album al       on t.album_id=al.album_id
		inner join artist a       on al.artist_id=a.artist_id
         GROUP BY c.customer_id, c.first_name, c.last_name, a.artist_id, a.name
) t
WHERE rnk = 1;



-- 2. We want to find out the most popular music Genre for each country.
-- We determine the most popular genre as the genre with the highest amount of purchases.
-- Write a query that returns each country along with the top Genre. 
-- For countries where the maximum number of purchases is shared return all Genres.


select 	country,GenreName,PurchaseCount from (

select c.country, g.name AS GenreName, COUNT(l.invoice_line_id) AS PurchaseCount,
 dense_rank() over ( partition by c.country ORDER BY COUNT(l.invoice_line_id) DESC
 ) AS rnk
from 
customer c
inner join invoice i      on c.customer_id = i.customer_id
inner join invoice_line l on i.invoice_id  = l.invoice_id
inner join track t        on l.track_id    = t.track_id
inner join genre g		  on t.genre_id		= g.genre_id
GROUP BY c.country, g.genre_id, g.name
) t

WHERE rnk = 1
ORDER BY country;


-- 3. Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount.


with customer_spending as (
 select
  c.Country,
  c.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
  SUM(i.Total) AS TotalSpent
 from customer c 
 inner join invoice i on c.customer_id=i.customer_id
 group by c.Country,c.customer_id
),
ranked_customers AS (

	select *, rank() over (partition by country order by TotalSpent desc) as spending_rank
    from customer_spending
)

SELECT 
    Country,
    CustomerName,
    TotalSpent
FROM ranked_customers
WHERE spending_rank = 1
ORDER BY Country;























