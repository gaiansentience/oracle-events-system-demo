create or replace view customer_event_series_purchase_v as
select
    ct.customer_id
    ,c.customer_name
    ,c.customer_email      
    ,e.venue_id
    ,e.venue_name
    ,es.event_series_id
    ,es.event_name
    ,es.first_event_date
    ,es.last_event_date
    ,sum(ct.ticket_quantity) over
        (partition by ct.event_series_id, ct.customer_id) as series_tickets
    ,e.event_id
    ,e.event_date
    ,sum(ct.ticket_quantity) over 
        (partition by ct.event_series_id, ct.event_id, ct.customer_id) as event_tickets
    ,ct.ticket_group_id
    ,ct.price_category
    ,ct.ticket_sales_id
    ,ct.ticket_quantity
    ,ct.sales_date
    ,ct.reseller_id
    ,ct.reseller_name
from 
    event_system.venue_event_series_base_v es
    join event_system.venue_event_base_v e
        on es.event_series_id = e.event_series_id
    join event_system.customer_event_purchase_base_v ct 
        on e.event_id = ct.event_id
    join event_system.customers c 
        on ct.customer_id = c.customer_id;