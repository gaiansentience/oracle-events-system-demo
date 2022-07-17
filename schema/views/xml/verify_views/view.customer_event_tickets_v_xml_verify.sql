create or replace view customer_event_tickets_v_xml_verify as
with base as
(
    select
        customer_id
        ,event_id
        ,xml_doc
    from customer_event_tickets_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    --where rownum >= 1    
)
select 
    b.customer_id
    ,e.customer_id as customer_id_xml
    ,e.customer_name
    ,e.customer_email
    ,e.venue_id
    ,e.venue_name
    ,e.event_series_id
    ,b.event_id
    ,e.event_id as event_id_xml
    ,e.event_name
    ,e.event_date
    ,e.event_tickets
    ,p.ticket_group_id
    ,p.price_category
    ,p.ticket_sales_id
    ,p.ticket_quantity
    ,p.sales_date
    ,p.reseller_id
    ,p.reseller_name
    ,t.ticket_id
    ,t.serial_code
    ,t.status
from 
    base b,
    xmltable('/customer_tickets' passing b.xml_doc 
        columns
            customer_id      number        path 'customer/customer_id'
            ,customer_name   varchar2(100) path 'customer/customer_name'
            ,customer_email  varchar2(100) path 'customer/customer_email'
            ,venue_id        number        path 'event/venue/venue_id'
            ,venue_name      varchar2(100) path 'event/venue/venue_name'
            ,event_series_id number        path 'event/event_series_id'
            ,event_id        number        path 'event/event_id'
            ,event_name      varchar2(100) path 'event/event_name'
            ,event_date      date          path 'event/event_date'
            ,event_tickets   number        path 'event/event_tickets'
            ,purchase        xmltype       path 'event/purchases/purchase'
    ) e,
    xmltable('/purchase' passing e.purchase 
        columns
            ticket_group_id   number        path 'ticket_group_id'
            ,price_category   varchar2(50)  path 'price_category'
            ,ticket_sales_id  number        path 'ticket_sales_id'
            ,ticket_quantity  number        path 'ticket_quantity'
            ,sales_date       date          path 'sales_date'
            ,reseller_id      number        path 'reseller_id'
            ,reseller_name    varchar2(100) path 'reseller_name'
            ,ticket           xmltype       path 'tickets/ticket'
    ) p,
    xmltable('/ticket' passing p.ticket
        columns
            ticket_id    number path 'ticket_id'
            ,serial_code varchar2(100) path 'serial_code'
            ,status      varchar2(20) path 'status'
    ) t;