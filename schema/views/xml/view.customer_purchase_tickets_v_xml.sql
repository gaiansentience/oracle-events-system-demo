create or replace view customer_purchase_tickets_v_xml as
with xml_base as
(
    select
        p.customer_id
        ,p.event_id
        ,p.event_series_id
        ,p.ticket_sales_id
        ,xmlelement("customer_tickets",
            xmlforest(
                xmlforest(
                    p.customer_id     as "customer_id"
                    ,p.customer_name  as "customer_name"
                    ,p.customer_email as "customer_email"
                ) as "customer"
                ,xmlforest(
                    xmlforest(
                        p.venue_id    as "venue_id"
                        ,p.venue_name as "venue_name"
                    ) as "venue"
                    ,p.event_series_id as "event_series_id"
                    ,p.event_id        as "event_id"
                    ,p.event_name      as "event_name"
                    ,p.event_date      as "event_date"
                    ,p.event_tickets   as "event_tickets"    
                    ,(
                        xmlelement("purchase"
                            ,xmlforest(
                                p.ticket_group_id  as "ticket_group_id"
                                ,p.price_category  as "price_category"
                                ,p.ticket_sales_id as "ticket_sales_id"
                                ,p.ticket_quantity as "ticket_quantity"
                                ,p.sales_date      as "sales_date"
                                ,p.reseller_id     as "reseller_id"
                                ,p.reseller_name   as "reseller_name"
                                ,(
                                select
                                    xmlagg(
                                        xmlelement("ticket"
                                            ,xmlforest(
                                                t.ticket_id    as "ticket_id"
                                                ,t.serial_code as "serial_code"
                                                ,t.status      as "status"
                                                ,t.issued_to_name as "issued_to_name"
                                                ,t.issued_to_id as "issued_to_id"
                                                ,t.assigned_section as "assigned_section"
                                                ,t.assigned_row as "assigned_row"
                                                ,t.assigned_seat as "assigned_seat"
                                            )
                                        )
                                    )
                                from event_system.tickets t
                                where t.ticket_sales_id = p.ticket_sales_id
                                ) as "tickets"
                            )
                        )
                    ) as "purchases"
                ) as "event"
            )
        ) as xml_doc
    from event_system.customer_event_purchases_v p
)
select
    b.customer_id
    ,b.event_id
    ,b.event_series_id
    ,b.ticket_sales_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;