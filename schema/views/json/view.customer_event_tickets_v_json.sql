create or replace view customer_event_tickets_v_json as
with customer_event_tickets as
(
    select
        b.event_series_id
        ,b.event_id
        ,b.customer_id
        ,sum(b.ticket_quantity) event_tickets
    from event_system.customer_event_ticket_base_v b
    group by 
        b.event_series_id
        ,b.event_id
        ,b.customer_id
), json_base as
(
    select
        c.customer_id
        ,e.event_id
        ,e.event_series_id
        ,json_object(
            'customer_id'     : c.customer_id
            ,'customer_name'  : c.customer_name
            ,'customer_email' : c.customer_email      
            ,'venue_id'       : e.venue_id
            ,'venue_name'     : e.venue_name
            ,'event_id'       : e.event_id
            ,'event_series_id'       : e.event_series_id
            ,'event_name'     : e.event_name
            ,'event_date'     : e.event_date
            ,'event_tickets' : t.event_tickets
            ,'event_ticket_purchases'  :
                (select 
                    json_arrayagg(
                        json_object(
                            'ticket_group_id'  : ct.ticket_group_id
                            ,'price_category'  : ct.price_category
                            ,'ticket_sales_id' : ct.ticket_sales_id
                            ,'ticket_quantity' : ct.ticket_quantity
                            ,'sales_date'      : ct.sales_date
                            ,'reseller_id'     : ct.reseller_id
                            ,'reseller_name'   : ct.reseller_name
                        )
                    )
                from event_system.customer_event_ticket_base_v ct
                where 
                    ct.customer_id = c.customer_id
                    and ct.event_id = e.event_id)
        ) as json_doc
    from 
        event_system.venue_event_base_v e 
        join customer_event_tickets t 
            on e.event_id = t.event_id
        join event_system.customers c 
            on t.customer_id = c.customer_id
)
select
    b.customer_id
    ,b.event_id
    ,b.event_series_id
    ,b.json_doc
    ,json_serialize(b.json_doc pretty) as json_doc_formatted
from json_base b;