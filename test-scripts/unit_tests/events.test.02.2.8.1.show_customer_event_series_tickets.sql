--show customer tickets purchased for an event
select
*  
from 
events_report_api.show_customer_event_series_tickets(3961, 13);


select customer_id from customers where customer_email = 'James.Kirk@example.customer.com';

select * from venues where venue_name = 'City Stadium';
  
select max(event_series_id) from events where venue_id = 1 and event_name = 'Hometown Hockey League';