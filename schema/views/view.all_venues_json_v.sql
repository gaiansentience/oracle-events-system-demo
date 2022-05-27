create or replace view all_venues_json_v as
with json_base as
(
select
json_arrayagg(
   json_object(
      'venue_id' : v.venue_id,
      'venue_name' : v.venue_name,
      'organizer_email' : v.organizer_email,
      'organizer_name' : v.organizer_name,
      'max_event_capacity' : v.max_event_capacity,
      'venue_scheduled_events' : 
      (
         select count(*) 
         from events e 
         where 
            e.venue_id = v.venue_id 
            and e.event_date > trunc(sysdate)
      )
   )
returning clob) as json_doc
from venues v
)
select
b.json_doc,
json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b