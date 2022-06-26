create or replace view venue_event_series_base_v as
select
    e.venue_id
    ,min(e.venue_name) as venue_name
    ,min(e.organizer_name) as organizer_name
    ,min(e.organizer_email) as organizer_email
    ,min(e.max_event_capacity) as max_event_capacity
    ,e.event_series_id
    ,min(e.event_name) as event_name
    ,count(e.event_id) as events_in_series
    ,min(e.event_date) as first_event_date
    ,max(e.event_date) as last_event_date
    ,min(e.tickets_available) as event_tickets_available
from
    venue_event_base_v e
where
    e.event_series_id is not null
group by
    e.venue_id
    ,e.event_series_id;