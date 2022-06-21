create or replace view events_json_v as
with json_base as
(
    select
        e.venue_id
        ,e.event_id
        ,json_object(
            'venue_id'           : e.venue_id
            ,'venue_name'        : e.venue_name
            ,'organizer_email'   : e.organizer_email
            ,'organizer_name'    : e.organizer_name
            ,'event_id'          : e.event_id
            ,'event_name'        : e.event_name
            ,'event_date'        : e.event_date
            ,'tickets_available' : e.tickets_available
            ,'tickets_remaining' : e.tickets_remaining 
        ) as json_doc
    from event_system.events_v e
)
select
    b.venue_id
    ,b.event_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;