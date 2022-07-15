--show customer tickets purchased for an event series
select
*  
from 
event_sales_api.show_customer_event_series_tickets_by_email('Harry.Potter@example.customer.com', 61);


select max(event_series_id) from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_name = 'Hometown Hockey League';