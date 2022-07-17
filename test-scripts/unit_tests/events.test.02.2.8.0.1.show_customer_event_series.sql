--show customer tickets purchased for an event
select
*  
from 
customer_api.show_customer_event_series(3961, 1);


select * from customers where customer_email = 'James.Kirk@example.customer.com';

  
select max(e.event_series_id), max(e.venue_id) from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_name = 'Hometown Hockey League';