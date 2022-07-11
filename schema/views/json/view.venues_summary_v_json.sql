create or replace view venues_summary_v_json as
with json_base as
(
    select
        v.venue_id
        ,json_object(
            'venue_id'            : v.venue_id
            ,'venue_name'         : v.venue_name
            ,'organizer_name'     : v.organizer_name
            ,'organizer_email'    : v.organizer_email
            ,'max_event_capacity' : v.max_event_capacity
            ,'events_scheduled'   : v.events_scheduled
            ,'first_event_date'   : v.first_event_date
            ,'last_event_date'    : v.last_event_date
            ,'min_event_tickets'  : v.min_event_tickets
            ,'max_event_tickets'  : v.max_event_tickets
        ) as json_doc
    from event_system.venues_summary_v v
)
select
    b.venue_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;