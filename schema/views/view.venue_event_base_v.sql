create or replace view venue_event_base_v as
select
    v.venue_id
    ,v.venue_name
    ,v.organizer_name
    ,v.organizer_email
    ,v.max_event_capacity
    ,e.event_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available
from
    event_system.venues v 
    join event_system.events e 
        on v.venue_id = e.venue_id
where
    e.event_date >= trunc(sysdate);