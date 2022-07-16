create or replace view customer_event_series_purchase_v_json as
with customer_series_tickets as
(
    select
        b.event_series_id
        ,b.customer_id
        ,sum(b.ticket_quantity) series_tickets
    from event_system.customer_event_purchase_base_v b
    group by 
        b.event_series_id
        ,b.customer_id
), customer_event_tickets as
(
    select
        b.event_series_id
        ,b.event_id
        ,b.customer_id
        ,sum(b.ticket_quantity) event_tickets
    from event_system.customer_event_purchase_base_v b
    group by 
        b.event_series_id
        ,b.event_id
        ,b.customer_id
), json_base as
(
    select
        c.customer_id
        ,es.event_series_id
        ,json_object(
            'customer_id'     : c.customer_id
            ,'customer_name'  : c.customer_name
            ,'customer_email' : c.customer_email      
            ,'venue_id'       : es.venue_id
            ,'venue_name'     : es.venue_name
            ,'event_series_id'       : es.event_series_id
            ,'event_name'     : es.event_name
            ,'first_event_date' : es.first_event_date
            ,'last_event_date' : es.last_event_date
            ,'series_tickets' : st.series_tickets
            ,'events' : 
                (
                select
                    json_arrayagg(
                        json_object(
                            'event_id' : e.event_id
                            ,'event_date'     : e.event_date
                            ,'event_tickets' : et.event_tickets
                            ,'event_ticket_purchases'  :
                                (
                                select 
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
                                    returning clob)
                                from event_system.customer_event_ticket_base_v ct
                                where 
                                    ct.customer_id = et.customer_id
                                    and ct.event_id = e.event_id
                                )                
                        returning clob)
                    returning clob)
                from
                    event_system.venue_event_base_v e 
                    join customer_event_tickets et 
                        on e.event_id = et.event_id
                where 
                    e.event_series_id = es.event_series_id 
                    and et.customer_id = st.customer_id                    
                )
        returning clob) as json_doc
    from 
        event_system.venue_event_series_base_v es 
        join customer_series_tickets st 
            on es.event_series_id = st.event_series_id
        join event_system.customers c 
            on st.customer_id = c.customer_id
)
select
    b.customer_id
    ,b.event_series_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;