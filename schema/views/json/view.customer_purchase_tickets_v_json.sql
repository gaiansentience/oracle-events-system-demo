create or replace view customer_purchase_tickets_v_json as
with json_base as
(
    select
        p.customer_id
        ,p.event_id
        ,p.event_series_id
        ,p.ticket_sales_id
        ,json_object(
            'customer_id'      : p.customer_id
            ,'customer_name'   : p.customer_name
            ,'customer_email'  : p.customer_email      
            ,'venue_id'        : p.venue_id
            ,'venue_name'      : p.venue_name
            ,'event_id'        : p.event_id
            ,'event_series_id' : p.event_series_id
            ,'event_name'      : p.event_name
            ,'event_date'      : p.event_date
            ,'event_tickets'   : p.event_tickets
            ,'purchase'  :
                json_object(
                    'ticket_group_id'  : p.ticket_group_id
                    ,'price_category'  : p.price_category
                    ,'ticket_sales_id' : p.ticket_sales_id
                    ,'ticket_quantity' : p.ticket_quantity
                    ,'sales_date'      : p.sales_date
                    ,'reseller_id'     : p.reseller_id
                    ,'reseller_name'   : p.reseller_name
                    ,'tickets' :  
                        (
                        select
                            json_arrayagg(
                                json_object(
                                    'ticket_id'         : t.ticket_id
                                    ,'serial_code'      : t.serial_code
                                    ,'status'           : t.status
                                    ,'issued_to_name'   : t.issued_to_name
                                    ,'issued_to_id'     : t.issued_to_id
                                    ,'assigned_section' : t.assigned_section
                                    ,'assigned_row'     : t.assigned_row
                                    ,'assigned_seat'    : t.assigned_seat
                                absent on null returning clob)
                            returning clob)
                        from event_system.tickets t
                        where t.ticket_sales_id = p.ticket_sales_id
                        )
                returning clob)
        returning clob) as json_doc
    from event_system.customer_event_purchases_v p
)
select
    b.customer_id
    ,b.event_id
    ,b.event_series_id
    ,b.ticket_sales_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;