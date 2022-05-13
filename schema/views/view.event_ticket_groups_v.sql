create or replace view event_ticket_groups_v as
select
   v.venue_id,
   v.venue_name,
   e.event_id,
   e.event_name,
   e.event_date,
   e.tickets_available as event_tickets_available,
   tg.ticket_group_id,
   tg.price_category,
   tg.price,
   tg.tickets_available,
   nvl(
      (
      select 
         sum(ta.tickets_assigned) 
      from 
         event_system.ticket_assignments ta 
      where 
         ta.ticket_group_id = tg.ticket_group_id
      )
   ,0) currently_assigned,
   nvl(
      (
      select 
         sum(ts.ticket_quantity) 
      from 
         event_system.ticket_sales ts 
      where 
         ts.ticket_group_id = tg.ticket_group_id 
         and ts.reseller_id is null
      )
   ,0) sold_by_venue
from
   event_system.venues v join event_system.events e on v.venue_id = e.venue_id
   join event_system.ticket_groups tg on e.event_id = tg.event_id
union all
select
   v.venue_id,
   v.venue_name,
   e.event_id,
   e.event_name,
   e.event_date,
   e.tickets_available as event_tickets_available,
   0 as ticket_group_id,
   'UNDEFINED' as price_category,
   0 as price,
   e.tickets_available -
   nvl(
      (
      select 
         sum(tg.tickets_available) 
      from 
         event_system.ticket_groups tg 
      where 
         tg.event_id = e.event_id
      )
   ,0) as tickets_available,
   0 as currently_assigned,
   0 as sold_by_venue
from 
   event_system.venues v join event_system.events e on v.venue_id = e.venue_id;