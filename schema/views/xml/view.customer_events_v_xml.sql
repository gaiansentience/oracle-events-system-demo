create or replace view customer_events_v_xml as
with customer_venues as
(
    select
        customer_id
        ,min(customer_name) as customer_name
        ,min(customer_email) as customer_email
        ,min(venue_name) as venue_name
        ,venue_id
    from
        customer_events_v 
    group by
        customer_id
        ,venue_id
), xml_base as
(
    select
        v.customer_id
        ,v.venue_id
        ,xmlelement("customer_events",
            xmlforest(
                xmlforest(
                    v.customer_id     as "customer_id"
                    ,v.customer_name  as "customer_name"
                    ,v.customer_email as "customer_email"
                ) as "customer"
                ,xmlforest(
                    v.venue_id    as "venue_id"
                    ,v.venue_name as "venue_name"
                ) as "venue"
            )
            ,xmlelement("event_listing"
                ,(select
                    xmlagg(
                        xmlelement("event"
                            ,xmlforest(
                                e.event_series_id as "event_series_id"
                                ,e.event_id        as "event_id"
                                ,e.event_name      as "event_name"
                                ,e.event_date      as "event_date"
                                ,e.event_tickets   as "event_tickets"                        
                            )
                        )
                    )
                from event_system.customer_events_v e
                where
                    e.venue_id = v.venue_id
                    and e.customer_id = v.customer_id
                )
            )
        ) as xml_doc
    from customer_venues v
    --event_system.customer_events_v c
)
select
    b.customer_id
    ,b.venue_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;