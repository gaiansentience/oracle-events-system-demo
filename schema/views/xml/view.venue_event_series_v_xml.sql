create or replace view venue_event_series_v_xml as
with xml_base as
(
    select
        v.venue_id
        ,xmlelement("venue_events"
            ,xmlelement("venue"
                ,xmlforest(
                    v.venue_id            as "venue_id"
                    ,v.venue_name         as "venue_name"
                    ,v.organizer_name     as "organizer_name"
                    ,v.organizer_email    as "organizer_email"
                    ,v.max_event_capacity as "max_event_capacity"
                    ,v.events_scheduled   as "events_scheduled"
                )
            )
            ,xmlelement("venue_event_listing"
                ,(select 
                    xmlagg(
                        xmlelement("event"
                            ,xmlforest(
                                e.event_id           as "event_id"
                                ,e.event_series_id   as "event_series_id"
                                ,e.event_name        as "event_name"
                                ,e.event_date        as "event_date"
                                ,e.tickets_available as "tickets_available"
                                ,e.tickets_remaining as "tickets_remaining"
                            ) 
                        )
                    )
                from event_system.venue_event_series_v e
                where e.venue_id = v.venue_id)
            )
        ) as xml_doc
    from event_system.venues_v v
)
select
    b.venue_id
    ,b.xml_doc
    ,xmlserialize(content b.xml_doc as clob indent) as xml_doc_formatted
from xml_base b;