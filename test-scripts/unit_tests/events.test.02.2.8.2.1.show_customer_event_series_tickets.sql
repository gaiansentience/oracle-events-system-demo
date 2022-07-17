--show customer tickets purchased for an event
select
*  
from 
customer_api.show_customer_event_series_tickets(3961, 61);


select * from customers where customer_email = 'James.Kirk@example.customer.com';

  
select max(event_series_id) from events e join venues v on e.venue_id = v.venue_id
where v.venue_name = 'City Stadium' and e.event_name = 'Hometown Hockey League';