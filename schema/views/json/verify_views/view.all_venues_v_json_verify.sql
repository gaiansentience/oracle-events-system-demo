create or replace view all_venues_v_json_verify as
select
    j.venue_id
    ,j.venue_name
    ,j.organizer_email
    ,j.organizer_name
    ,j.max_event_capacity
    ,j.events_scheduled
from
    event_system.all_venues_v_json v,
    json_table(v.json_doc
        columns
        (
            nested path '$[*]'
                columns
                (
                    venue_id            number        path venue_id
                    ,venue_name         varchar2(100) path venue_name
                    ,organizer_email    varchar2(100) path organizer_email
                    ,organizer_name     varchar2(100) path organizer_name
                    ,max_event_capacity number        path max_event_capacity
                    ,events_scheduled   number        path events_scheduled
                )
       )
    ) j;