create or replace view events_v_xml as
with xml_base as
(
    select
        e.venue_id
        ,e.event_id
        ,xmlelement("event"
            ,xmlforest(
                xmlforest(
                    e.venue_id         as "venue_id"
                    ,e.venue_name      as "venue_name"
                    ,e.organizer_email as "organizer_email"
                    ,e.organizer_name  as "organizer_name"
                ) as "venue"
                ,e.event_id          as "event_id"
                ,e.event_name        as "event_name"
                ,e.event_date        as "event_date"
                ,e.tickets_available as "tickets_available"
                ,e.tickets_remaining as "tickets_remaining"
            )
        ) as xml_doc
    from event_system.events_v e
)
select
    b.venue_id
    ,b.event_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;