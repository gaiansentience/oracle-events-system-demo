--xml view will not validate
--shows all ticket groups for all events under the reseller for any given event
--(see xml anomaly folder)
select
    venue_id
    ,venue_id as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,event_id
    ,event_id as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,event_tickets_available
    ,ticket_group_id
    ,price_category
    ,price
    ,tickets_in_group
    ,tickets_assigned
    ,reseller_id
    ,reseller_name
    ,assigned_to_others
    ,ticket_assignment_id
    ,max_available
    ,min_assignment
    ,sold_by_reseller
    ,sold_by_venue
from reseller_ticket_assignment_v --where event_id = 1 and venue_id = 1;
minus
select
    venue_id
    ,venue_id_xml as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,event_id
    ,event_id_xml as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,event_tickets_available
    ,ticket_group_id
    ,price_category
    ,price
    ,tickets_in_group
    ,tickets_assigned
    ,reseller_id
    ,reseller_name
    ,assigned_to_others
    ,ticket_assignment_id
    ,max_available
    ,min_assignment
    ,sold_by_reseller
    ,sold_by_venue
from reseller_ticket_assignment_v_xml_verify --where event_id = 1 and venue_id = 1;