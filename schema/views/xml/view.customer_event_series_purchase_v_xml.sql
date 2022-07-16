create or replace view customer_event_series_purchase_v_xml as
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
), xml_base as
(
    select
        c.customer_id
        ,es.event_series_id
        ,xmlelement("customer_event_series_ticket_purchases"
            ,xmlforest(
                xmlforest(
                    c.customer_id as "customer_id" 
                    ,c.customer_name as "customer_name"
                    ,c.customer_email as "customer_email"
                ) as "customer"
                ,xmlforest(
                    xmlforest( 
                        es.venue_id as "venue_id" 
                        ,es.venue_name as "venue_name" 
                    ) as "venue"
                    ,es.event_series_id as "event_series_id" 
                    ,es.event_name as "event_name" 
                    ,es.first_event_date as "first_event_date" 
                    ,es.last_event_date as "last_event_date" 
                    ,st.series_tickets as "series_tickets"
                ) as "event_series"
            )
            ,xmlelement("events"
                ,(
                select 
                    xmlagg(
                        xmlelement("event"
                            ,xmlforest(
                                e.event_id as "event_id", 
                                e.event_date as "event_date", 
                                et.event_tickets as "event_tickets"
                                ,(
                                select 
                                    xmlagg( 
                                        xmlelement("ticket_purchase"
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
                                from event_system.customer_event_ticket_base_v ct 
                                where 
                                    ct.customer_id = et.customer_id 
                                    and ct.event_id = e.event_id
                                ) as "event_ticket_purchases"
                            )
                        )
                    )
                from 
                    event_system.venue_event_base_v e 
                    join customer_event_tickets et 
                        on e.event_id = et.event_id
                where 
                    e.event_series_id = es.event_series_id 
                    and et.customer_id = st.customer_id
                )
            )
        ) as xml_doc
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
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;