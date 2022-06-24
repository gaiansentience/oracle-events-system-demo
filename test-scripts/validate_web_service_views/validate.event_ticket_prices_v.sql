(
select
    venue_id
    ,venue_id as venue_id_doc
    ,venue_name
    ,event_id
    ,event_id as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,event_tickets_available
    ,ticket_group_id
    ,price_category
    ,price
    ,tickets_available
    ,tickets_sold
    ,tickets_remaining
from event_ticket_prices_v
minus
select
    venue_id
    ,venue_id_json as venue_id_doc
    ,venue_name
    ,event_id
    ,event_id_json as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,event_tickets_available
    ,ticket_group_id
    ,price_category
    ,price
    ,tickets_available
    ,tickets_sold
    ,tickets_remaining
from event_ticket_prices_v_json_verify
)
union all
(
select
    venue_id
    ,venue_id as venue_id_doc
    ,venue_name
    ,event_id
    ,event_id as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,event_tickets_available
    ,ticket_group_id
    ,price_category
    ,price
    ,tickets_available
    ,tickets_sold
    ,tickets_remaining
from event_ticket_prices_v
minus
select
    venue_id
    ,venue_id_xml as venue_id_doc
    ,venue_name
    ,event_id
    ,event_id_xml as event_id_doc
    ,event_name
    ,trunc(event_date) as event_date
    ,event_tickets_available
    ,ticket_group_id
    ,price_category
    ,price
    ,tickets_available
    ,tickets_sold
    ,tickets_remaining
from event_ticket_prices_v_xml_verify
)