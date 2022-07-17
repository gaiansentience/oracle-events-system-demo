create or replace view customer_event_purchase_v as
select
    b.customer_id
    ,b.customer_name
    ,b.customer_email
    ,b.venue_id
    ,b.venue_name
    ,b.event_id
    ,b.event_name
    ,b.event_date
    ,b.event_series_id
    ,b.series_events
    ,b.series_tickets
    ,ts.ticket_group_id
    ,tg.price_category
    ,ts.ticket_sales_id
    ,ts.ticket_quantity
    ,b.event_tickets
    ,ts.sales_date
    ,ts.reseller_id
    ,nvl(r.reseller_name, 'VENUE DIRECT SALES') as reseller_name
from
    event_system.customer_events_v b
    join event_system.ticket_groups tg 
        on b.event_id = tg.event_id
    join event_system.ticket_sales ts 
        on tg.ticket_group_id = ts.ticket_group_id and b.customer_id = ts.customer_id
    left outer join event_system.resellers r 
        on ts.reseller_id = r.reseller_id;