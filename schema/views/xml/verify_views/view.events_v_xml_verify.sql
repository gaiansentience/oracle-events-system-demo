create or replace view events_v_xml_verify as
select 
    x.venue_id
    ,e.venue_id as venue_id_xml
    ,e.venue_name
    ,e.organizer_name
    ,e.organizer_email
    ,x.event_id
    ,e.event_id as event_id_xml
    ,e.event_name
    ,e.event_date
    ,e.tickets_available
    ,e.tickets_remaining
from 
    events_v_xml x,
    xmltable('/event' passing x.xml_doc 
        columns
            venue_id            number        path 'venue/venue_id'
            ,venue_name         varchar2(100) path 'venue/venue_name'
            ,organizer_name     varchar2(100) path 'venue/organizer_name'
            ,organizer_email    varchar2(100) path 'venue/organizer_email'
            ,event_id           number        path 'event_id'
            ,event_name         varchar2(100) path 'event_name'
            ,event_date         date          path 'event_date'
            ,tickets_available  number        path 'tickets_available'
            ,tickets_remaining  number        path 'tickets_remaining'
    ) e;
