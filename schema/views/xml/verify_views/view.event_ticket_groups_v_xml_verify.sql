create or replace view event_ticket_groups_v_xml_verify as
with base as
(
    select
        venue_id
        ,event_id
        ,xml_doc
    from event_ticket_groups_v_xml
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
    ,g.ticket_group_id
    ,g.price_category
    ,g.price
    ,g.tickets_available
    ,g.currently_assigned
    ,g.sold_by_venue
from 
    base b,
    xmltable('/event_ticket_groups' passing b.xml_doc 
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
            ticket_group_id     number        path 'ticket_group_id'
            ,price_category     varchar2(50)  path 'price_category'
            ,price              number        path 'price'
            ,tickets_available  number        path 'tickets_available'
            ,currently_assigned number        path 'currently_assigned'
            ,sold_by_venue      number        path 'sold_by_venue'
    ) g;