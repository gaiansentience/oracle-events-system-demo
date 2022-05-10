create or replace view tickets_available_venue_v as
--reseller tickets available
with available_venue as
(
select
tg.event_id,
tg.price_category,
tg.ticket_group_id,
tg.price,
null reseller_id,
'VENUE DIRECT SALES' reseller_name,
tg.tickets_available
- nvl((select sum(ta.tickets_assigned) from ticket_assignments ta where ta.ticket_group_id = tg.ticket_group_id),0)
- nvl((select sum(ts.ticket_quantity) from ticket_sales ts where ts.ticket_group_id = tg.ticket_group_id and ts.reseller_id is null),0) as tickets_available
from
ticket_groups tg
)
select 
e.event_id,
e.event_name,
e.event_date,
a.price_category, a.ticket_group_id, a.price, a.reseller_id, a.reseller_name, a.tickets_available,
case when a.tickets_available = 0 then 'SOLD OUT' else a.tickets_available || ' AVAILABLE' end as ticket_status
from events e join available_venue a on e.event_id = a.event_id