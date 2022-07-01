--show customer tickets purchased for an event
select
*  
from 
events_report_api.show_customer_event_tickets(2379, 27);


  
  
  --find a customer with tickets from a reseller
  select tg.event_id, ts.customer_id
  from ticket_groups tg join ticket_sales ts on tg.ticket_group_id = ts.ticket_group_id
  where ts.reseller_id is not null;
  
  --find a customer with tickets from the venue
  select tg.event_id, ts.customer_id
  from ticket_groups tg join ticket_sales ts on tg.ticket_group_id = ts.ticket_group_id
  where ts.reseller_id is null;
  