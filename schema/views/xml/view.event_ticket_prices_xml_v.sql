create or replace view event_ticket_prices_xml_v as
with xml_base as
(
    select
        e.venue_id
        ,e.event_id
        ,xmlelement("event_ticket_prices"
            ,xmlelement("event"
                ,xmlforest(
                    xmlforest(
                        e.venue_id    as "venue_id"
                        ,e.venue_name as "venue_name"
                    ) as "venue"
                    ,e.event_id          as "event_id"
                    ,e.event_name        as "event_name"
                    ,e.event_date        as "event_date"
                    ,e.tickets_available as "tickets_available"
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
                        )
                    )
                from event_system.event_ticket_prices_v g
                where g.event_id = e.event_id)
            )
        ) as xml_doc
    from event_system.venue_event_base_v e
)
select
    b.venue_id
    ,b.event_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;