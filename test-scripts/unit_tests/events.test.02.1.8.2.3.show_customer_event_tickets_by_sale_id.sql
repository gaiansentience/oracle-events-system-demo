--show customer tickets purchased for an event using ticket_sales_id
select 
* 
from 
customer_api.show_customer_event_tickets_by_sale_id(2640, 71343);





select
*  
from 
customer_api.show_customer_event_purchases(2640, 602);

  
  select * from events e join venues v on e.venue_id = v.venue_id
  where v.venue_name = 'City Stadium' and e.event_name = 'The New Toys';
  
  select * from customers where customer_name = 'Harry Potter';
