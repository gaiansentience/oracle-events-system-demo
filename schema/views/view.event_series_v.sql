create or replace view event_series_v as
with event_series_base as
(
    select
        s.event_series_id
        ,min(s.event_name) as event_series_name
        ,count(s.event_id) as events_in_series
        ,sum(s.tickets_available) as tickets_available_all_events
        ,sum(s.tickets_remaining) as tickets_remaining_all_events
        ,sum(s.tickets_sold_out) as events_sold_out
        ,sum(s.tickets_still_available) as events_still_available
    from event_system.venue_event_series_v s
    group by
        s.event_series_id
)
select
    e.venue_id
    ,e.venue_name
    ,s.event_series_id
    ,s.event_series_name
    ,s.events_in_series
    ,s.tickets_available_all_events
    ,s.tickets_remaining_all_events
    ,s.events_sold_out
    ,s.events_still_available
    ,e.event_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available
    ,e.tickets_remaining
from 
    event_series_base s
    join event_system.venue_event_series_v e
        on s.event_series_id = e.event_series_id
where
    e.event_series_id is not null;
