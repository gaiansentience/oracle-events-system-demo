create or replace view venues_summary_v as
select 
   v.venue_id, 
   v.venue_name, 
   v.organizer_name,
   v.organizer_email,
   v.max_event_capacity, 
   count(e.event_id) as events_scheduled, 
   min(e.event_date) as first_event_date, 
   max(e.event_date) as last_event_date,
   min(e.tickets_available) min_event_tickets,
   max(e.tickets_available) max_event_tickets
from 
   event_system.venues v left outer join event_system.events e 
   on v.venue_id = e.venue_id and e.event_date > trunc(sysdate)
group by 
   v.venue_id, 
   v.venue_name, 
   v.organizer_name,
   v.organizer_email,
   v.max_event_capacity;   
