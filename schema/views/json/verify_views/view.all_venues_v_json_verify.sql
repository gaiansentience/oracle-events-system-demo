create or replace view all_venues_v_json_verify as
with base as
(
    select
        json_doc
    from event_system.all_venues_v_json
)
select
    j.venue_id
    ,j.venue_name
    ,j.organizer_name
    ,j.organizer_email
    ,j.max_event_capacity
    ,j.events_scheduled
from
    base b,
    json_table(b.json_doc
        columns
        (
            nested path '$[*]'
                columns
                (
                    venue_id            number        path venue_id
                    ,venue_name         varchar2(100) path venue_name
                    ,organizer_name     varchar2(100) path organizer_name
                    ,organizer_email    varchar2(100) path organizer_email
                    ,max_event_capacity number        path max_event_capacity
                    ,events_scheduled   number        path events_scheduled
                )
       )
    ) j;