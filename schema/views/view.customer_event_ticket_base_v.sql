create or replace view customer_event_ticket_base_v as
select
    ts.customer_id
    ,tg.event_id
    ,sum(ts.ticket_quantity) over 
        (partition by tg.event_id, ts.customer_id) as total_tickets_purchased
    ,tg.ticket_group_id
    ,tg.price_category
    ,ts.ticket_sales_id
    ,ts.ticket_quantity
    ,ts.sales_date
    ,ts.reseller_id
    ,nvl(r.reseller_name, 'VENUE DIRECT SALES') as reseller_name
from
    ticket_groups tg 
    join ticket_sales ts 
        on tg.ticket_group_id = ts.ticket_group_id
    left outer join resellers r 
        on ts.reseller_id = r.reseller_id;