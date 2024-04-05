/* MUSIC STORE ANALYSIS */

/* Q1 Find the top 3 customers who have purchased the most diverse range of genres, considering both individual
	tracks and albums, along with the count of distinct genres they have purchased */	

select c.first_name,c.last_name, count(distinct g.genre_id) as distinct_genres_purchased
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join genre g on t.genre_id = g.genre_id
group by c.customer_id
order by distinct_genres_purchased desc
limit 3

	
/*Q2 which countries have the most invoices? */

select billing_country , count(*) as totalCount
from invoice 
group by billing_country
order by totalCount desc

	
/* Q3 the client wants to throw a promotional music festival where they made the most revenue.
write a query that returns one city that has the highest sum of invoice total. */

select sum(total) as invoiceTotal , billing_city
from invoice 
group by billing_city 
order by invoiceTotal desc 
limit 1

	
/* Q4 Find the top 3 customers who have spent the most on tracks written by a
specific artist, along with the total amount spent */

select c.first_name, c.last_name,sum(il.unit_price * il.quantity) as totalspent
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join album al on t.album_id = al.album_id
join artist a on al.artist_id = a.artist_id
where a.name = 'AC/DC'   --considering AC/DC to be the artist.
group by c.customer_id
order by totalspent desc
limit 3
	
/* Q5 write a query that returns the person who spent the most money ie the best customer . */

select c.customer_id , c.first_name , c.last_name , sum(i.total) as amountSpent
from customer c join invoice i on c.customer_id=i.customer_id
group by c.customer_id
order by amountSpent desc
limit 1


/* Q6 Write a query to return the email, first name, last name and genre of all rock music listeners
Return the list alphabetically by email starting with A */

select distinct c.email, c.first_name, c.last_name
from (customer c join invoice i on c.customer_id=i.customer_id )
join invoice_line il on il.invoice_id=i.invoice_id
where track_id in
	(select track_id 
	from track t join genre g 
	on t.genre_id = g.genre_id
	where g.name like 'Rock')
order by c.email 

	
/* Q7 Write a query that returns the artist name and total track count of the top 10 rock bands. */

select a.name ,a.artist_id,count(a.artist_id)as totalTrackCount
from ((artist a join album al on a.artist_id=al.artist_id)
join track t on t.album_id=al.album_id)
join genre g on g.genre_id=t.genre_id
where g.name like 'Rock'
group by a.artist_id
order by totalTrackCount desc
limit 10


/*Q8 Return all the track names that have a song length longer than the average song length. 
Return the name and milliseconds for each track. Order by the song length with the longest songs listed first. */

select name , milliseconds
from track  
where milliseconds >(select avg(milliseconds)S
	from track )
order by milliseconds desc

	
/* Q9 Find the total revenue generated by each genre */

select g.name, sum(il.Unit_Price * il.Quantity) as TotalRevenue
from (track t join invoice_line il on t.track_id=il.track_id)
	join genre g on g.genre_id=t.genre_id
group by g.name
order by totalRevenue desc


/* Q10 identify artist(s) who have albums in more than one genre,
	along with the count of genres they cover. */

select a.name as artistname, count(distinct g.genre_id) as GenreCount
from ((artist a join album al on a.artist_id=al.artist_id)
    join track t on t.album_id=al.album_id)
    join genre g on g.genre_id = t.genre_id
group by a.artist_id, a.name
having count(distinct g.genre_id) > 1


/* Q11 list the customers who have made purchases in more than one country, 
along with the count of countries they have purchased from. */

select c.first_name , c.last_name , count(distinct i.billing_country) as CountryCount
from customer c join invoice i on c.customer_id=i.customer_id
group by c.customer_id
having count(distinct i.billing_country) > 1


/* Q12 find the total sales revenue for each year, ordered by year */

select extract(year from invoice_date) as year, sum(total) as TotalRevenue
from invoice
group by extract(year from invoice_date)
order by year

/* Q13 who is the senior most employee based on job title? */

select *
from employee
order by levels desc
limit 1

/* Q14 identify the top 5 longest tracks for each genre */

select g.name as genre, t.name as TrackName, t.milliseconds as TrackLength
from genre g join track t on g.genre_id=t.genre_id
where (g.genre_id,t.milliseconds) in
	(select genre_id,milliseconds 
	from track t2
	where t2.genre_id=g.genre_id
	order by milliseconds desc
	limit 5 )
	order by g.name, t.milliseconds desc


/* Q15 identify the customers who have spent more than the average total amount
across all invoices, along with their total spending */

select c.first_name,c.last_name,sum(i.total) as TotalSpending
from customer c join invoice i ON c.customer_id = i.customer_id
group by  c.customer_id
having sum(i.total) > (select avg(total) from invoice)
	

/* Q16 List the customers who have made purchases on weekdays along with the 
count of their purchases. */
	
select c.first_name,c.last_name,count(*) as purchasecount
from customer c join invoice i on c.customer_id = i.customer_id
where extract(DOW from i.invoice_date) between 1 and 5
group by c.customer_id


/* Q17 Find the average total amount spent by customers from each country,rounded to 
	two decimal places, with only countries where the average amount is above the overall average displayed*/

select billing_country as country,round(cast(avg(total) as numeric), 2) as avgtotalamount
from invoice group by billing_country
having avg(total) > (select avg(total) from invoice)
order by avgtotalamount desc

