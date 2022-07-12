create or replace view venue_event_series_v as
select
    e.venue_id
    ,e.venue_name
    ,e.organizer_name
    ,e.organizer_email
    ,e.max_event_capacity
    ,e.events_scheduled
    ,e.event_id
    ,e.event_series_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available
    ,e.tickets_remaining
    ,case when e.tickets_remaining = 0 then 1 else 0 end as tickets_sold_out
    ,case when e.tickets_remaining > 0 then 1 else 0 end as tickets_still_available
from event_system.venue_events_v e
where
    e.event_series_id is not null;
