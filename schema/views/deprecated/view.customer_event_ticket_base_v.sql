--deprecated
create or replace view customer_event_ticket_base_v as
select
    c.customer_id
    ,c.customer_name
    ,c.customer_email
    ,c.venue_id
    ,c.venue_name
    ,c.event_id
    ,c.event_name
    ,c.event_date
    ,c.event_series_id
    ,c.event_tickets
    ,c.ticket_group_id
    ,c.price_category
    ,c.ticket_sales_id
    ,c.ticket_quantity
    ,c.sales_date
    ,c.reseller_id
    ,c.reseller_name
    ,t.ticket_id
    ,t.serial_code
    ,t.status
from
    event_system.customer_event_purchase_v c
    join event_system.tickets t
        on c.ticket_sales_id = t.ticket_sales_id
