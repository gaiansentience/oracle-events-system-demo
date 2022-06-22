create or replace view venue_events_v_json as
with json_base as
(
    select
        v.venue_id,
        json_object(
            'venue_id'                : v.venue_id
            ,'venue_name'             : v.venue_name
            ,'organizer_email'        : v.organizer_email
            ,'organizer_name'         : v.organizer_name
            ,'max_event_capacity'     : v.max_event_capacity
            ,'venue_scheduled_events' : v.venue_scheduled_events
            ,'venue_event_listing'    :
                (
                select 
                    json_arrayagg(
                        json_object(
                            'event_id'           : e.event_id
                            ,'event_name'        : e.event_name
                            ,'event_date'        : e.event_date
                            ,'tickets_available' : e.tickets_available
                            ,'tickets_remaining' : e.tickets_remaining
                        ) 
                    returning clob)
                from event_system.venue_events_v e
                where e.venue_id = v.venue_id 
                )
        returning clob) as json_doc
    from event_system.venues_v v
)
select
   b.venue_id,
   b.json_doc,
   json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;