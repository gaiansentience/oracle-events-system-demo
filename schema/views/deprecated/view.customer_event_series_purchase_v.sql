create or replace view customer_event_series_purchase_v as
select
    ct.customer_id
    ,ct.customer_name
    ,ct.customer_email      
    ,ct.venue_id
    ,ct.venue_name
    ,ct.event_series_id
    ,ct.event_name
    ,min(ct.event_date) over (partition by ct.event_series_id, ct.customer_id) as first_event_date
    ,max(ct.event_date) over (partition by ct.event_series_id, ct.customer_id) as last_event_date
    ,ct.series_events
    ,ct.series_tickets    
    ,ct.event_id
    ,ct.event_date
    ,ct.event_tickets
    ,ct.ticket_group_id
    ,ct.price_category
    ,ct.ticket_sales_id
    ,ct.ticket_quantity
    ,ct.sales_date
    ,ct.reseller_id
    ,ct.reseller_name
from 
    event_system.customer_event_purchase_v ct
where ct.event_series_id is not null;