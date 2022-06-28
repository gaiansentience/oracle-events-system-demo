create or replace view event_series_ticket_assignment_v_xml as
with event_resellers as
(
    select
        e.event_series_id
        ,r.reseller_id
        ,r.reseller_name
        ,r.reseller_email
    from
        event_system.venue_event_series_base_v e 
        cross join resellers r
), xml_base as
(
    select
        e.venue_id
        ,e.event_series_id
        ,xmlelement("event_series_ticket_assignment"
            ,xmlelement("event_series"
                ,xmlelement("venue"
                    ,xmlforest(
                        e.venue_id         as "venue_id"
                        ,e.venue_name      as "venue_name"
                        ,e.organizer_email as "organizer_email"
                        ,e.organizer_name  as "organizer_name"
                    )
                )
                ,xmlforest(
                    e.event_series_id           as "event_series_id"
                    ,e.event_name        as "event_name"
                    ,e.first_event_date        as "first_event_date"
                    ,e.last_event_date        as "last_event_date"
                    ,e.event_tickets_available as "event_tickets_available"
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
                                                tg.price_category        as "price_category"
                                                ,tg.price                as "price"
                                                ,tg.tickets_in_group     as "tickets_in_group"
                                                ,tg.tickets_assigned     as "tickets_assigned"
                                                ,tg.assigned_to_others   as "assigned_to_others"
                                                ,tg.max_available        as "max_available"
                                                ,tg.min_assignment       as "min_assignment"
                                                ,tg.sold_by_reseller     as "sold_by_reseller"
                                                ,tg.sold_by_venue        as "sold_by_venue"
                                            )
                                        )   
                                    ) 
                                from event_system.event_series_ticket_assignment_v tg
                                where 
                                    tg.event_series_id = e.event_series_id 
                                    and tg.event_series_id = r.event_series_id
                                    and tg.reseller_id = r.reseller_id) 
                            ) 
                        )
                    )
                from event_resellers r
                where r.event_series_id = e.event_series_id)
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