--json view validates
--xml view will not validate (see xml anomaly folder)
--tickets_available does not match the number reported in ticket_status in the xml_verify view
(select
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
from tickets_available_all_v
minus
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
from tickets_available_all_v_json_verify)
union all
(select
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
from tickets_available_all_v
minus
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
from tickets_available_all_v_xml_verify)