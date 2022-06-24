--tickets_available should have the same number as ticket_status
--the xml view is showing the the value from group tickets available in the ticket_status_text
select
    venue_id
    ,venue_name
    ,event_id
    ,event_name
    ,trunc(event_date) as event_date
    ,event_tickets_available
    ,price_category
    ,ticket_group_id
    ,price
    ,group_tickets_available
    ,group_tickets_sold
    ,group_tickets_remaining
    ,reseller_id
    ,reseller_name
    ,tickets_available
    ,ticket_status
    ,'view' as source
from tickets_available_all_v where event_id = 42 and reseller_id is null
union all
select
    venue_id
    ,venue_name
    ,event_id
    ,event_name
    ,trunc(event_date) as event_date
    ,event_tickets_available
    ,price_category
    ,ticket_group_id
    ,price
    ,group_tickets_available
    ,group_tickets_sold
    ,group_tickets_remaining
    ,reseller_id
    ,reseller_name
    ,tickets_available
    ,ticket_status
    ,'xml' as source
from tickets_available_all_v_xml_verify where event_id = 42 and reseller_id is null