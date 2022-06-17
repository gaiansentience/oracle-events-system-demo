create or replace view event_ticket_prices_json_v as
with sales as
(
   select 
      ts.ticket_group_id,
      sum(ts.ticket_quantity) tickets_sold
   from 
      event_system.ticket_sales ts 
   group by ts.ticket_group_id
), ticket_group_base as
(
  select
    tg.event_id,
    tg.ticket_group_id,
    tg.price_category,
    tg.price,
    tg.tickets_available,
    nvl(s.tickets_sold,0) as tickets_sold,
    tg.tickets_available -nvl(s.tickets_sold ,0) as tickets_remaining
  from
    event_system.ticket_groups tg left outer join sales s 
    on tg.ticket_group_id = s.ticket_group_id
), json_base as
(
select
v.venue_id,
e.event_id,
json_object(
    'venue_id' : v.venue_id,
    'venue_name' : v.venue_name,
    'event_id' : e.event_id,
    'event_name' : e.event_name,
    'event_date' : e.event_date,
    'event_tickets_available' : e.tickets_available,
    'ticket_groups' : 
        (
        select json_arrayagg(
           json_object(
               'ticket_group_id' : g.ticket_group_id,
               'price_category' : g.price_category, 
               'price' : g.price, 
               'tickets_available' : g.tickets_available,
               'tickets_sold' : g.tickets_sold,
               'tickets_remaining' : g.tickets_remaining
               returning clob)
           returning clob)
        from ticket_group_base g where g.event_id = e.event_id
        )
returning clob) as json_doc
from event_system.venues v join event_system.events e on v.venue_id = e.venue_id
)
select
b.venue_id,
b.event_id,
b.json_doc,
json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b