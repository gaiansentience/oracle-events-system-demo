create or replace view customer_event_purchases_v_xml as
with xml_base as
(
    select
        c.customer_id
        ,c.event_id
        ,c.event_series_id
        ,xmlelement("customer_event_ticket_purchases",
            xmlforest(
                xmlforest(
                    c.customer_id     as "customer_id"
                    ,c.customer_name  as "customer_name"
                    ,c.customer_email as "customer_email"
                ) as "customer"
                ,xmlforest(
                    xmlforest(
                        c.venue_id    as "venue_id"
                        ,c.venue_name as "venue_name"
                    ) as "venue"
                    ,c.event_series_id as "event_series_id"
                    ,c.event_id        as "event_id"
                    ,c.event_name      as "event_name"
                    ,c.event_date      as "event_date"
                    ,c.event_tickets   as "event_tickets"    
                    ,(
                    select 
                        xmlagg(
                            xmlelement("purchase",
                                xmlforest(
                                    p.ticket_group_id  as "ticket_group_id"
                                    ,p.price_category  as "price_category"
                                    ,p.ticket_sales_id as "ticket_sales_id"
                                    ,p.ticket_quantity as "ticket_quantity"
                                    ,p.sales_date      as "sales_date"
                                    ,p.reseller_id     as "reseller_id"
                                    ,p.reseller_name   as "reseller_name"
                                )
                            )
                        )
                    from event_system.customer_event_purchases_v p
                    where 
                        p.customer_id = c.customer_id
                        and p.event_id = c.event_id
                    ) as "purchases"
                ) as "event"
            )
        ) as xml_doc
    from event_system.customer_events_v c
)
select
    b.customer_id
    ,b.event_id
    ,b.event_series_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;