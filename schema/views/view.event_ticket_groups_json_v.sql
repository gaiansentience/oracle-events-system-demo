create or replace view event_ticket_groups_json_v as
with json_base as
(
select
e.venue_id,
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
               'tickets_available' : g.tickets_available
               returning clob)
           returning clob)
        from ticket_groups g where g.event_id = e.event_id
        )
returning clob) as json_doc
from venues v join events e on v.venue_id = e.venue_id
)
select
b.venue_id,
b.event_id,
b.json_doc,
json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b