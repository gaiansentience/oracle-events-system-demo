create or replace view event_series_v_json_verify as
with base as
(
    select
        event_series_id
        ,json_doc
    from event_system.event_series_v_json
)
select
    j.venue_id
    ,j.venue_name
    ,b.event_series_id
    ,j.event_series_id as event_series_id_json
    ,j.event_series_name
    ,j.events_in_series
    ,j.tickets_available_all_events
    ,j.tickets_remaining_all_events
    ,j.events_sold_out
    ,j.events_still_available
    ,j.event_id
    ,j.event_name
    ,cast(j.event_date as date) as event_date
    ,j.tickets_available
    ,j.tickets_remaining
from
    base b,
    json_table(b.json_doc
        columns
        (
            venue_id                      number        path '$.venue_id'
            ,venue_name                   varchar2(100) path '$.venue_name'
            ,event_series_id              number        path '$.event_series_id'
            ,event_series_name            varchar2(100) path '$.event_series_name'
            ,events_in_series             number        path '$.events_in_series'
            ,tickets_available_all_events number        path '$.tickets_available_all_events'
            ,tickets_remaining_all_events number        path '$.tickets_remaining_all_events'
            ,events_sold_out              number        path '$.events_sold_out'
            ,events_still_available       number        path '$.events_still_available'
            ,nested                           path '$.series_events[*]'
                columns
                (
                    event_id           number        path event_id
                    ,event_name        varchar2(100) path event_name
                    ,event_date        timestamp     path event_date
                    ,tickets_available number        path tickets_available
                    ,tickets_remaining number        path tickets_remaining
                )
        )
    ) j;