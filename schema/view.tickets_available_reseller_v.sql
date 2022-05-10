create or replace view tickets_available_reseller_v as
--reseller tickets available
with available_reseller as 
(
select
tg.event_id,
tg.price_category,
tg.ticket_group_id,
tg.price,
ta.reseller_id,
r.reseller_name,
ta.tickets_assigned
- nvl((select sum(ts.ticket_quantity) from ticket_sales ts where ts.ticket_group_id = tg.ticket_group_id and ts.reseller_id = r.reseller_id),0) as tickets_available
from
ticket_groups tg join ticket_assignments ta on tg.ticket_group_id = ta.ticket_group_id
join resellers r on ta.reseller_id = r.reseller_id
)
select 
e.event_id, 
e.event_name,
e.event_date,
a.price_category, a.ticket_group_id, a.price, a.reseller_id, a.reseller_name, a.tickets_available,
case when a.tickets_available = 0 then 'SOLD OUT' else a.tickets_available || ' AVAILABLE' end as ticket_status
from events e join available_reseller a on e.event_id = a.event_id