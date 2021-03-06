create or replace view venues_v as
with event_base as
(
    select
        e.venue_id
        ,count(*) as events_scheduled
    from event_system.events e
    where e.event_date > trunc(sysdate)
    group by e.venue_id
)
select
    v.venue_id
    ,v.venue_name
    ,v.organizer_name
    ,v.organizer_email
    ,v.max_event_capacity
    ,nvl(e.events_scheduled, 0) as events_scheduled
from 
    event_system.venues v 
    left outer join event_base e 
        on v.venue_id = e.venue_id;