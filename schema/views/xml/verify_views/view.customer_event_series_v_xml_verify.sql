create or replace view customer_event_series_v_xml_verify as
with base as
(
    select
        customer_id
        ,venue_id
        ,xml_doc
    from customer_event_series_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    --where rownum >= 1    
)
select 
    b.customer_id
    ,c.customer_id as customer_id_xml
    ,c.customer_name
    ,c.customer_email
    ,b.venue_id
    ,c.venue_id as venue_id_xml
    ,c.venue_name
    ,es.event_series_id
    ,es.event_series_name
    ,es.first_event_date
    ,es.last_event_date
    ,es.series_events
    ,es.series_tickets
from 
    base b,
    xmltable('/customer_event_series' passing b.xml_doc 
        columns
            customer_id       number         path 'customer/customer_id'
            ,customer_name    varchar2(100)  path 'customer/customer_name'
            ,customer_email   varchar2(100)  path 'customer/customer_email'
            ,venue_id         number         path 'venue/venue_id'
            ,venue_name       varchar2(100)  path 'venue/venue_name'
            ,event_series     xmltype        path 'event_series_listing/event_series'
    ) c,
    xmltable('event_series' passing c.event_series
        columns
            event_series_id  number          path 'event_series_id'
            ,event_series_name varchar2(100) path 'event_series_name'
            ,first_event_date date           path 'first_event_date'
            ,last_event_date  date           path 'last_event_date'
            ,series_events   number          path 'series_events'
            ,series_tickets   number         path 'series_tickets'
    ) es;