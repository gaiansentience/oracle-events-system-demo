create or replace view events_v_json_verify as
select
    e.venue_id
    ,j.venue_id as venue_id_json
    ,j.venue_name
    ,j.organizer_name
    ,j.organizer_email
    ,e.event_id
    ,j.event_id as event_id_json
    ,j.event_series_id
    ,j.event_name
    ,cast(j.event_date as date) as event_date
    ,j.tickets_available
    ,j.tickets_remaining
from
    event_system.events_v_json e,
    json_table(e.json_doc
        columns
        (
            venue_id           number        path '$.venue_id'
            ,venue_name        varchar2(100) path '$.venue_name'
            ,organizer_name    varchar2(100) path '$.organizer_name'
            ,organizer_email   varchar2(100) path '$.organizer_email'
            ,event_id          number        path '$.event_id'
            ,event_series_id   number        path '$.event_series_id'
            ,event_name        varchar2(100) path '$.event_name'
            ,event_date        timestamp     path '$.event_date'
            ,tickets_available number        path '$.tickets_available'
            ,tickets_remaining number        path '$.tickets_remaining'      
        )
    ) j;