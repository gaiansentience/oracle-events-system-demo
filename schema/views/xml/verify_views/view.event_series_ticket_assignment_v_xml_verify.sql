create or replace view event_series_ticket_assignment_v_xml_verify as
with base as
(
    select
        venue_id
        ,event_series_id
        ,xml_doc
    from event_series_ticket_assignment_v_xml
    --workaround to force optimizer to materialize the xml and parse it
    --without workaround optimizer rewrite attempts to skip xmlagg and xmltable
    --this view causes xml anomaly (see unit test scripts for web service views)
    where rownum >= 1
)
select 
    b.venue_id
    ,e.venue_id as venue_id_xml
    ,e.venue_name
    ,e.organizer_name
    ,e.organizer_email
    ,b.event_series_id
    ,e.event_series_id as event_series_id_xml
    ,e.event_name
    ,e.first_event_date
    ,e.last_event_date
    ,e.event_tickets_available
    ,g.price_category
    ,g.price
    ,g.tickets_in_group    
    ,r.reseller_id
    ,r.reseller_name
    ,r.reseller_email
    ,g.assigned_to_others    
    ,g.tickets_assigned
    ,g.max_available
    ,g.min_assignment
    ,g.sold_by_reseller
    ,g.sold_by_venue
from 
    base b,
    xmltable('/event_series_ticket_assignment' passing b.xml_doc 
        columns
            venue_id                  number        path 'event_series/venue/venue_id'
            ,venue_name               varchar2(100) path 'event_series/venue/venue_name'
            ,organizer_name           varchar2(100) path 'event_series/venue/organizer_name'
            ,organizer_email          varchar2(100) path 'event_series/venue/organizer_email'
            ,event_series_id          number        path 'event_series/event_series_id'
            ,event_name               varchar2(100) path 'event_series/event_name'
            ,first_event_date         date          path 'event_series/first_event_date'
            ,last_event_date          date          path 'event_series/last_event_date'
            ,event_tickets_available  number        path 'event_series/event_tickets_available'
            ,reseller                 xmltype       path 'ticket_resellers/reseller'
    ) e,
    xmltable('/reseller' passing e.reseller
        columns
            reseller_id     number        path 'reseller_id'
            ,reseller_name  varchar2(100) path 'reseller_name'
            ,reseller_email varchar2(100) path 'reseller_email'
            ,ticket_group   xmltype       path 'ticket_assignments/ticket_group'
    ) r,
    xmltable('/ticket_group' passing r.ticket_group 
        columns
            price_category        varchar2(50)  path 'price_category'
            ,price                number        path 'price'
            ,tickets_in_group     number        path 'tickets_in_group'
            ,tickets_assigned     number        path 'tickets_assigned'
            ,assigned_to_others   number        path 'assigned_to_others'
            ,max_available        number        path 'max_available'
            ,min_assignment       number        path 'min_assignment'
            ,sold_by_reseller     number        path 'sold_by_reseller'
            ,sold_by_venue        number        path 'sold_by_venue'
    ) g;