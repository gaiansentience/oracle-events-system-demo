create or replace view customer_event_series_purchases_v_xml as
with xml_base as
(
    select
        es.customer_id
        ,es.event_series_id
        ,xmlelement("customer_event_series_purchases"
            ,xmlforest(
                xmlforest(
                    es.customer_id     as "customer_id" 
                    ,es.customer_name  as "customer_name"
                    ,es.customer_email as "customer_email"
                ) as "customer"
                ,xmlforest(
                    xmlforest( 
                        es.venue_id    as "venue_id" 
                        ,es.venue_name as "venue_name" 
                    ) as "venue"
                    ,es.event_series_id   as "event_series_id" 
                    ,es.event_series_name as "event_series_name" 
                    ,es.first_event_date  as "first_event_date" 
                    ,es.last_event_date   as "last_event_date" 
                    ,es.series_events     as "series_events"
                    ,es.series_tickets    as "series_tickets"
                ) as "event_series"
            )
            ,xmlelement("events"
                ,(
                select 
                    xmlagg(
                        xmlelement("event"
                            ,xmlforest(
                                e.event_id      as "event_id"
                                ,e.event_name    as "event_name"
                                ,e.event_date    as "event_date"
                                ,e.event_tickets as "event_tickets"
                                ,(
                                select 
                                    xmlagg( 
                                        xmlelement("purchase"
                                            ,xmlforest( 
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
                                from event_system.customer_event_purchases_v ct 
                                where 
                                    ct.customer_id = e.customer_id 
                                    and ct.event_id = e.event_id
                                ) as "purchases"
                            )
                        )
                    )
                from
                    event_system.customer_events_v e
                where 
                    e.event_series_id = es.event_series_id 
                    and e.customer_id = es.customer_id
                )
            )
        ) as xml_doc
    from 
        event_system.customer_event_series_v es
)
select
    b.customer_id
    ,b.event_series_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;