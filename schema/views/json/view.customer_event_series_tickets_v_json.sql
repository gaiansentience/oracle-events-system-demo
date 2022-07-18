create or replace view customer_event_series_tickets_v_json as
with json_base as
(
    select
        es.customer_id
        ,es.event_series_id
        ,json_object(
            'customer_id'        : es.customer_id
            ,'customer_name'     : es.customer_name
            ,'customer_email'    : es.customer_email      
            ,'venue_id'          : es.venue_id
            ,'venue_name'        : es.venue_name
            ,'event_series_id'   : es.event_series_id
            ,'event_series_name' : es.event_series_name
            ,'first_event_date'  : es.first_event_date
            ,'last_event_date'   : es.last_event_date
            ,'series_events'     : es.series_events
            ,'series_tickets'    : es.series_tickets
            ,'events' : 
                (
                select
                    json_arrayagg(
                        json_object(
                            'event_id'       : e.event_id
                            ,'event_name'    : e.event_name
                            ,'event_date'    : e.event_date
                            ,'event_tickets' : e.event_tickets
                            ,'purchases'     :
                                (
                                select 
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
                                    returning clob)
                                from event_system.customer_event_purchases_v p
                                where 
                                    p.customer_id = e.customer_id
                                    and p.event_id = e.event_id
                                )                
                        returning clob)
                    returning clob)
                from event_system.customer_events_v e
                where 
                    e.event_series_id = es.event_series_id 
                    and e.customer_id = es.customer_id                    
                )
        returning clob) as json_doc
    from event_system.customer_event_series_v es
)
select
    b.customer_id
    ,b.event_series_id
    ,b.json_doc
    ,json_serialize(b.json_doc returning clob pretty) as json_doc_formatted
from json_base b;