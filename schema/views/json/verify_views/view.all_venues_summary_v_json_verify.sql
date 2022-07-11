create or replace view all_venues_summary_v_json_verify as
with base as
(
    select
        json_doc
    from event_system.all_venues_summary_v_json
)
select
    j.venue_id
    ,j.venue_name
    ,j.organizer_name
    ,j.organizer_email
    ,j.max_event_capacity
    ,j.events_scheduled
    ,cast(j.first_event_date as date) as first_event_date
    ,cast(j.last_event_date as date) as last_event_date
    ,j.min_event_tickets
    ,j.max_event_tickets
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
                    ,first_event_date   timestamp     path first_event_date
                    ,last_event_date    timestamp     path last_event_date
                    ,min_event_tickets  number        path min_event_tickets
                    ,max_event_tickets  number        path max_event_tickets
                )
        )
    ) j;