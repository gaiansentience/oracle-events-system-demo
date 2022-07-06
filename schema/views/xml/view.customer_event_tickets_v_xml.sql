create or replace view customer_event_tickets_v_xml as
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
), xml_base as
(
    select
        c.customer_id
        ,e.event_id
        ,e.event_series_id
        ,xmlelement("customer_tickets",
            xmlforest(
                xmlforest(
                    c.customer_id     as "customer_id"
                    ,c.customer_name  as "customer_name"
                    ,c.customer_email as "customer_email"
                ) as "customer"
                ,xmlforest(
                    xmlforest(
                        e.venue_id    as "venue_id"
                        ,e.venue_name as "venue_name"
                    ) as "venue"
                    ,e.event_id   as "event_id"
                    ,e.event_name as "event_name"
                    ,e.event_date as "event_date"
                    ,t.event_tickets as "event_tickets"    
                    ,(
                    select 
                        xmlagg(
                            xmlelement("ticket_purchase",
                                xmlforest(
                                    ct.ticket_group_id  as "ticket_group_id"
                                    ,ct.price_category  as "price_category"
                                    ,ct.ticket_sales_id as "ticket_sales_id"
                                    ,ct.ticket_quantity as "ticket_quantity"
                                    ,ct.sales_date      as "sales_date"
                                    ,ct.reseller_id     as "reseller_id"
                                    ,ct.reseller_name   as "reseller_name"
                                )
                            )
                        )
                    from event_system.customer_event_ticket_base_v ct
                    where 
                        ct.customer_id = c.customer_id
                        and ct.event_id = e.event_id
                    ) as "event_ticket_purchases"
                ) as "event"
            )
        ) as xml_doc
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
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;