create or replace view customer_event_series_tickets_v_xml_verify as
with base as
(
    select
        customer_id
        ,event_series_id
        ,xml_doc
    from customer_event_series_tickets_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    where rownum >= 1    
)
select 
    b.customer_id
    ,es.customer_id as customer_id_xml
    ,es.customer_name
    ,es.customer_email
    ,es.venue_id
    ,es.venue_name
    ,b.event_series_id
    ,es.event_series_id as event_series_id_xml
    ,es.event_name
    ,es.first_event_date
    ,es.last_event_date
    ,es.series_tickets
    ,e.event_id
    ,e.event_date
    ,e.event_tickets
    ,p.ticket_group_id
    ,p.price_category
    ,p.ticket_sales_id
    ,p.ticket_quantity
    ,p.sales_date
    ,p.reseller_id
    ,p.reseller_name
from 
    base b,
    xmltable('/customer_tickets' passing b.xml_doc 
        columns
            customer_id       number        path 'customer/customer_id'
            ,customer_name    varchar2(100) path 'customer/customer_name'
            ,customer_email   varchar2(100) path 'customer/customer_email'
            ,venue_id         number        path 'event_series/venue/venue_id'
            ,venue_name       varchar2(100) path 'event_series/venue/venue_name'
            ,event_series_id  number        path 'event_series/event_series_id'
            ,event_name       varchar2(100) path 'event_series/event_name'
            ,first_event_date date          path 'event_series/first_event_date'
            ,last_event_date  date          path 'event_series/last_event_date'
            ,series_tickets   number        path 'event_series/series_tickets'
            ,series_events    xmltype       path 'events/event'
    ) es,
    xmltable('/event' passing es.series_events
        columns
            event_id         number        path 'event_id'
            ,event_date      date          path 'event_date'
            ,event_tickets   number        path 'event_tickets'
            ,ticket_purchase xmltype       path 'event_ticket_purchases/ticket_purchase'
    ) e,
    xmltable('/ticket_purchase' passing e.ticket_purchase 
        columns
            ticket_group_id   number        path 'ticket_group_id'
            ,price_category   varchar2(50)  path 'price_category'
            ,ticket_sales_id  number        path 'ticket_sales_id'
            ,ticket_quantity  number        path 'ticket_quantity'
            ,sales_date       date          path 'sales_date'
            ,reseller_id      number        path 'reseller_id'
            ,reseller_name    varchar2(100) path 'reseller_name'
    ) p;