create or replace view venues_summary_json_v as
with events_base as
(
   select
      e.venue_id,
      count(e.event_id) as events_scheduled, 
      min(e.event_date) as first_event_date, 
      max(e.event_date) as last_event_date,
      min(e.tickets_available) as min_event_tickets,
      max(e.tickets_available) as max_event_tickets      
   from event_system.events e
   where
      e.event_date > trunc(sysdate)
   group by e.venue_id
), venues_base as
(
select 
   v.venue_id, 
   v.venue_name, 
   v.organizer_name,
   v.organizer_email,
   v.max_event_capacity, 
   nvl(e.events_scheduled,0) as events_scheduled,
   e.first_event_date, 
   e.last_event_date,
   nvl(e.min_event_tickets,0) as min_event_tickets,
   nvl(e.max_event_tickets,0) as max_event_tickets
from 
   event_system.venues v left outer join events_base e on v.venue_id = e.venue_id
), json_base as
(
select
v.venue_id,
json_object(
   'venue_id' : v.venue_id,
   'venue_name' : v.venue_name,
   'organizer_email' : v.organizer_email,
   'organizer_name' : v.organizer_name,
   'max_event_capacity' : v.max_event_capacity,
   'events_scheduled' : v.events_scheduled,
   'first_event_date' : v.first_event_date,
   'last_event_date' : v.last_event_date,
   'min_event_tickets' : v.min_event_tickets,
   'max_event_tickets' : v.max_event_tickets
) as json_doc
from venues_base v
)
select
b.venue_id,
b.json_doc,
json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b