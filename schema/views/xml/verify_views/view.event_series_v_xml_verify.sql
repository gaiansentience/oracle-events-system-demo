create or replace view event_series_v_xml_verify as
with base as
(
    select
        event_series_id
        ,xml_doc
    from event_system.event_series_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    where rownum >= 1    
)
select 
    s.venue_id
    ,s.venue_name
    ,b.event_series_id
    ,s.event_series_id as event_series_id_xml
    ,s.event_series_name
    ,s.events_in_series
    ,s.tickets_available_all_events
    ,s.tickets_remaining_all_events
    ,s.events_sold_out
    ,s.events_still_available
    ,e.event_id
    ,e.event_name
    ,e.event_date
    ,e.tickets_available
    ,e.tickets_remaining
from 
    base b,
    xmltable('/event_series' passing b.xml_doc 
        columns
            venue_id                      number        path 'venue/venue_id'
            ,venue_name                   varchar2(100) path 'venue/venue_name'
            ,event_series_id              number        path 'event_series_id'
            ,event_series_name            varchar2(100) path 'event_series_name'
            ,events_in_series             number        path 'events_in_series'
            ,tickets_available_all_events number        path 'tickets_available_all_events'
            ,tickets_remaining_all_events number        path 'tickets_remaining_all_events'
            ,events_sold_out              number        path 'events_sold_out'
            ,events_still_available       number        path 'events_still_available'
            ,series_events                xmltype       path 'series_events/event'
    ) s,
    xmltable('/event' passing s.series_events 
        columns
            event_id           number        path 'event_id'
            ,event_name        varchar2(100) path 'event_name'
            ,event_date        date          path 'event_date'
            ,tickets_available number        path 'tickets_available'
            ,tickets_remaining number        path 'tickets_remaining'
    ) e;