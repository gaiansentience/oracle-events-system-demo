create or replace view venues_summary_v as
with events_base as
(
   select
      e.venue_id,
      count(e.event_id) as events_scheduled, 
      min(e.event_date) as first_event_date, 
      max(e.event_date) as last_event_date,
      min(e.tickets_available) as min_event_tickets,
      max(e.tickets_available) as max_event_tickets      
   from event_system.events e
   where
      e.event_date > trunc(sysdate)
   group by e.venue_id
)
select 
   v.venue_id, 
   v.venue_name, 
   v.organizer_name,
   v.organizer_email,
   v.max_event_capacity, 
   nvl(e.events_scheduled,0) as events_scheduled,
   e.first_event_date, 
   e.last_event_date,
   nvl(e.min_event_tickets,0) as min_event_tickets,
   nvl(e.max_event_tickets,0) as max_event_tickets
from 
   event_system.venues v left outer join events_base e on v.venue_id = e.venue_id;