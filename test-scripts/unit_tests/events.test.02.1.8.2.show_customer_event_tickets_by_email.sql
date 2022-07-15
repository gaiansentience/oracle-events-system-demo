--show customer tickets purchased for an event
select
*  
from 
customer_api.show_customer_event_purchases_by_email('Harry.Potter@example.customer.com', 602);

  
  select * from events e join venues v on e.venue_id = v.venue_id
  where v.venue_name = 'City Stadium' and e.event_name = 'The New Toys';
  
  select * from customers where customer_name = 'Harry Potter';
