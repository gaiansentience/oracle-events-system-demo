create or replace view event_reseller_performance_v as
with event_sales as
(
    select
        e.venue_id
        ,e.event_id
        ,ts.reseller_id
        ,sum(ts.ticket_quantity) as total_ticket_quantity
        ,sum(ts.extended_price) as total_ticket_sales  
    from
        event_system.events e 
        join event_system.ticket_groups tg 
            on e.event_id = tg.event_id
        join event_system.ticket_sales ts 
            on tg.ticket_group_id = ts.ticket_group_id 
    --filtering on non null reseller id excludes venue direct sales
    --where ts.reseller_id is not null
    group by
        e.venue_id
        ,e.event_id
        ,ts.reseller_id
)
select
    vs.venue_id
    ,v.venue_name
    ,vs.event_id
    ,e.event_name
    ,e.event_date
    ,r.reseller_id
    ,nvl(r.reseller_name, 'VENUE DIRECT SALES') as reseller_name
    ,nvl(vs.total_ticket_quantity,0) as total_ticket_quantity
    ,nvl(vs.total_ticket_sales,0) as total_ticket_sales
    ,dense_rank() over (partition by vs.venue_id, vs.event_id order by nvl(vs.total_ticket_sales,0) desc) rank_by_sales
    ,dense_rank() over (partition by vs.venue_id, vs.event_id order by nvl(vs.total_ticket_sales,0) desc) rank_by_quantity
from
    event_sales vs 
    join event_system.venues v
        on vs.venue_id = v.venue_id
    join event_system.events e
        on vs.event_id = e.event_id
    left outer join event_system.resellers r 
        on vs.reseller_id = r.reseller_id
order by 
    vs.venue_id
    ,e.event_date
    ,nvl(vs.total_ticket_sales,0) desc
    ,r.reseller_name;
