create or replace view venues_v_json_verify as
with base as
(
    select
        venue_id
        ,json_doc
    from event_system.venues_v_json
)
select
    b.venue_id
    ,j.venue_id as venue_id_json
    ,j.venue_name
    ,j.organizer_name
    ,j.organizer_email
    ,j.max_event_capacity
    ,j.venue_scheduled_events
from
    base b,
    json_table(b.json_doc
        columns
            (
            venue_id                number        path '$.venue_id'
            ,venue_name             varchar2(100) path '$.venue_name'
            ,organizer_email        varchar2(100) path '$.organizer_email'
            ,organizer_name         varchar2(100) path '$.organizer_name'
            ,max_event_capacity     number        path '$.max_event_capacity'
            ,venue_scheduled_events number        path '$.venue_scheduled_events'
            )
    ) j;