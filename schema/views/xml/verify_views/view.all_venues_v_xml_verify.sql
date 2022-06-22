create or replace view all_venues_v_xml_verify as
select 
    t.venue_id
    ,t.venue_name
    ,t.organizer_email
    ,t.organizer_name
    ,t.max_event_capacity
    ,t.venue_scheduled_events
from 
    all_venues_v_xml x,
    xmltable('/all_venues/venue' passing x.xml_doc 
        columns
            venue_id                number        path 'venue_id'
            ,venue_name             varchar2(100) path 'venue_name'
            ,organizer_email        varchar2(100) path 'organizer_email'
            ,organizer_name         varchar2(100) path 'organizer_name'
            ,max_event_capacity     number        path 'max_event_capacity'
            ,venue_scheduled_events number        path 'venue_scheduled_events'
    ) t;
