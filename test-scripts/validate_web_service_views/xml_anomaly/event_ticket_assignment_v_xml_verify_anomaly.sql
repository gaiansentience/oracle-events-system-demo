
----  CREATE OR REPLACE FORCE EDITIONABLE VIEW "EVENT_SYSTEM"."EVENT_TICKET_ASSIGNMENT_V_XML_VERIFY" ("VENUE_ID", "VENUE_ID_XML", "VENUE_NAME", "ORGANIZER_NAME", "ORGANIZER_EMAIL", "EVENT_ID", "EVENT_ID_XML", "EVENT_NAME", "EVENT_DATE", "EVENT_TICKETS_AVAILABLE", "RESELLER_ID", "RESELLER_NAME", "RESELLER_EMAIL", "TICKET_GROUP_ID", "PRICE_CATEGORY", "PRICE", "TICKETS_IN_GROUP", "TICKETS_ASSIGNED", "TICKET_ASSIGNMENT_ID", "ASSIGNED_TO_OTHERS", "MAX_AVAILABLE", "MIN_ASSIGNMENT", "SOLD_BY_RESELLER", "SOLD_BY_VENUE") AS 
  with base as
(
    select
        venue_id
        ,event_id
        ,xml_doc
    from 
    --event_ticket_assignment_v_xml
    a_test_assignment
    where event_id = 42
)
select 
    b.venue_id
    ,e.venue_id as venue_id_xml
    ,e.venue_name
    ,e.organizer_name
    ,e.organizer_email
    ,b.event_id
    ,e.event_id as event_id_xml
    ,e.event_name
    ,e.event_date
    ,e.event_tickets_available
    ,r.reseller_id
    ,r.reseller_name
    ,r.reseller_email
    ,g.ticket_group_id
    ,g.price_category
    ,g.price
    ,g.tickets_in_group
    ,g.tickets_assigned
    ,g.ticket_assignment_id
    ,g.assigned_to_others
    ,g.max_available
    ,g.min_assignment
    ,g.sold_by_reseller
    ,g.sold_by_venue    
from 
    base b,
    xmltable('/event_ticket_assignment' passing b.xml_doc 
        columns
            venue_id                  number        path 'event/venue/venue_id'
            ,venue_name               varchar2(100) path 'event/venue/venue_name'
            ,organizer_name           varchar2(100) path 'event/venue/organizer_name'
            ,organizer_email          varchar2(100) path 'event/venue/organizer_email'
            ,event_id                 number        path 'event/event_id'
            ,event_name               varchar2(100) path 'event/event_name'
            ,event_date               date          path 'event/event_date'
            ,event_tickets_available  number        path 'event/event_tickets_available'
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
            ticket_group_id       number        path 'ticket_group_id'
            ,price_category       varchar2(50)  path 'price_category'
            ,price                number        path 'price'
            ,tickets_in_group     number        path 'tickets_in_group'
            ,tickets_assigned     number        path 'tickets_assigned'
            ,ticket_assignment_id number        path 'ticket_assignment_id'
            ,assigned_to_others   number        path 'assigned_to_others'
            ,max_available        number        path 'max_available'
            ,min_assignment       number        path 'min_assignment'
            ,sold_by_reseller     number        path 'sold_by_reseller'
            ,sold_by_venue        number        path 'sold_by_venue'
    ) g;

