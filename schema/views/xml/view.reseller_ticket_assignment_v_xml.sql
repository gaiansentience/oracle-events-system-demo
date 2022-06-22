create or replace view reseller_ticket_assignment_v_xml as
with xml_base as
(
    select
        e.venue_id
        ,e.event_id
        ,xmlelement("reseller_ticket_assignment"
            ,xmlelement("event"
                ,xmlelement("venue"
                    ,xmlforest(
                        e.venue_id         as "venue_id"
                        ,e.venue_name      as "venue_name"
                        ,e.organizer_email as "organizer_email"
                        ,e.organizer_name  as "organizer_name"
                    )
                )
                ,xmlforest(
                    e.event_id           as "event_id"
                    ,e.event_name        as "event_name"
                    ,e.event_date        as "event_date"
                    ,e.tickets_available as "event_tickets_available"
                )
            )
            ,xmlelement("ticket_resellers"
                ,(select 
                    xmlagg(
                        xmlelement("reseller"
                            ,xmlforest(
                                r.reseller_id     as "reseller_id"
                                ,r.reseller_name  as "reseller_name"
                                ,r.reseller_email as "reseller_email"
                                )
                            ,xmlelement("ticket_assignments"
                                ,(select 
                                    xmlagg(
                                        xmlelement("ticket_group"
                                            ,xmlforest(
                                                tg.ticket_group_id       as "ticket_group_id"
                                                ,tg.price_category       as "price_category"
                                                ,tg.price                as "price"
                                                ,tg.tickets_in_group     as "tickets_in_group"
                                                ,tg.currently_assigned   as "tickets_assigned"
                                                ,tg.ticket_assignment_id as "ticket_assignment_id"
                                                ,tg.assigned_to_others   as "assigned_to_others"
                                                ,tg.max_available        as "max_available"
                                                ,tg.min_assignment       as "min_assignment"
                                                ,tg.sold_by_reseller     as "sold_by_reseller"
                                                ,tg.sold_by_venue        as "sold_by_venue"
                                            )
                                        )   
                                    ) 
                                from event_system.reseller_ticket_assignment_v tg
                                where 
                                    tg.event_id = e.event_id 
                                    and tg.reseller_id = r.reseller_id) 
                            ) 
                        )
                    )
                from event_system.resellers r) 
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