create or replace view customer_events_v as
with customer_event_base as
(
    select
        p.event_id
        ,sum(p.ticket_quantity) as event_tickets
        ,p.customer_id
    from event_system.customer_purchases_mv p
    group by
        p.event_id
        ,p.customer_id
/*        
    select
        tg.event_id
        ,sum(ts.ticket_quantity) as event_tickets
        ,ts.customer_id
    from
        event_system.ticket_groups tg
        join event_system.ticket_sales ts
            on tg.ticket_group_id = ts.ticket_group_id
    group by
        tg.event_id
        ,ts.customer_id
*/        
)
select
    b.customer_id
    ,c.customer_name
    ,c.customer_email
    ,e.venue_id
    ,v.venue_name
    ,e.event_series_id
    ,e.event_id
    ,e.event_name
    ,e.event_date
    ,b.event_tickets
from
    event_system.venues v
    join event_system.events e
        on v.venue_id = e.venue_id
    join customer_event_base b
        on e.event_id = b.event_id
    join event_system.customers c
        on b.customer_id = c.customer_id
where e.event_date >= trunc(sysdate);