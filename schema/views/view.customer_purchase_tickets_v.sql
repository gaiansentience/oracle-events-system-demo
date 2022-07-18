create or replace view customer_purchase_tickets_v as
--view is identical to customer_event_tickets_v
select
    p.customer_id
    ,p.customer_name
    ,p.customer_email
    ,p.venue_id
    ,p.venue_name
    ,p.event_series_id
    ,p.event_id
    ,p.event_name
    ,p.event_date
    ,p.event_tickets
    ,p.ticket_group_id
    ,p.price_category
    ,p.ticket_sales_id
    ,p.ticket_quantity
    ,p.sales_date
    ,p.reseller_id
    ,p.reseller_name
    ,t.ticket_id
    ,t.serial_code
    ,t.status
    ,t.issued_to_name
    ,t.issued_to_id
    ,t.assigned_section
    ,t.assigned_row
    ,t.assigned_seat
from
    event_system.customer_event_purchases_v p
    join event_system.tickets t
        on p.ticket_sales_id = t.ticket_sales_id;
