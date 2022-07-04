create or replace view venue_event_series_v_xml_verify as
with base as
(
    select
        venue_id
        ,xml_doc
    from event_system.venue_event_series_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    where rownum >= 1    
)
select 
    b.venue_id
    ,v.venue_id as venue_id_xml
    ,v.venue_name
    ,v.organizer_email
    ,v.organizer_name
    ,v.max_event_capacity
    ,v.venue_scheduled_events
    ,e.event_id
    ,e.event_series_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available
    ,e.tickets_remaining
from 
    base b,
    xmltable('/venue_events/venue' passing b.xml_doc 
        columns
            venue_id                number        path 'venue_id'
            ,venue_name             varchar2(100) path 'venue_name'
            ,organizer_email        varchar2(100) path 'organizer_email'
            ,organizer_name         varchar2(100) path 'organizer_name'
            ,max_event_capacity     number        path 'max_event_capacity'
            ,venue_scheduled_events number        path 'venue_scheduled_events'
    ) v,
    xmltable('/venue_events/venue_event_listing/event' passing b.xml_doc 
        columns
            event_id           number        path 'event_id'
            ,event_series_id   number        path 'event_series_id'
            ,event_name        varchar2(100) path 'event_name'
            ,event_date        date          path 'event_date'
            ,tickets_available number        path 'tickets_available'
            ,tickets_remaining number        path 'tickets_remaining'
    ) e;