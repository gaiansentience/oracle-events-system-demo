create or replace view venues_summary_v_json_verify as
select
    j.venue_id, 
    j.venue_name,
    j.organizer_name,    
    j.organizer_email,
    j.max_event_capacity,
    j.events_scheduled,
    cast(j.first_event_date as date) as first_event_date,
    cast(j.last_event_date as date) as last_event_date,
    j.min_event_tickets,
    j.max_event_tickets
from
event_system.venues_summary_v_json vs,
json_table(vs.json_doc
   columns
   (
      venue_id number path '$.venue_id',
      venue_name varchar2(50) path '$.venue_name',
      organizer_email varchar2(50) path '$.organizer_email',
      organizer_name varchar2(50) path '$.organizer_name',
      max_event_capacity number path '$.max_event_capacity',
      events_scheduled number path '$.events_scheduled',
      first_event_date timestamp path '$.first_event_date',
      last_event_date timestamp path '$.last_event_date',
      min_event_tickets number path '$.min_event_tickets',
      max_event_tickets number path '$.max_event_tickets'
   )
) j   