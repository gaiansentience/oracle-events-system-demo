create or replace view customer_events_v_xml_verify as
with base as
(
    select
        customer_id
        ,venue_id
        ,xml_doc
    from customer_events_v_xml
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
    ,e.event_series_id
    ,e.event_id
    ,e.event_name
    ,e.event_date
    ,e.event_tickets
from 
    base b,
    xmltable('/customer_events' passing b.xml_doc 
        columns
            customer_id      number        path 'customer/customer_id'
            ,customer_name   varchar2(100) path 'customer/customer_name'
            ,customer_email  varchar2(100) path 'customer/customer_email'
            ,venue_id        number        path 'venue/venue_id'
            ,venue_name      varchar2(100) path 'venue/venue_name'
            ,event           xmltype       path 'event_listing/event'
    ) c,
    xmltable('/event' passing c.event
        columns
            event_series_id  number        path 'event_series_id'
            ,event_id        number        path 'event_id'
            ,event_name      varchar2(100) path 'event_name'
            ,event_date      date          path 'event_date'
            ,event_tickets   number        path 'event_tickets'
    ) e;