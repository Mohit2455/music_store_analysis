/*	Question Set 1 - Easy */
-- find who is the senior most emplyee base on the job tiitle?
select * from employee 
order by levels desc
limit 1

-- which country have the most invoices?
select count(*),billing_country from  invoice
group by billing_country

/* Q3: What are top 3 values of total invoice? */
select i.* from invoice as i
order by total desc
limit 3 

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
seLect sum(total) as invoice_total,billing_city 
from invoice
group by billing_city
order by invoice_total desc

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
select c.customer_id,concat(c.first_name,c.last_name) as Full_name ,sum(i.total) as total
from customer as c
join invoice as i on c.customer_id=i.customer_id
group by c.customer_id
order by total desc
limit 3

/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/*Method 1 */
select distinct c.email,c.first_name,c.last_name from customer as c
join  invoice as i on c.customer_id=i.customer_id
join invoice_line as il on i.invoice_id=il.invoice_id
where track_id in(
        select t.track_id from track as t
        join genre as g on t.genre_id=g.genre_id
        where g.name like 'Rock'
)
order by email --or\c.email

/* Method 2 */

SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoiceline ON invoiceline.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoiceline.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
select a.artist_id, a.name, count(a.artist_id) as no_of_songs from track as t
join album as al on al.album_id=t.album_id
join artist as a on a.artist_id= al.artist_id
join genre as g on g.genre_id=t.genre_id
where g.name like 'Rock'
group by a.artist_id
order by no_of_songs desc
limit 10

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
select name, milliseconds from track
where milliseconds >(
	select avg(milliseconds) as avg_milliseconds
	from track 
)
order by milliseconds desc


/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */
WITH best_seller_artist AS (
    SELECT 
        a.artist_id,
        a.name AS artist_name,
        SUM(il.unit_price * il.quantity) AS total_sales
    FROM invoice_line AS il
    JOIN track AS t 
        ON t.track_id = il.track_id
    JOIN album AS al 
        ON al.album_id = t.album_id
    JOIN artist AS a 
        ON a.artist_id = al.artist_id
    GROUP BY 1
    ORDER BY 3 DESC
    LIMIT 1			/*(select a.artist_id,=1 a.name as artist_name=2
					sum(il.unit_price*il.quantity)as total_tales=3
					from invoice_line as il)*/
)

select c.customer_id, c.first_name, c.last_name,bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent
from invoice as i
join customer as c
	on c.customer_id=i.customer_id
join invoice_line as il
	on il.invoice_id=i.invoice_id
join track as t 
	on t.track_id=il.track_id
join album as al
	on al.album_id=t.album_id
join best_seller_artist as bsa
	on bsa.artist_id=al.artist_id
group by 1,2,3,4
order by 5 desc

/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

/* Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level. */

/* Method 1: Using CTE */
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */

/* Method 1: using CTE */
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1









