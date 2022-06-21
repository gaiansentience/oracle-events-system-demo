create or replace view venues_from_json_v as
select
    j.venue_id,
    j.venue_name,
    j.organizer_email,
    j.organizer_name,
    j.max_event_capacity,
    j.venue_scheduled_events
from
    event_system.venues_json_v v,
    json_table(v.json_doc
      columns
      (
         venue_id number path '$.venue_id',
         venue_name varchar2(50) path '$.venue_name',
         organizer_email varchar2(50) path '$.organizer_email',
         organizer_name varchar2(50) path '$.organizer_name',
         max_event_capacity number path '$.max_event_capacity',
         venue_scheduled_events number path '$.venue_scheduled_events'
      )
    ) j