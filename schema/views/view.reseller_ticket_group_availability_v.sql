create or replace view reseller_ticket_group_availability_v as
with base as
(
   select 
      e.event_id,
      r.reseller_id,
      r.reseller_name,
      tg.ticket_group_id,
      tg.price_category,
      tg.tickets_available as tickets_in_group,
      nvl(
         (
         select 
            sum(ta.tickets_assigned) 
         from 
            event_system.ticket_assignments ta
         where 
            ta.ticket_group_id = tg.ticket_group_id 
            and ta.reseller_id <> r.reseller_id
         )
      ,0)as assigned_to_others,
      nvl(
         (
         select 
            ta.tickets_assigned 
         from 
            event_system.ticket_assignments ta
         where 
            ta.ticket_group_id = tg.ticket_group_id 
            and ta.reseller_id = r.reseller_id
         )
      ,0) as assigned_to_reseller,      
      nvl(
         (
         select 
            sum(ts.ticket_quantity)
         from 
            event_system.ticket_sales ts
         where 
            ts.ticket_group_id = tg.ticket_group_id
            and ts.reseller_id = r.reseller_id
         )
      ,0) as sold_by_reseller,
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
      ,0) as sold_by_venue
   from
      event_system.events e join event_system.ticket_groups tg on e.event_id = tg.event_id
      cross join event_system.resellers r
)
select
   b.event_id,
   b.ticket_group_id,
   b.price_category,
   b.tickets_in_group,
   b.reseller_id,
   b.reseller_name,   
   b.assigned_to_others,
   b.assigned_to_reseller as currently_assigned,
   b.tickets_in_group - (b.assigned_to_others + b.sold_by_venue) as max_available,
   b.sold_by_reseller as min_assignment,
   b.sold_by_reseller,
   b.sold_by_venue
from base b;