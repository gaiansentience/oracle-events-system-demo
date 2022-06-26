create or replace view event_ticket_prices_v as
with sales as
(
    select 
        ts.ticket_group_id
        ,sum(ts.ticket_quantity) as tickets_sold
    from event_system.ticket_sales ts 
    group by ts.ticket_group_id
)
select
    e.venue_id
    ,e.venue_name
    ,e.event_id
    ,e.event_series_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available as event_tickets_available
    ,tg.ticket_group_id
    ,tg.price_category
    ,tg.price
    ,tg.tickets_available
    ,nvl(s.tickets_sold, 0) as tickets_sold
    ,tg.tickets_available - nvl(s.tickets_sold, 0) as tickets_remaining
from
    event_system.venue_event_base_v e
    join event_system.ticket_groups tg 
        on e.event_id = tg.event_id
    left outer join sales s 
        on tg.ticket_group_id = s.ticket_group_id;