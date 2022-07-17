create or replace view customer_event_series_v_xml as
with customer_venues as
(
    select
        customer_id
        ,min(customer_name) as customer_name
        ,min(customer_email) as customer_email
        ,min(venue_name) as venue_name
        ,venue_id
    from
        customer_event_series_v 
    group by
        customer_id
        ,venue_id
), xml_base as
(
    select
        v.customer_id
        ,v.venue_id
        ,xmlelement("customer_event_series"
            ,xmlforest(
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
            ,xmlelement("event_series_listing"
                ,(select
                    xmlagg(
                        xmlelement("event_series"
                            ,xmlforest(
                                es.event_series_id   as "event_series_id" 
                                ,es.event_series_name as "event_series_name" 
                                ,es.first_event_date  as "first_event_date" 
                                ,es.last_event_date   as "last_event_date" 
                                ,es.series_events     as "series_events"
                                ,es.series_tickets    as "series_tickets"
                            ) 
                        )
                    )
                from event_system.customer_event_series_v es
                where
                    es.customer_id = v.customer_id
                    and es.venue_id = v.venue_id
                )
            )
        ) as xml_doc
    from customer_venues v
)
select
    b.customer_id
    ,b.venue_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;