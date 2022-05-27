create or replace view venue_events_from_json_v as 
select
   ve.venue_id,
   j.venue_id as venue_id_json,
   j.venue_name,
   j.organizer_name,
   j.organizer_email,
   j.max_event_capacity,
   j.venue_scheduled_events,
   j.event_id,
   j.event_name,
   cast(j.event_date as date) as event_date,
   j.tickets_available,
   j.tickets_remaining
from
   event_system.venue_events_json_v ve,
   json_table(ve.json_doc
      columns
         (
         venue_id number path '$.venue_id',
         venue_name varchar2(50) path '$.venue_name',
         organizer_name varchar2(50) path '$.organizer_name',
         organizer_email varchar2(50) path '$.organizer_email',
         max_event_capacity number path '$.max_event_capacity',
         venue_scheduled_events number path '$.venue_scheduled_events',
         nested path '$.venue_event_listing[*]'
            columns
               (
               event_id number path event_id,
               event_name varchar2(50) path event_name,
               event_date timestamp path event_date,
               tickets_available number path tickets_available,
               tickets_remaining number path tickets_remaining
               )
         
         )
   ) j;