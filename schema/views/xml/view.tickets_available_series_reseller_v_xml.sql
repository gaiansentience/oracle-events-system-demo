create or replace view tickets_available_series_reseller_v_xml as
with event_resellers as
(
    select
        e.event_series_id
        ,ta.reseller_id
        ,min(r.reseller_name) as reseller_name
    from 
        event_system.events e
        join event_system.ticket_groups tg 
            on e.event_id = tg.event_id
        join event_system.ticket_assignments ta 
            on tg.ticket_group_id = ta.ticket_group_id
        join event_system.resellers r
            on r.reseller_id = ta.reseller_id
    group by
        e.event_series_id
        ,ta.reseller_id
), reseller_ticket_groups as
(
    select
        e.event_series_id
        ,ta.reseller_id
        ,tg.price_category
    from 
        event_system.events e
        join event_system.ticket_groups tg 
            on e.event_id = tg.event_id
        join event_system.ticket_assignments ta 
            on tg.ticket_group_id = ta.ticket_group_id
    group by
        e.event_series_id
        ,ta.reseller_id
        ,tg.price_category
), xml_base as
(
    select
        e.venue_id
        ,e.event_series_id
        ,er.reseller_id
        ,xmlelement("event_series_ticket_availability"
            ,xmlelement("ticket_sources", er.reseller_name)
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
                                from event_system.tickets_available_series_reseller_v ta 
                                where 
                                    ta.event_series_id = g.event_series_id
                                    and ta.price_category = g.price_category
                                    and ta.reseller_id = rtg.reseller_id)
                            )
                        )
                    )
                from 
                    event_system.event_series_ticket_prices_v g 
                    join reseller_ticket_groups rtg 
                        on g.event_series_id = rtg.event_series_id
                        and g.price_category = rtg.price_category 
                where 
                    g.event_series_id = e.event_series_id 
                    and rtg.reseller_id = er.reseller_id)
            )
        ) as xml_doc
    from 
        event_system.venue_event_series_base_v e
        join event_resellers er 
            on e.event_series_id = er.event_series_id
)
select
    b.venue_id
    ,b.event_series_id
    ,b.reseller_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;