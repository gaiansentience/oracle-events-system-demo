create or replace view event_series_ticket_groups_v_xml_verify as
with base as
(
    select
        venue_id
        ,event_series_id
        ,xml_doc
    from event_series_ticket_groups_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    where rownum >= 1    
)
select 
    b.venue_id
    ,e.venue_id as venue_id_xml
    ,e.venue_name
    ,b.event_series_id
    ,e.event_series_id as event_series_id_xml
    ,e.event_name
    ,e.events_in_series
    ,e.first_event_date
    ,e.last_event_date
    ,e.event_tickets_available
    ,g.price_category
    ,g.price
    ,g.tickets_available
    ,g.currently_assigned
    ,g.sold_by_venue
from 
    base b,
    xmltable('/event_series_ticket_groups' passing b.xml_doc 
        columns
            venue_id                  number        path 'event_series/venue/venue_id'
            ,venue_name               varchar2(100) path 'event_series/venue/venue_name'
            ,event_series_id          number        path 'event_series/event_series_id'
            ,event_name               varchar2(100) path 'event_series/event_name'
            ,events_in_series         number        path 'event_series/events_in_series'
            ,first_event_date         date          path 'event_series/first_event_date'
            ,last_event_date          date          path 'event_series/last_event_date'
            ,event_tickets_available  number        path 'event_series/event_tickets_available'
            ,ticket_group             xmltype       path 'ticket_groups/ticket_group'
    ) e,
    xmltable('/ticket_group' passing e.ticket_group 
        columns
            price_category     varchar2(50)  path 'price_category'
            ,price              number        path 'price'
            ,tickets_available  number        path 'tickets_available'
            ,currently_assigned number        path 'currently_assigned'
            ,sold_by_venue      number        path 'sold_by_venue'
    ) g;