create or replace view venues_summary_xml_v as
with xml_base as
(
    select
        v.venue_id
        ,xmlelement("venue_summary"
            ,xmlforest(
                xmlforest(
                    v.venue_id            as "venue_id"
                    ,v.venue_name         as "venue_name"
                    ,v.organizer_email    as "organizer_email"
                    ,v.organizer_name     as "organizer_name"
                    ,v.max_event_capacity as "max_event_capacity"
                ) as "venue"
                ,xmlforest(
                    v.events_scheduled   as "events_scheduled"
                    ,v.first_event_date  as "first_event_date"
                    ,v.last_event_date   as "last_event_date"
                    ,v.min_event_tickets as "min_event_tickets"
                    ,v.max_event_tickets as "max_event_tickets"
                ) as "event_summary"
            )
        ) as xml_doc
    from event_system.venues_summary_v v
)
select
    b.venue_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;