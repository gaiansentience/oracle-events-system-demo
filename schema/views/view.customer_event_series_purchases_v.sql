create or replace view customer_event_series_purchases_v as
select
    es.customer_id
    ,es.customer_name
    ,es.customer_email      
    ,es.venue_id
    ,es.venue_name
    ,es.event_series_id
    ,es.event_series_name
    ,es.first_event_date
    ,es.last_event_date
    ,es.series_events
    ,es.series_tickets    
    ,e.event_id
    ,e.event_name
    ,e.event_date
    ,e.event_tickets
    ,p.ticket_group_id
    ,p.price_category
    ,p.ticket_sales_id
    ,p.ticket_quantity
    ,p.sales_date
    ,p.reseller_id
    ,p.reseller_name
from 
    event_system.customer_event_series_v es
    join event_system.customer_events_v e
        on es.event_series_id = e.event_series_id 
        and es.customer_id = e.customer_id
    join event_system.customer_event_purchases_base_v p
        on e.event_id = p.event_id
        and e.customer_id = p.customer_id;