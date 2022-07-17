create or replace view customer_event_series_v as
with customer_event_series_base as
(
    select
        p.venue_id
        ,p.event_series_id
        ,min(e.event_name) as event_series_name
        ,min(e.event_date) as first_event_date
        ,max(e.event_date) as last_event_date
        ,count(distinct p.event_id) as series_events
        ,sum(p.ticket_quantity) as series_tickets
        ,p.customer_id
    from
        customer_purchases_mv p
        join event_system.events e
            on p.event_series_id = e.event_series_id and p.event_id = e.event_id
    where 
        p.event_series_id is not null
        and e.event_date >= trunc(sysdate)
    group by
        p.venue_id
        ,p.event_series_id
        ,p.customer_id
/*
    select
        e.venue_id
        ,e.event_series_id
        ,min(e.event_name) as event_series_name
        ,min(e.event_date) as first_event_date
        ,max(e.event_date) as last_event_date
        ,count(distinct e.event_id) as series_events
        ,sum(ts.ticket_quantity) as series_tickets
        ,ts.customer_id
    from
        event_system.events e
        join event_system.ticket_groups tg
            on e.event_id = tg.event_id
        join event_system.ticket_sales ts
            on tg.ticket_group_id = ts.ticket_group_id
    where 
        e.event_series_id is not null
        and e.event_date >= trunc(sysdate)
    group by
        e.venue_id
        ,e.event_series_id
        ,ts.customer_id
*/
)
select
    b.customer_id
    ,c.customer_name
    ,c.customer_email
    ,b.venue_id
    ,v.venue_name
    ,b.event_series_id
    ,b.event_series_name
    ,b.first_event_date
    ,b.last_event_date
    ,b.series_events
    ,b.series_tickets    
from
    event_system.venues v
    join customer_event_series_base b
        on v.venue_id = b.venue_id
    join event_system.customers c
        on b.customer_id = c.customer_id;