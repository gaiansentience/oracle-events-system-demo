create or replace view tickets_available_series_venue_v_xml_verify as
with base as
(
    select
        venue_id
        ,event_series_id
        ,xml_doc
    from tickets_available_series_venue_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    --this view causes xml anomaly (see unit test scripts for web service views)
    where rownum >= 1    
)
select
    b.venue_id
    ,e.venue_id as venue_id_xml
    ,e.venue_name
    ,b.event_series_id
    ,e.event_series_id as event_series_id_xml
    ,e.event_name
    ,e.first_event_date
    ,e.last_event_date
    ,e.events_in_series
    ,g.price_category
    ,g.price
    ,r.reseller_id
    ,r.reseller_name
    ,r.tickets_available
    ,r.events_available
    ,r.events_sold_out
from
    base b,
    xmltable('/event_series_ticket_availability' passing b.xml_doc
        columns
            venue_id           number        path 'event_series/venue/venue_id'
            ,venue_name        varchar2(100) path 'event_series/venue/venue_name'
            ,event_series_id   number        path 'event_series/event_series_id'
            ,event_name        varchar2(100) path 'event_series/event_name'
            ,first_event_date  date          path 'event_series/first_event_date'
            ,last_event_date   date          path 'event_series/last_event_date'
            ,events_in_series  number        path 'event_series/events_in_series'
            ,ticket_group      xmltype       path 'ticket_groups/ticket_group'
    ) e,
    xmltable('/ticket_group' passing e.ticket_group
        columns
            price_category varchar2(50)  path 'price_category'
            ,price         number        path 'price'
            ,reseller      xmltype       path 'ticket_resellers/reseller'
    ) g,
    xmltable('/reseller' passing g.reseller
        columns
            reseller_id        number        path 'reseller_id'
            ,reseller_name     varchar2(100) path 'reseller_name'
            ,tickets_available number        path 'tickets_available'
            ,events_available  number        path 'events_available'
            ,events_sold_out   number        path 'events_sold_out'
    ) r;