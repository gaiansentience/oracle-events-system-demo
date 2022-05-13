create or replace view customer_event_tickets_json_v as
with customer_tickets as
(
   select
   tg.event_id,
   ts.customer_id,
   min(c.customer_name) customer_name,
   min(c.customer_email) customer_email,
   sum(ts.ticket_quantity) total_tickets_purchased
   from ticket_groups tg join ticket_sales ts on tg.ticket_group_id = ts.ticket_group_id
   join customers c on ts.customer_id = c.customer_id
   group by 
   tg.event_id,
   ts.customer_id
), customer_ticket_details as
   (
   select
   ts.customer_id,
   tg.event_id,
   tg.ticket_group_id,
   tg.price_category,
   ts.ticket_sales_id,
   ts.ticket_quantity,
   ts.sales_date,
   ts.reseller_id,
   nvl(r.reseller_name, 'VENUE DIRECT SALES') as reseller_name
   from ticket_groups tg join ticket_sales ts on tg.ticket_group_id = ts.ticket_group_id
   left outer join resellers r on ts.reseller_id = r.reseller_id
), json_base as
(
select
   c.customer_id,
   e.event_id,
   json_object(
   'customer_id' : c.customer_id,
   'customer_name' : c.customer_name,
   'customer_email' : c.customer_email,      
   'venue_id' : v.venue_id,
   'venue_name' : v.venue_name,
   'event_id' : e.event_id,
   'event_name' : e.event_name,
   'event_date' : e.event_date,
   'total_tickets_purchased' : c.total_tickets_purchased,
   'event_ticket_purchases' :
   (
   select 
   json_arrayagg(json_object(
        'ticket_group_id' : ct.ticket_group_id,
        'price_category' : ct.price_category,
        'ticket_sales_id' : ct.ticket_sales_id,
        'ticket_quantity' : ct.ticket_quantity,
        'sales_date' : ct.sales_date,
        'reseller_id' : ct.reseller_id,
        'reseller_name' : ct.reseller_name
   ))
   from customer_ticket_details ct
   where ct.customer_id = c.customer_id
   and ct.event_id = e.event_id
   )
   ) as json_doc
from venues v join events e on v.venue_id = e.venue_id 
join customer_tickets c on e.event_id = c.event_id
)
select
b.customer_id,
b.event_id,
b.json_doc,
json_serialize(b.json_doc pretty) as json_doc_formatted
from json_base b