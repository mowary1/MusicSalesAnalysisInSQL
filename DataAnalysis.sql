USE music_database;
-- Q1 Who is teh senior most employee based on teh job title ?
SELECT * from employee
ORDER BY levels desc
limit 1 ;
-- Q2 Which countries have teh most invoices ?
SELECT COUNT(*) as c ,  billing_country
FROM invoice 
GROUP BY billing_country
ORDER BY c desc  ;
-- Q3 What are the top 3 values for total invoices ?
SELECT total FROM invoice 
ORDER BY total desc 
LIMIT 3 ;
-- Q4 Which City has teh best cutomers ?
-- We would like to through a promotional music festival in the city 
-- that we made the most money in 
-- return the city name , and sum of all invoice total 
 SELECT SUM(total) as the_total_sum , billing_city 
 from invoice 
 group by billing_city
 ORDER BY the_total_sum desc ;
 -- Who is the best cutomer ?  the customer that spent the most money 
 SELECT 
  customer.customer_id, 
  customer.first_name, 
  customer.last_name, 
  SUM(invoice.total) as total 
FROM 
  customer 
JOIN 
  invoice ON customer.customer_id = invoice.customer_id
GROUP BY 
  customer.customer_id, 
  customer.first_name, 
  customer.last_name
ORDER BY 
  total DESC
LIMIT 1;
-- Write query to return the email , first name , last name & Genre of all Rock music listener 
SELECT DISTINCT email , first_name , last_name 
FROM customer 
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
	SELECT track_id FROM track 
    JOIN genre ON track.genre_id = genre.genre_id
    WHERE genre.name LIKE 'Rock'
    )
    ORDER BY email ;

-- Return all the track names taht have song length longer than the average song length , 
-- Return teh name and time for each track order by the song length with the longest songs first 

SELECT name , milliseconds 
FROM track 
WHERE milliseconds >(
	SELECT AVG(milliseconds) AS avg_track_length
    FROM track)
ORDER BY milliseconds DESC ;    

-- Find how much amount spent by each customer on artists ? 
-- return customer name , artist name , and total spent 
WITH best_Selling_artist AS (
   SELECT 
     artist.artist_id AS artist_id, 
     artist.name AS artist_name, 
     SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
   FROM 
     invoice_line
   JOIN 
     track ON track.track_id = invoice_line.track_id
   JOIN 
     album2 ON album2.album_id = track.album_id
   JOIN 
     artist ON artist.artist_id = album2.artist_id
   GROUP BY 
     artist.artist_id, 
     artist.name
   ORDER BY 
     total_sales DESC
   LIMIT 1
)
SELECT 
  c.customer_id, 
  c.first_name, 
  c.last_name, 
  bsa.artist_name, 
  SUM(il.unit_price * il.quantity) AS amount_spent
FROM 
  invoice i 
JOIN 
  customer c ON c.customer_id = i.customer_id
JOIN 
  invoice_line il ON il.invoice_id = i.invoice_id
JOIN 
  track t ON t.track_id = il.track_id
JOIN 
  album2 alb ON alb.album_id = t.album_id
JOIN 
  best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 
  1, 2, 3, 4
ORDER BY 
  5 DESC;
  
  
  
