create or replace view tickets_available_reseller_v_xml_verify as
with base as
(
    select
        venue_id
        ,event_id
        ,reseller_id
        ,xml_doc
    from tickets_available_reseller_v_xml
)
select
    b.venue_id
    ,e.venue_id as venue_id_xml
    ,e.venue_name
    ,b.event_id
    ,e.event_id as event_id_xml
    ,e.event_name
    ,e.event_date
    ,e.event_tickets_available
    ,g.price_category
    ,g.ticket_group_id
    ,g.price
    ,g.group_tickets_available
    ,g.group_tickets_sold
    ,g.group_tickets_remaining
    ,b.reseller_id
    ,r.reseller_id reseller_id_xml
    ,r.reseller_name
    ,r.tickets_available
    ,r.ticket_status
from
    base b,
    xmltable('/event_ticket_availability' passing b.xml_doc
        columns
            venue_id                  number        path 'event/venue/venue_id'
            ,venue_name               varchar2(100) path 'event/venue/venue_name'
            ,event_id                 number        path 'event/event_id'
            ,event_name               varchar2(100) path 'event/event_name'
            ,event_date               date          path 'event/event_date'
            ,event_tickets_available  number        path 'event/event_tickets_available'
            ,ticket_group             xmltype       path 'ticket_groups/ticket_group'
    ) e,
    xmltable('/ticket_group' passing e.ticket_group
        columns
            ticket_group_id          number        path 'ticket_group_id'
            ,price_category          varchar2(50)  path 'price_category'
            ,price                   number        path 'price'
            ,group_tickets_available number        path 'group_tickets_available'
            ,group_tickets_sold      number        path 'group_tickets_sold'
            ,group_tickets_remaining number        path 'group_tickets_remaining'
            ,reseller                xmltype       path 'ticket_resellers/reseller'
    ) g,
    xmltable('/reseller' passing g.reseller
        columns
            reseller_id        number        path 'reseller_id'
            ,reseller_name     varchar2(100) path 'reseller_name'
            ,tickets_available varchar2(100) path 'tickets_available'
            ,ticket_status     varchar2(100) path 'ticket_status'            
    ) r;