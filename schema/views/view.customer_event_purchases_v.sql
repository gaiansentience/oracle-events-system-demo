create or replace view customer_event_purchases_v as
select
    b.customer_id
    ,b.customer_name
    ,b.customer_email
    ,b.venue_id
    ,b.venue_name
    ,b.event_series_id
    ,b.event_id
    ,b.event_name
    ,b.event_date
    ,p.ticket_group_id
    ,p.price_category
    ,p.ticket_sales_id
    ,p.ticket_quantity
    ,b.event_tickets
    ,p.sales_date
    ,p.reseller_id
    ,p.reseller_name
from
    event_system.customer_events_v b
    join customer_event_purchases_base_v p
        on b.event_id = p.event_id
        and b.customer_id = p.customer_id;