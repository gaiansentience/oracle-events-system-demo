create or replace view events_v as
select
   v.venue_id,
   v.venue_name,
   v.organizer_name,
   v.organizer_email,
   e.event_id,
   e.event_name,
   e.event_date,
   e.tickets_available,
   e.tickets_available
   - nvl(
      (
         select sum(ts.ticket_quantity)
         from 
            event_system.ticket_groups tg join event_system.ticket_sales ts 
            on tg.ticket_group_id = ts.ticket_group_id
         where tg.event_id = e.event_id
      )
   ,0) as tickets_remaining
from
   event_system.venues v join event_system.events e on v.venue_id = e.venue_id