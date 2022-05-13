create or replace view customer_event_tickets_v as
select
   c.customer_id,
   c.customer_name,
   c.customer_email,      
   v.venue_id,
   v.venue_name,
   e.event_id,
   e.event_name,
   e.event_date,
   sum(ts.ticket_quantity) over 
   (partition by e.event_id, ts.customer_id) as total_tickets_purchased,
   tg.ticket_group_id,
   tg.price_category,
   ts.ticket_sales_id,
   ts.ticket_quantity,
   ts.sales_date,
   ts.reseller_id,
   nvl(r.reseller_name, 'VENUE DIRECT SALES') as reseller_name
from 
   venues v join events e on v.venue_id = e.venue_id
   join ticket_groups tg on e.event_id = tg.event_id
   join ticket_sales ts on tg.ticket_group_id = ts.ticket_group_id
   join customers c on ts.customer_id = c.customer_id
   left outer join resellers r on ts.reseller_id = r.reseller_id
