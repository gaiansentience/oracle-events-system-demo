(
select
    venue_id
    ,venue_id as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,venue_scheduled_events
    ,event_id
    ,event_name
    ,trunc(event_date) as event_date
    ,tickets_available
    ,tickets_remaining
from venue_events_v
minus
select
    venue_id
    ,venue_id_json as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,venue_scheduled_events
    ,event_id
    ,event_name
    ,trunc(event_date) as event_date
    ,tickets_available
    ,tickets_remaining
from venue_events_v_json_verify
)
union all
(
select
    venue_id
    ,venue_id as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,venue_scheduled_events
    ,event_id
    ,event_name
    ,trunc(event_date) as event_date
    ,tickets_available
    ,tickets_remaining
from venue_events_v
minus
select
    venue_id
    ,venue_id_xml as venue_id_doc
    ,venue_name
    ,organizer_email
    ,organizer_name
    ,max_event_capacity
    ,venue_scheduled_events
    ,event_id
    ,event_name
    ,trunc(event_date) as event_date
    ,tickets_available
    ,tickets_remaining
from venue_events_v_xml_verify
)