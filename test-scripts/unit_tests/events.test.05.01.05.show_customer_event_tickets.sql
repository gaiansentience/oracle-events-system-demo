--show customer tickets purchased for an event
select
*  
from 
events_report_api.show_customer_event_tickets(517, 67);

select
*  
from 
events_report_api.show_customer_event_tickets(919, 67);


  
  /*
  select tg.event_id, ts.customer_id
  from ticket_groups tg join ticket_sales ts on tg.ticket_group_id = ts.ticket_group_id
  where ts.reseller_id is not null;
  
  select tg.event_id, ts.customer_id
  from ticket_groups tg join ticket_sales ts on tg.ticket_group_id = ts.ticket_group_id
  where ts.reseller_id is not null;
  */