create or replace view customer_event_tickets_v_json as
with json_base as
(
    select
        e.customer_id
        ,e.event_id
        ,e.event_series_id
        ,json_object(
            'customer_id'      : e.customer_id
            ,'customer_name'   : e.customer_name
            ,'customer_email'  : e.customer_email      
            ,'venue_id'        : e.venue_id
            ,'venue_name'      : e.venue_name
            ,'event_id'        : e.event_id
            ,'event_series_id' : e.event_series_id
            ,'event_name'      : e.event_name
            ,'event_date'      : e.event_date
            ,'event_tickets'   : e.event_tickets
            ,'purchases'  :
                (select 
                    json_arrayagg(
                        json_object(
                            'ticket_group_id'  : p.ticket_group_id
                            ,'price_category'  : p.price_category
                            ,'ticket_sales_id' : p.ticket_sales_id
                            ,'ticket_quantity' : p.ticket_quantity
                            ,'sales_date'      : p.sales_date
                            ,'reseller_id'     : p.reseller_id
                            ,'reseller_name'   : p.reseller_name
                            ,'tickets' :  
                            (select
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
                                    )
                                )
                            from event_system.customer_event_tickets_v t
                            where 
                                t.customer_id = p.customer_id
                                and t.event_id = p.event_id
                                and t.ticket_sales_id = p.ticket_sales_id
                            )
                        )
                    )
                from event_system.customer_event_purchases_v p
                where 
                    p.customer_id = e.customer_id
                    and p.event_id = e.event_id)
        ) as json_doc
    from event_system.customer_events_v e
)
select
    b.customer_id
    ,b.event_id
    ,b.event_series_id
    ,b.json_doc
    ,json_serialize(b.json_doc pretty) as json_doc_formatted
from json_base b;