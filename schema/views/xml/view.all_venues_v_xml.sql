create or replace view all_venues_v_xml as 
with xml_base as
(
    select
        xmlelement("all_venues"
            ,xmlagg(
                xmlelement("venue"
                    ,xmlforest(
                        v.venue_id            as "venue_id"
                        ,v.venue_name         as "venue_name"
                        ,v.organizer_name     as "organizer_name"
                        ,v.organizer_email    as "organizer_email"
                        ,v.max_event_capacity as "max_event_capacity"
                        ,v.events_scheduled   as "events_scheduled"
                    )
                )
            )
        ) as xml_doc
    from event_system.venues_v v
)
select
    b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;