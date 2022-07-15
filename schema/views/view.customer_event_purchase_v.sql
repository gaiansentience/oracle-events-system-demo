create or replace view customer_event_purchase_v as
select
    ct.customer_id
    ,c.customer_name
    ,c.customer_email      
    ,e.venue_id
    ,e.venue_name
    ,e.event_id
    ,e.event_series_id
    ,e.event_name
    ,e.event_date
    ,sum(ct.ticket_quantity) over 
        (partition by ct.event_id, ct.customer_id) as event_tickets
    ,ct.ticket_group_id
    ,ct.price_category
    ,ct.ticket_sales_id
    ,ct.ticket_quantity
    ,ct.sales_date
    ,ct.reseller_id
    ,ct.reseller_name
from 
    event_system.venue_event_base_v e
    join event_system.customer_event_purchase_base_v ct 
        on e.event_id = ct.event_id
    join event_system.customers c 
        on ct.customer_id = c.customer_id;