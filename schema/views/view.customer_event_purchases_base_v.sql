create or replace view customer_event_purchases_base_v as
select
    ts.customer_id
    ,tg.event_id
    ,tg.price_category
    ,ts.ticket_group_id
    ,ts.ticket_sales_id
    ,ts.ticket_quantity
    ,ts.sales_date
    ,ts.reseller_id
    ,nvl(r.reseller_name, 'VENUE DIRECT SALES') as reseller_name
from
    event_system.customer_purchases_mv cp
    join event_system.ticket_groups tg 
        on cp.ticket_group_id = tg.ticket_group_id
    join event_system.ticket_sales ts 
        on cp.ticket_sales_id = ts.ticket_sales_id
    left outer join event_system.resellers r 
        on cp.reseller_id = r.reseller_id;