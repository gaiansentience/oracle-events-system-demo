create or replace view events_v_xml_verify as
with base as
(
    select
        venue_id
        ,event_id
        ,xml_doc
    from event_system.events_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    where rownum >= 1    
)
select 
    b.venue_id
    ,e.venue_id as venue_id_xml
    ,e.venue_name
    ,e.organizer_name
    ,e.organizer_email
    ,b.event_id
    ,e.event_id as event_id_xml
    ,e.event_series_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available
    ,e.tickets_remaining
from 
    base b,
    xmltable('/event' passing b.xml_doc 
        columns
            venue_id            number        path 'venue/venue_id'
            ,venue_name         varchar2(100) path 'venue/venue_name'
            ,organizer_name     varchar2(100) path 'venue/organizer_name'
            ,organizer_email    varchar2(100) path 'venue/organizer_email'
            ,event_id           number        path 'event_id'
            ,event_series_id    number        path 'event_series_id'
            ,event_name         varchar2(100) path 'event_name'
            ,event_date         date          path 'event_date'
            ,tickets_available  number        path 'tickets_available'
            ,tickets_remaining  number        path 'tickets_remaining'
    ) e;
