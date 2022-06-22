create or replace view tickets_available_reseller_v_xml as
with event_resellers as
(
    select
        tg.event_id
        ,ta.reseller_id
        ,max(r.reseller_name) as reseller_name
    from 
        event_system.ticket_groups tg 
        join event_system.ticket_assignments ta 
            on tg.ticket_group_id = ta.ticket_group_id
        join event_system.resellers r 
            on ta.reseller_id = r.reseller_id
    group by
        tg.event_id
        ,ta.reseller_id
), reseller_ticket_groups as
(
    select
        tg.event_id
        ,ta.reseller_id
        ,ta.ticket_group_id
    from 
        event_system.ticket_groups tg 
        join event_system.ticket_assignments ta 
            on tg.ticket_group_id = ta.ticket_group_id
    group by
        tg.event_id
        ,ta.reseller_id
        ,ta.ticket_group_id
), xml_base as
(
    select
        e.venue_id
        ,e.event_id
        ,er.reseller_id   --er.reseller_name
        ,xmlelement("event_ticket_availability"
            ,xmlelement("ticket_sources", er.reseller_name)
            ,xmlelement("event"
                ,xmlelement("venue"
                    ,xmlforest(
                        e.venue_id    as "venue_id"
                        ,e.venue_name as "venue_name"
                    )
                )
                ,xmlforest(
                    e.event_id           as "event_id"
                    ,e.event_name        as "event_name"
                    ,e.event_date        as "event_date"
                    ,e.tickets_available as "event_tickets_available"
                )
            )
            ,xmlelement("ticket_groups"
                ,(select 
                    xmlagg(
                        xmlelement("ticket_group"
                            ,xmlforest(
                                g.ticket_group_id    as "ticket_group_id"
                                ,g.price_category    as "price_category"
                                ,g.price             as "price"
                                ,g.tickets_available as "tickets_available"
                                ,g.tickets_sold      as "tickets_sold"
                                ,g.tickets_remaining as "tickets_remaining"
                            )
                            ,xmlelement("ticket_resellers"
                                ,(select 
                                    xmlagg(
                                        xmlelement("reseller"
                                            ,xmlforest(
                                                ta.reseller_id        as "reseller_id"
                                                ,ta.reseller_name     as "reseller_name"
                                                ,ta.tickets_available as "reseller_tickets_available"
                                                ,ta.ticket_status     as "reseller_ticket_status"
                                            )
                                        )
                                    )
                                from event_system.tickets_available_reseller_v ta 
                                where 
                                    ta.ticket_group_id = g.ticket_group_id
                                    and ta.reseller_id = rtg.reseller_id)
                            )
                        )
                    )
                from 
                    event_system.event_ticket_prices_v g 
                    join reseller_ticket_groups rtg 
                        on g.ticket_group_id = rtg.ticket_group_id 
                where 
                    g.event_id = e.event_id 
                    and rtg.reseller_id = er.reseller_id)
            )
        ) as xml_doc
    from 
        event_system.venue_event_base_v e
        join event_resellers er 
            on e.event_id = er.event_id
)
select
    b.venue_id
    ,b.event_id
    ,b.reseller_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;