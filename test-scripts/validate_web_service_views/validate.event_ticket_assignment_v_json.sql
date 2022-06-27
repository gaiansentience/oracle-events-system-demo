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
from event_ticket_assignment_v
minus
select
    venue_id
    ,venue_id_json as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,event_id
    ,event_id_json as event_id_doc
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
from event_ticket_assignment_v_json_verify