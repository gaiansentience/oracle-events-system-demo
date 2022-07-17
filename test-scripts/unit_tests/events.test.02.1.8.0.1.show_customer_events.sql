--show customer events with ticket purchases by venue
select
*  
from 
customer_api.show_customer_events(2640, 1);


  select * from events e join venues v on e.venue_id = v.venue_id
  where v.venue_name = 'City Stadium' and e.event_name = 'The New Toys';
  
  select * from customers where customer_name = 'Harry Potter';
  
