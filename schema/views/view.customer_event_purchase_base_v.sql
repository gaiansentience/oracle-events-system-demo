create or replace view customer_event_purchase_base_v as
select
    ts.customer_id
    ,tg.event_id
    ,e.event_series_id
    ,tg.ticket_group_id
    ,tg.price_category
    ,ts.ticket_sales_id
    ,ts.ticket_quantity
    ,ts.sales_date
    ,ts.reseller_id
    ,nvl(r.reseller_name, 'VENUE DIRECT SALES') as reseller_name
from
    event_system.events e
    join event_system.ticket_groups tg 
        on e.event_id = tg.event_id
    join event_system.ticket_sales ts 
        on tg.ticket_group_id = ts.ticket_group_id
    left outer join event_system.resellers r 
        on ts.reseller_id = r.reseller_id;