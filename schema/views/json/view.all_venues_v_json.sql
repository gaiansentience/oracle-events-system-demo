create or replace view all_venues_v_json as
with json_base as
(
    select
        json_arrayagg(
            json_object(
                'venue_id'            : v.venue_id
                ,'venue_name'         : v.venue_name
                ,'organizer_name'     : v.organizer_name
                ,'organizer_email'    : v.organizer_email
                ,'max_event_capacity' : v.max_event_capacity
                ,'events_scheduled'   : v.events_scheduled
            )
        returning clob) as json_doc
    from event_system.venues_v v
)
select
    b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;