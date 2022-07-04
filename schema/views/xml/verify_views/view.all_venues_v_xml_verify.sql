create or replace view all_venues_v_xml_verify as
with base as
(
    select
        xml_doc
    from event_system.all_venues_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    where rownum >= 1    
)
select 
    t.venue_id
    ,t.venue_name
    ,t.organizer_email
    ,t.organizer_name
    ,t.max_event_capacity
    ,t.venue_scheduled_events
from 
    base b,
    xmltable('/all_venues/venue' passing b.xml_doc 
        columns
            venue_id                number        path 'venue_id'
            ,venue_name             varchar2(100) path 'venue_name'
            ,organizer_email        varchar2(100) path 'organizer_email'
            ,organizer_name         varchar2(100) path 'organizer_name'
            ,max_event_capacity     number        path 'max_event_capacity'
            ,venue_scheduled_events number        path 'venue_scheduled_events'
    ) t;
