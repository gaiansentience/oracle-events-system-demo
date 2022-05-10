create or replace view venue_events_json_v as
with json_base as
(
select
v.venue_id,
json_object(
   'venue_id' : v.venue_id,
   'venue_name' : v.venue_name,
   'organizer_email' : v.organizer_email,
   'organizer_name' : v.organizer_name,
   'max_event_capacity' : v.max_event_capacity,
   'venue_scheduled_events' : 
      (
         select count(*) from events e where e.venue_id = v.venue_id and e.event_date > sysdate
      ),
   'venue_event_listing' :
      (
         select json_arrayagg(json_object(
            'event_id' : e.event_id,
            'event_name' : e.event_name,
            'event_date' : e.event_date,
            'event_capacity' : e.tickets_available,
            'tickets_remaining' : 
               e.tickets_available
               - nvl((
                  select sum(ts.ticket_quantity) from ticket_groups tg join ticket_sales ts on tg.ticket_group_id = ts.ticket_group_id
                  where tg.event_id = e.event_id
               ),0)
         ) returning clob)
         from events e where e.venue_id = v.venue_id and e.event_date > sysdate
      )
returning clob) as json_doc
from venues v
)
select
b.venue_id,
b.json_doc,
json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b