--show customer tickets purchased for an event series
select
*  
from 
customer_api.show_customer_event_series_by_email('Harry.Potter@example.customer.com', 1);


select max(e.event_series_id), max(e.venue_id) from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_name = 'Hometown Hockey League';