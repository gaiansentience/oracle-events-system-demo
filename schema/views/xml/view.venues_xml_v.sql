create or replace view venues_xml_v as 
with xml_base as
(
    select
        v.venue_id
        ,xmlelement("venue"
            ,xmlforest(
                v.venue_id            as "venue_id"
                ,v.venue_name         as "venue_name"
                ,v.organizer_email    as "organizer_email"
                ,v.organizer_name     as "organizer_name"
                ,v.max_event_capacity as "max_event_capacity"
                ,(
                    select count(*)
                    from event_system.events e
                    where
                        e.venue_id = v.venue_id
                        and e.event_date > trunc(sysdate)
                ) as "venue_scheduled_events"
            )
        ) as xml_doc
    from event_system.venues v
)
select
    b.venue_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;