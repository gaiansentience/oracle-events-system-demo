create or replace view customer_event_ticket_base_v as
select
    ts.customer_id
    ,tg.event_id
    ,e.event_series_id
/*
    ,sum(ts.ticket_quantity) over 
        (partition by tg.event_id, ts.customer_id) as total_tickets_purchased
    ,sum(ts.ticket_quantity) over
        (partition by e.event_series_id, ts.customer_id) as total_series_tickets_purchased
*/
    ,tg.ticket_group_id
    ,tg.price_category
    ,ts.ticket_sales_id
    ,ts.ticket_quantity
    ,ts.sales_date
    ,ts.reseller_id
    ,nvl(r.reseller_name, 'VENUE DIRECT SALES') as reseller_name
from
    events e
    join ticket_groups tg 
        on e.event_id = tg.event_id
    join ticket_sales ts 
        on tg.ticket_group_id = ts.ticket_group_id
    left outer join resellers r 
        on ts.reseller_id = r.reseller_id;