--querying test table shows same values for tickets_available and the number in ticket_status
--querying the xml view directly yields the wrong value for tickets_available
--the value in tickets_available matches the value of group_tickets_available

----  CREATE OR REPLACE FORCE EDITIONABLE VIEW "EVENT_SYSTEM"."TICKETS_AVAILABLE_VENUE_V_XML_VERIFY" ("VENUE_ID", "VENUE_ID_XML", "VENUE_NAME", "EVENT_ID", "EVENT_ID_XML", "EVENT_NAME", "EVENT_DATE", "EVENT_TICKETS_AVAILABLE", "PRICE_CATEGORY", "TICKET_GROUP_ID", "PRICE", "GROUP_TICKETS_AVAILABLE", "GROUP_TICKETS_SOLD", "GROUP_TICKETS_REMAINING", "RESELLER_ID", "RESELLER_NAME", "TICKETS_AVAILABLE", "TICKET_STATUS") AS 
  with base as
(
    select
        venue_id
        ,event_id
        ,xml_doc
    from 
--    a_test_venue
    tickets_available_venue_v_xml
    where event_id = 42
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
    ,r.reseller_id
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
            ,tickets_available number        path 'tickets_available'
            ,ticket_status     varchar2(100) path 'ticket_status'            
    ) r;

