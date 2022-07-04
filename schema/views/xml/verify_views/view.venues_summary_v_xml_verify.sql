create or replace view venues_summary_v_xml_verify as
with base as
(
    select
        venue_id
        ,xml_doc
    from event_system.venues_summary_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    where rownum >= 1    
)
select 
    b.venue_id
    ,t.venue_id as venue_id_xml
    ,t.venue_name
    ,t.organizer_name
    ,t.organizer_email
    ,t.max_event_capacity
    ,t.events_scheduled
    ,t.first_event_date
    ,t.last_event_date
    ,t.min_event_tickets
    ,t.max_event_tickets
from 
    base b,
    xmltable('/venue_summary' passing b.xml_doc 
        columns
            venue_id            number        path 'venue/venue_id'
            ,venue_name         varchar2(100) path 'venue/venue_name'
            ,organizer_email    varchar2(100) path 'venue/organizer_email'
            ,organizer_name     varchar2(100) path 'venue/organizer_name'
            ,max_event_capacity number        path 'venue/max_event_capacity'
            ,events_scheduled   number        path 'event_summary/events_scheduled'
            ,first_event_date   date          path 'event_summary/first_event_date'
            ,last_event_date    date          path 'event_summary/last_event_date'
            ,min_event_tickets  number        path 'event_summary/min_event_tickets'
            ,max_event_tickets  number        path 'event_summary/max_event_tickets'
    ) t;