create or replace view tickets_available_series_all_v_xml as
with xml_base as
(
    select
        e.venue_id
        ,e.event_series_id
        ,xmlelement("event_series_ticket_availability"
            ,xmlelement("ticket_sources", 'ALL RESELLERS AND VENUE DIRECT SALES')
            ,xmlelement("event_series"
                ,xmlelement("venue"
                    ,xmlforest(
                        e.venue_id    as "venue_id"
                        ,e.venue_name as "venue_name"
                    )
                )
                ,xmlforest(
                    e.event_series_id   as "event_series_id"
                    ,e.event_name       as "event_name"
                    ,e.first_event_date as "first_event_date"
                    ,e.last_event_date  as "last_event_date"
                    ,e.events_in_series as "events_in_series"
                )
            )
            ,xmlelement("ticket_groups"
                ,(select 
                    xmlagg(
                        xmlelement("ticket_group"
                            ,xmlforest(
                                g.price_category as "price_category"
                                ,g.price         as "price"
                            )
                            ,xmlelement("ticket_resellers"
                                ,(select 
                                    xmlagg(
                                        xmlelement("reseller"
                                            ,xmlforest(
                                                ta.reseller_id        as "reseller_id"
                                                ,ta.reseller_name     as "reseller_name"
                                                ,ta.tickets_available as "tickets_available"
                                                ,ta.events_available  as "events_available"
                                                ,ta.events_sold_out   as "events_sold_out"
                                            )
                                        )
                                    )
                                from event_system.tickets_available_series_all_v ta 
                                where 
                                    ta.event_series_id = g.event_series_id
                                    and ta.price_category = g.price_category)
                            )
                        )
                    )
                from event_system.event_series_ticket_prices_v g 
                where g.event_series_id = e.event_series_id)
            )
        ) as xml_doc
    from event_system.venue_event_series_base_v e
)
select
    b.venue_id
    ,b.event_series_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;