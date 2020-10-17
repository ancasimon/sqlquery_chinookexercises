--1. `non_usa_customers.sql`: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
select customer.FirstName, customer.LastName, customer.CustomerId, customer.Country
from customer
where customer.Country !='USA'

--2. `brazil_customers.sql`: Provide a query only showing the Customers from Brazil.
select *
from customer cust
where cust.Country = 'Brazil'

--3. `brazil_customers_invoices.sql`: Provide a query showing the Invoices of customers who are from Brazil. 
--The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
select cust.FirstName, cust.LastName, inv.InvoiceId, inv.InvoiceDate, inv.BillingCountry
from invoice inv
	join customer cust
		on inv.CustomerId = cust.CustomerId
where cust.Country = 'Brazil'

--4. `sales_agents.sql`: Provide a query showing only the Employees who are Sales Agents.
select *
from employee emp
where emp.Title like 'sales%'

--5. `unique_invoice_countries.sql`: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
select distinct inv.BillingCountry
from invoice inv

--6. `sales_agent_invoices.sql`: Provide a query that shows the invoices associated with each sales agent. 
--The resultant table should include the Sales Agent's full name. - ANCA Note: Support rep is the same as sales agent!
select cust.SupportRepId, emp.FirstName, emp.LastName, inv.InvoiceId, inv.InvoiceDate, cust.Company, cust.FirstName, cust.LastName
from customer cust
	join employee emp
		on cust.SupportRepId = emp.EmployeeId
			join invoice inv
				on cust.CustomerId = inv.CustomerId


--7. `invoice_totals.sql`: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
--ANCA: for all invoices and customers - Is left join right??
select inv.Total, cust.FirstName, cust.LastName, cust.Country, emp.FirstName, emp.LastName
from invoice inv
	left join customer cust
		on inv.CustomerId = cust.CustomerId
			join employee emp
				on emp.EmployeeId = cust.SupportRepId
	


--8. `total_invoices_year.sql`: How many Invoices were there in 2009 and 2011?
select count(1) as CountOfInvoices, Year(inv.InvoiceDate) as Year
from invoice inv
where Year(inv.InvoiceDate) = 2009 or Year(inv.InvoiceDate) = 2011
--where Year(inv.InvoiceDate) = 2011 
group by Year(inv.InvoiceDate)

--9. `total_sales_year.sql`: What are the respective total sales for each of those years?
select sum(inv.Total) as TotalSales, Year(inv.InvoiceDate) as Year
from Invoice inv
where Year(inv.InvoiceDate) = 2009 or Year(inv.InvoiceDate) = 2011
group by Year(inv.InvoiceDate)

--10. `invoice_37_line_item_count.sql`: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.

select count(1) as CountForInvoiceId37
from InvoiceLine invline
where invline.InvoiceId = 37

--to test:
select *
from InvoiceLine

--11. `line_items_per_invoice.sql`: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. 
--HINT: [GROUP BY](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql)
select count(1) as CountOfLinesPerInvoice, InvoiceId
from InvoiceLine invline
group by invline.InvoiceId

--12. `line_item_track.sql`: Provide a query that includes the purchased track name with each invoice line item.
select invline.InvoiceLineId, invline.TrackId, tr.Name
from InvoiceLine invline
	join Track tr
		on invline.TrackId = tr.TrackId
--order by invline.InvoiceLineId

--13. `line_item_track_artist.sql`: Provide a query that includes the purchased track name AND artist name with each invoice line item.
select invline.InvoiceLineId, tr.Name as [Track Title], ar.Name as [Artist Name]
from InvoiceLine invline
	join Track tr
		on invline.TrackId = tr.TrackId
			join Album al
				on tr.AlbumId = al.AlbumId
					join Artist ar
						on al.ArtistId = ar.ArtistId
order by invline.InvoiceLineId

--14. `country_invoices.sql`: Provide a query that shows the # of invoices per country. 
--HINT: [GROUP BY](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql)
select count(1) as CountOfInvoices, BillingCountry
from Invoice inv
group by BillingCountry


--15. `playlists_track_count.sql`: Provide a query that shows the total number of tracks in each playlist. 
--The Playlist name should be include on the resultant table.
select count(1) as CountOfTracks, Playlist.Name
from PlaylistTrack
	join Playlist
		on Playlist.PlaylistId = PlaylistTrack.PlaylistId
group by Playlist.PlaylistId
order by CountOfTracks

select count(1) as CountOfTracks, PlaylistTrack.PlaylistId
from PlaylistTrack
	join Playlist
		on Playlist.PlaylistId = PlaylistTrack.PlaylistId
group by PlaylistTrack.PlaylistId
order by CountOfTracks

--ANCA: The results in the 2 queries above are different because there are 2 playlists with the same name of 'Music' and 2 with the name 'Movies'
select count(1) as TracksInPlaylist, Playlist.PlaylistId, Playlist.Name
from Playlist
	join PlaylistTrack
		on Playlist.PlaylistId = PlaylistTrack.PlaylistId
group by Playlist.PlaylistId, Playlist.Name



--16. `tracks_no_id.sql`: Provide a query that shows all the Tracks, but displays no IDs. 
--The result should include the Album name, Media type and Genre.
select tr.Name as TrackName, al.Title as AlbumTitle, mt.Name as MediaType, g.Name as Genre
from Track tr
	join Album al
		on tr.AlbumId = al.AlbumId
			join MediaType mt
			on tr.MediaTypeId = mt.MediaTypeId
				join Genre g
					on tr.GenreId = g.GenreId

--17. `invoices_line_item_count.sql`: Provide a query that shows all Invoices but includes the # of invoice line items.
--ANCA: Using a CORRELATED SUBQUERY HERE!!
select Invoice.*,
	(select  count(1)
	from InvoiceLine
	where Invoice.InvoiceId = InvoiceLine.InvoiceId
	) as CountOfInvoiceLines
from Invoice


--18. `sales_agent_total_sales.sql`: Provide a query that shows total sales made by each sales agent.
select emp.FirstName + ' ' + emp.LastName as [Employee Name],
	(select sum(Total)
		from Invoice inv
			join Customer cust
				on inv.CustomerId = cust.CustomerId
		where cust.SupportRepId = emp.EmployeeId 
	) as TotalSalesByEmployee
from Employee emp
where emp.Title like 'sales support agent'

select *
from Employee


--19. `top_2009_agent.sql`: Which sales agent made the most in sales in 2009? 
--HINT: [TOP](https://docs.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql)
select Top 1 emp.FirstName + ' ' + emp.LastName as [Employee Name],
	(select sum(Total)
		from Invoice inv
			join Customer cust
				on inv.CustomerId = cust.CustomerId	
		where cust.SupportRepId = emp.EmployeeId and Year(inv.InvoiceDate) = 2009
		) as TotalSales
from Employee emp
order by TotalSales desc

select *
from Employee

--20. `top_agent.sql`: Which sales agent made the most in sales over all?

select Top 1 emp.FirstName + ' ' + emp.LastName as [Employee Name],
	(select sum(Total)
		from Invoice inv
			join Customer cust
				on inv.CustomerId = cust.CustomerId	
		where cust.SupportRepId = emp.EmployeeId
		) as TotalSales
from Employee emp
order by TotalSales desc

--21. `sales_agent_customer_count.sql`: Provide a query that shows the count of customers assigned to each sales agent.
select emp.FirstName + ' ' + emp.LastName as [Employee Name], emp.EmployeeId,
	(select count(1)
	from Customer cust
	where cust.SupportRepId = emp.EmployeeId
	) as CustomerCount
from Employee emp
where emp.Title like 'sales support agent'

--Anca: running query below to check results:
select *
from Customer
where SupportRepId = 3

--22. `sales_per_country.sql`: Provide a query that shows the total sales per country.
select BillingCountry, sum(Total) as TotalSales
from Invoice
group by BillingCountry
order by TotalSales

--23. `top_country.sql`: Which country's customers spent the most?
select Top 1 BillingCountry, sum(Total) as TotalSales
from Invoice
group by BillingCountry
order by TotalSales desc

--24. `top_2013_track.sql`: Provide a query that shows the most purchased track of 2013. ANCA: This is correct - they were all sold only once ...
select Top 1 count(1) as CountOfTrackPurchases, InvoiceLine.TrackId, Track.Name
--select *
from InvoiceLine
	join Invoice
		on Invoice.InvoiceId = InvoiceLine.InvoiceId
			join Track
				on InvoiceLine.TrackId = Track.TrackId
where Year(Invoice.InvoiceDate) = 2013
group by InvoiceLine.TrackId, Track.Name
order by CountOfTrackPurchases desc
--ANCA: This doesn't seem quite accurate ... if all have a count of 1 - shouldn't it show all the tracks?? Nope!

select *
from InvoiceLine
where InvoiceLine.TrackId = 443

select *
from Track
where Track.Name like 'shock me'

--25. `top_5_tracks.sql`: Provide a query that shows the top 5 most purchased songs.

select Top 5 count(1) as TimesSold, InvoiceLine.TrackId, Track.Name
from InvoiceLine
	join Track
		on InvoiceLine.TrackId = Track.TrackId
group by invoiceLine.TrackId, track.Name
order by TimesSold desc

--ANCA: suggestion from Nathan below:
--select InvoiceLine.TrackId
--from InvoiceLine
--where InvoiceLine.TrackId = (select Top 1 count(1) TimesSold
--								from InvoiceLine
--								order by TrackId)



--26. `top_3_artists.sql`: Provide a query that shows the top 3 best selling artists. We should add the multiplication by quantity - even though in this case it doesn't matter because all the tracks got sold only once:
select top 3 count(1) as TracksSold, sum(InvoiceLine.UnitPrice * InvoiceLine.Quantity) as TotalSalesByArtist, Artist.Name
--select *
from InvoiceLine
	join Track
		on InvoiceLine.TrackId = Track.TrackId
			join Album
				on Track.AlbumId = Album.AlbumId
					join Artist
						on Album.ArtistId = Artist.ArtistId
group by Artist.ArtistId, Artist.Name
--order by TotalSalesByArtist desc
order by 2 desc --ANCA: You can also order using the column number for the column you want to use!!!

select *
from InvoiceLine
--where Quantity != 1
where UnitPrice != '0.99'

--Anca: since not all tracks are the same price, we will calculate total sales by artist too - see above


--27. `top_media_type.sql`: Provide a query that shows the most purchased Media Type.
select count(1) as TimesSold, MediaType.Name
from InvoiceLine
	join Track
		on InvoiceLine.TrackId = Track.TrackId
			join MediaType
				on Track.MediaTypeId = MediaType.MediaTypeId
group by Track.MediaTypeId, MediaType.Name
