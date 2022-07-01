--show customer tickets purchased for an event
select
*  
from 
events_report_api.show_customer_event_series_tickets_by_email('James.Kirk@example.customer.com', 21);

select max(event_series_id) from events where event_name = 'Hometown Hockey League';