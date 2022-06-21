create or replace view venue_reseller_commission_v as
select
    v.venue_id
    ,min(v.venue_name) as venue_name
    ,r.reseller_id
    ,min(r.reseller_name) as reseller_name
    ,trunc(ts.sales_date,'Month') as sales_month
    ,trunc(ts.sales_date,'Month') + interval '1' month - interval '1' day sales_month_ending
    ,e.event_id
    ,min(e.event_name) as event_name
    ,sum(ts.extended_price) as total_sales
    ,min(r.commission_percent) as commission_percent
    ,sum(ts.reseller_commission) as total_commission
from
    event_system.venues v 
    join event_system.events e 
        on v.venue_id = e.venue_id
    join event_system.ticket_groups tg 
        on e.event_id = tg.event_id
    join event_system.ticket_sales ts 
        on tg.ticket_group_id = ts.ticket_group_id
    join event_system.resellers r 
        on ts.reseller_id = r.reseller_id
group by 
    v.venue_id
    ,r.reseller_id
    ,trunc(ts.sales_date,'Month')
    ,e.event_id;
